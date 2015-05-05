//
//  EPABBYYResultParser.h
//  EPBusinessCardReader
//
//  Created by Leo Reubelt on 2/16/15.
//  Copyright (c) 2015 EnHatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CONABBYYResultParser : NSXMLParser <NSXMLParserDelegate>

+ (void)parseData:(NSData *)data completion:(void (^)(NSDictionary *cardData))completion;

- (instancetype)initWithData:(NSData *)data completion:(void (^)(NSDictionary *cardData))completion;

@end
