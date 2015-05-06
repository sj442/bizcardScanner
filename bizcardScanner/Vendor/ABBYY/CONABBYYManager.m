//
//  EPABBYYManager.m
//  EPBusinessCardReader
//
//  Created by Leo Reubelt on 2/12/15.
//  Copyright (c) 2015 EnHatch. All rights reserved.
//

#import "CONABBYYManager.h"
#import "CONABBYYResultParser.h"
#import "ActivationInfo.h"
#import "ABBYYTask.h"
#import "ProcessingOperation.h"
#import "NSString+Base64.h"

@interface CONABBYYManager ()

@property (copy, nonatomic) void (^cardCompletion)(NSDictionary *);

@property (nonatomic) BOOL willProcessBackImage;
@property (nonatomic) BOOL isProcessingBackImage;

@property (nonatomic) BOOL isProcessingCard;

@property (strong, nonatomic) NSMutableArray *cardsData;

@end

@implementation CONABBYYManager

static NSString *EPABBYYapplicationID = @"bizcardReaderApp";
static NSString *EPABBYYPassword = @"R8TSPPa5X357JFYVzBBQ/Sj+";

#pragma mark - Lifecycle

+ (instancetype)sharedManager
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    
    sharedInstance = [[self alloc] init];
    
  });
  
  return sharedInstance;
}

- (NSMutableArray *)cardsData
{
  if (!_cardsData) {
    _cardsData = [NSMutableArray new];
  }
  
  return _cardsData;
}

#pragma mark - Private - Authorization

- (NSString*)authString
{
  NSString *encodedCredentials = [[NSString stringWithFormat:@"%@:%@", EPABBYYapplicationID, EPABBYYPassword] base64EncodedString];
  
  return [NSString stringWithFormat:@"Basic %@", encodedCredentials];
}

#pragma mark - Public - Process Text Image

- (void)processImages:(NSArray *)images completion:(void (^)(NSArray *cardsData))completion
{
  __block NSMutableArray *mutableImages = [NSMutableArray arrayWithArray:images];
  __weak CONABBYYManager *weakSelf = self;
  
  [self processImage:[mutableImages firstObject] completion:^(NSDictionary *cardData) {
    
    [weakSelf.cardsData addObject:cardData];
    
    [mutableImages removeObjectAtIndex:0];
    
    if ([mutableImages count] > 0) {
      [self processImages:mutableImages completion:completion];
    } else {
      completion(weakSelf.cardsData);
    }
  }];
}

- (void)processImage:(UIImage*)image completion:(void (^)(NSDictionary *cardData))completion
{
  self.isProcessingCard = NO;
  
  NSParameterAssert(image);
  NSParameterAssert(completion);
  
  self.cardCompletion = completion;
  
  NSURL* processingURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.ocrsdk.com/processImage?language=English&exportFormat=txt"]];
  
  NSMutableURLRequest* processingRequest = [NSMutableURLRequest requestWithURL:processingURL];
  
  [processingRequest setHTTPMethod:@"POST"];
  [processingRequest setValue:@"applicaton/octet-stream" forHTTPHeaderField:@"Content-Type"];
  [processingRequest setHTTPBody:UIImageJPEGRepresentation(image, 0.5)];
  
  [processingRequest setValue:[self authString] forHTTPHeaderField:@"Authorization"];
  
  HTTPOperation *uploadOperation = [[HTTPOperation alloc] initWithRequest:processingRequest
                                                                   target:self
                                                           finishedAction:@selector(uploadFinished:)];
  
  [uploadOperation setAuthenticationDelegate:self];
  
  [uploadOperation start];
}

#pragma mark - Public - Process Business card Image

- (void)processBusinessCardFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage completion:(void (^)(NSDictionary *cardData))completion
{
  self.isProcessingCard = YES;
  
  __weak CONABBYYManager *weakSelf = self;
  
  if (backImage) {
    self.willProcessBackImage = YES;
  }
  
  [self processBusinessCardImage:frontImage completion:^(NSDictionary *frontCardData) {
    
    if (!weakSelf.willProcessBackImage) {
      
      completion(frontCardData);
      
    } else {
      
      weakSelf.isProcessingBackImage = YES;
      
      [self processBusinessCardImage:backImage completion:^(NSDictionary *backCardData) {
        
        NSDictionary *totalResult = [self addBackResult:backCardData toFrontResult:frontCardData];
        
        completion(totalResult);
      }];
    }
  }];
}

- (void)processBusinessCardImage:(UIImage *)businessCardImage completion:(void (^)(NSDictionary *cardData))completion
{
  self.cardCompletion = completion;

  NSParameterAssert(completion);
  NSParameterAssert(businessCardImage);
  
  NSURL* processingURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.ocrsdk.com/processBusinessCard?language=english&exportformat=xml&xml:writeFieldComponents=true"]];
  
  NSMutableURLRequest* processingRequest = [NSMutableURLRequest requestWithURL:processingURL];
  
  [processingRequest setHTTPMethod:@"POST"];
  [processingRequest setValue:@"applicaton/octet-stream" forHTTPHeaderField:@"Content-Type"];
  [processingRequest setHTTPBody:UIImageJPEGRepresentation(businessCardImage, 0.5)];
  
  [processingRequest setValue:[self authString] forHTTPHeaderField:@"Authorization"];
  
  HTTPOperation *uploadOperation = [[HTTPOperation alloc] initWithRequest:processingRequest
                                                                   target:self
                                                           finishedAction:@selector(uploadFinished:)];
  
  [uploadOperation setAuthenticationDelegate:self];
  
  [uploadOperation start];
}

#pragma mark - Private - Process Business Card

- (void)uploadFinished:(HTTPOperation*)operation
{
  if (operation.error) {
    
    NSLog(@"Upload Error");
    
    return;
  }
  
  ABBYYTask* task = [[ABBYYTask alloc] initWithData:operation.recievedData];
    
  if (task == nil || task.ID == nil) {
    NSLog(@"task was nil or task ID was nil");
    self.cardCompletion(@{});
    return;
  }
  
  NSURL* processingURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.ocrsdk.com/getTaskStatus?taskId=%@", task.ID]];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:processingURL];
  
  [request setValue:[self authString] forHTTPHeaderField:@"Authorization"];
  
  ProcessingOperation *processingOperation = [[ProcessingOperation alloc] initWithRequest:request
                                                                                   target:self
                                                                           finishedAction:@selector(processingFinished:)];
  [processingOperation setAuthenticationDelegate:self];
  
  [processingOperation start];
}

- (void)processingFinished:(HTTPOperation*)operation
{
  if (operation.error) {
    
    NSLog(@"Processing Error");
    return;
  }
  
  ABBYYTask* task = [[ABBYYTask alloc] initWithData:operation.recievedData];
  
  if (task == nil || task.downloadURL == nil) {
    NSLog(@"task error!");
    self.cardCompletion(@{});
    return;
  }
  
  NSURLRequest *request = [NSURLRequest requestWithURL:task.downloadURL];
  HTTPOperation *downloadOperation = [[ProcessingOperation alloc] initWithRequest:request
                                                                           target:self
                                                                   finishedAction:@selector(downloadFinished:)];
  [downloadOperation start];
}


- (void)downloadFinished:(HTTPOperation *)operation
{
  if (operation.error) {

    NSLog(@"Download Error");
    return;
  }
  
  if (!self.isProcessingCard) {
    
    NSString* result = [[NSString alloc] initWithData:operation.recievedData encoding:NSUTF8StringEncoding];
    self.cardCompletion(@{@"text":result});
    return;
  }
  
  [[CONABBYYResultParser alloc] initWithData:operation.recievedData completion:^(NSDictionary *cardData) {
    self.cardCompletion(cardData);
  }];
  
}


- (NSDictionary *)addBackResult:(NSDictionary *)backResult toFrontResult:(NSDictionary *)frontResult
{
  NSMutableDictionary *totalResult = [NSMutableDictionary dictionaryWithDictionary:frontResult];
  
  NSArray *backResultKeys = [backResult allKeys];
  
  for (NSString *key in backResultKeys) {
    
    NSMutableArray *totalResultsForKey = [NSMutableArray new];
    
    if ([[totalResult allKeys] containsObject:key]) {
      
      [totalResultsForKey addObjectsFromArray:[totalResult valueForKey:key]];
      
    }
    
    NSArray *backResultsForKey = [backResult valueForKey:key];
    
    [totalResultsForKey addObjectsFromArray:backResultsForKey];
    
    [totalResult setValue:totalResultsForKey forKey:key];
  }
  
  return totalResult;
}

#pragma mark - HTTPOperationAuthenticationDelegate implementation

- (BOOL)httpOperation:(HTTPOperation *)operation canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
  return YES;
}

- (void)httpOperation:(HTTPOperation *)operation didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
  if ([challenge previousFailureCount] == 0) {
    
    NSURLCredential* credential = [NSURLCredential credentialWithUser:EPABBYYapplicationID
                                                             password:EPABBYYPassword
                                                          persistence:NSURLCredentialPersistenceForSession];
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    
  } else {
    
    [[challenge sender] cancelAuthenticationChallenge:challenge];
    
    NSLog(@"Challenge Error");
  }
}

@end