//
//  UIFont+Conquer.m
//  Conquer
//
//  Created by Edward Paulosky on 1/7/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "UIFont+Conquer.h"

@implementation UIFont (Conquer)

+ (instancetype)boldFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Bold" size:size];
}

+ (instancetype)boldItalicFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"Open Sans Bold Italic" size:size];
}

+ (instancetype)boldExtraFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Extrabold" size:size];
}

+ (instancetype)boldExtraItalicFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Extrabold-Italic" size:size];
}

+ (instancetype)italicFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Italic" size:size];
}

+ (instancetype)lightFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Light" size:size];
}

+ (instancetype)lightItalicFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-LightItalic" size:size];
}

+ (instancetype)regularFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"Open Sans" size:size];
}

+ (instancetype)semiboldFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
}

+ (instancetype)semiboldItalicFontOfSize:(CGFloat)size
{
  return [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:size];
}

@end
