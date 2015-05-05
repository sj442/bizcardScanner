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

@property (strong, nonatomic) NSManagedObjectID *objectID;

@end

@implementation BizcardOperation

- (instancetype)initWithManagedObjectID:(NSManagedObjectID *)objectID
{
  self = [super init];
  if (self) {
    self.objectID = objectID;
  }
  return self;
}

- (void)main
{
  BizCard *bizcard = (BizCard *)[[DataManager sharedManager].mainContext objectWithID:self.objectID];
  
  NSString *fileName = bizcard.fileName;
  NSString *documentsPath = [BizCard documentsDirectory];
  NSString *url = [documentsPath stringByAppendingPathComponent:fileName];
  
  NSData *pngData = [NSData dataWithContentsOfFile:url options:0 error:nil];
  UIImage *image = [UIImage imageWithData:pngData];
  
  if (!image) {
    [self cancel];
    return;
  }
  
  [[CONABBYYManager sharedManager] processBusinessCardFrontImage:image backImage:nil completion:^(NSDictionary *cardData) {
    NSManagedObject *object = [[DataManager sharedManager].mainContext objectWithID:self.objectID];
    BizCard *b = (BizCard *)object;
    b.responseData = cardData;
    b.dateProcessed = [NSDate date];
    [[DataManager sharedManager] saveContext:NO];
  }];
}

@end
