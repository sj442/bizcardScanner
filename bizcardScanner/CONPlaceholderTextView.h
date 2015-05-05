//
//  CONCustomTextView.h
//  Conquer
//
//  Created by Leo Reubelt on 2/9/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONPlaceholderTextView : UITextView

@property (copy, nonatomic) NSString *placeholder;

@property (weak, nonatomic) UITextView *placeholderTextView;

@end
