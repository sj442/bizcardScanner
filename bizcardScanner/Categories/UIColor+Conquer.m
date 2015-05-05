//
//  UIColor+Conquer.m
//  Conquer
//
//  Created by Edward Paulosky on 1/16/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "UIColor+Conquer.h"

@implementation UIColor (Conquer)

+ (UIColor *)conquerGreenColor
{
  return [UIColor colorWithRed:34/255.0 green:192/255.0 blue:100/255.0 alpha:1.0];
}

+ (UIColor *)conquerBlueColor
{
  return [UIColor colorWithRed:28/255.0 green:91/255.0 blue:249/255.0 alpha:1.0];
}

+ (UIColor *)conquerSplashBlueColor
{
  return [UIColor colorWithRed:65/255.0 green:113/255.0 blue:180/255.0 alpha:1.0];
}

+ (UIColor *)conquerUnselectedGrayColor
{
  return [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1.0];
}

+ (UIColor *)conquerGroupedTableViewBackgroundColor
{
  return [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
}

+ (UIColor *)conquerNavigationTitleColor
{
  return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
}

+ (UIColor *)conquerDarkTextColor
{
  return [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0];
}

+ (UIColor *)conquerLightTextColor
{
  return [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
}

+ (UIColor *)conquerExtraLightTextColor
{
  return [UIColor colorWithWhite:167/255.0 alpha:1.0];
}

+ (UIColor *)conquerTableViewSectionTitleColor
{
  return [UIColor colorWithRed:124/255.0 green:124/255.0 blue:124/255.0 alpha:1.0];
}

+ (UIColor *)conquerAMColor
{
  return [self conquerExtraLightTextColor];
}

+ (UIColor *)conquerPMColor
{
  return [self conquerDarkTextColor];
}

@end
