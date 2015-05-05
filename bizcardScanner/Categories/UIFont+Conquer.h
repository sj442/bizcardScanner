//
//  UIFont+Conquer.h
//  Conquer
//
//  Created by Edward Paulosky on 1/7/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Conquer)

+ (instancetype)boldFontOfSize:(CGFloat)size;
+ (instancetype)boldItalicFontOfSize:(CGFloat)size;
+ (instancetype)boldExtraFontOfSize:(CGFloat)size;
+ (instancetype)boldExtraItalicFontOfSize:(CGFloat)size;
+ (instancetype)italicFontOfSize:(CGFloat)size;
+ (instancetype)lightFontOfSize:(CGFloat)size;
+ (instancetype)lightItalicFontOfSize:(CGFloat)size;
+ (instancetype)regularFontOfSize:(CGFloat)size;
+ (instancetype)semiboldFontOfSize:(CGFloat)size;
+ (instancetype)semiboldItalicFontOfSize:(CGFloat)size;

@end
