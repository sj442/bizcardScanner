//
//  UIAlertController+Conquer.h
//  Conquer
//
//  Created by Edward Paulosky on 1/16/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Conquer)

/*
 Returns an instance of UIAlertController with style: UIAlertControllerStyleAlert
 Adds an UIAlertAction with style: UIAlertActionStyleCancel and title: "Close"
*/
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;


/*
 Returns an instance of UIAlertController with style: UIAlertControllerStyleAlert
 Adds an UIActivityIndicatorView to the alert
 There are no UIAlertActions added 
 The presenting view controller must dismiss this alert
 */
+ (instancetype)alertWithActivityIndicatorAndTitle:(NSString *)title message:(NSString *)message;

@end
