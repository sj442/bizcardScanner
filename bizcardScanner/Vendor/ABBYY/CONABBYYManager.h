//
//  EPABBYYManager.h
//  EPBusinessCardReader
//
//  Created by Leo Reubelt on 2/12/15.
//  Copyright (c) 2015 EnHatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HTTPOperation.h"

@interface CONABBYYManager : NSObject <NSXMLParserDelegate, HTTPOperationAuthenticationDelegate>

+ (instancetype)sharedManager;

- (void)processImage:(UIImage*)image completion:(void (^)(NSDictionary *cardData))completion;
- (void)processBusinessCardFrontImage:(UIImage *)frontImage backImage:(UIImage *)backImage completion:(void (^)(NSDictionary *cardData))completion;

@end
