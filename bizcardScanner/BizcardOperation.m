 //
//  BizcardOperation.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "BizcardOperation.h"
#import "CONABBYYManager.h"
#import "BizCard+Manager.h"

#import "DataManager.h"

@interface BizcardOperation ()

@property (assign, nonatomic) BOOL isExecuting;
@property (assign, nonatomic) BOOL isFinished;

@end

@implementation BizcardOperation

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;

- (instancetype)initWithManagedObjectID:(NSManagedObjectID *)objectID
{
  self = [super init];
  if (self) {
    self.objectID = objectID;
  }
  return self;
}


- (void)start
{
  BizCard *bizcard = (BizCard *)[[DataManager sharedManager].mainContext objectWithID:self.objectID];
  
  [self willChangeValueForKey:@"isExecuting"];
  _isExecuting = YES;
  [self didChangeValueForKey:@"isExecuting"];
  
  NSString *fileName = bizcard.fileName;
  NSString *documentsPath = [BizCard documentsDirectory];
  NSString *url = [documentsPath stringByAppendingPathComponent:fileName];
  
  NSData *pngData = [NSData dataWithContentsOfFile:url options:0 error:nil];
  UIImage *image = [UIImage imageWithData:pngData];
  
  if (!image) {
    [self cancel];
    
    [self finish];
    return;
  }
  
  [[CONABBYYManager sharedManager] processBusinessCardFrontImage:image backImage:nil completion:^(NSDictionary *cardData) {
    
    NSManagedObject *object = [[DataManager sharedManager].mainContext objectWithID:self.objectID];
    BizCard *b = (BizCard *)object;
    b.responseData = cardData;
    b.dateProcessed = [NSDate date];
    [[DataManager sharedManager] saveContext:NO];
    [self finish];
  }];
}

- (void)finish
{
  [self willChangeValueForKey:@"isExecuting"];
  _isExecuting = NO;
  [self didChangeValueForKey:@"isExecuting"];
  
  [self willChangeValueForKey:@"isFinished"];
  _isFinished = YES;
  [self didChangeValueForKey:@"isFinished"];
}

@end
