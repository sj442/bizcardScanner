//
//  CONTextFieldTableViewCell.m
//  Conquer
//
//  Created by Edward Paulosky on 1/12/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONTextFieldTableViewCell.h"

#import "UIFont+Conquer.h"
#import "UIColor+Conquer.h"
#import "NSString+PList.h"

@implementation CONTextFieldTableViewCell

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setupTextField];
  }
  return self;
}

#pragma mark - Layout

- (UIEdgeInsets)layoutMargins
{
  return UIEdgeInsetsZero;
}

#pragma mark - Setup

- (void)setupTextField
{
  UITextField *textField = [UITextField new];
  self.textField = textField;
  textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  textField.font = [UIFont regularFontOfSize:15];
  textField.textColor = [UIColor conquerDarkTextColor];
  
  CGRect frame = CGRectZero;
  frame.origin.x = 16;
  frame.origin.y = 4;
  frame.size.width = CGRectGetWidth(self.contentView.frame) - 24;
  frame.size.height = CGRectGetHeight(self.contentView.frame) - 8;
  textField.frame = frame;
  
  textField.placeholder = @"Placeholder";
  
  [self.contentView addSubview:textField];
}

@end
