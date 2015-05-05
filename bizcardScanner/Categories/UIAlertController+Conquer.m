//
//  UIAlertController+Conquer.m
//  Conquer
//
//  Created by Edward Paulosky on 1/16/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "UIAlertController+Conquer.h"

@implementation UIAlertController (Conquer)

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *action = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
  
  [alert addAction:action];
  
  return alert;
}

+ (instancetype)alertWithActivityIndicatorAndTitle:(NSString *)title message:(NSString *)message
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  activityIndicator.center = CGPointMake(130.5, 78);
  [activityIndicator startAnimating];
  [alert.view addSubview:activityIndicator];
  
  return alert;
}

@end
