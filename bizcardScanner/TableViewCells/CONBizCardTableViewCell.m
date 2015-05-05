//
//  CONBizCardTableViewCell.m
//  Conquer
//
//  Created by Sunayna Jain on 3/20/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONBizCardTableViewCell.h"

#import "UIColor+Conquer.h"

@implementation CONBizCardTableViewCell

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setupNameLabel];
    
    [self setupEmailLabel];
    
    [self setupDateLabel];
  }
  return self;
}

#pragma mark - Layout

- (UIEdgeInsets)layoutMargins
{
  return UIEdgeInsetsZero;
}


- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [self setDateLabelFrame];
}


- (void)setupNameLabel
{
  UILabel *label = [UILabel new];
  self.nameLabel = label;
  
  label.font = [UIFont boldSystemFontOfSize:14];
  label.textColor = [UIColor conquerDarkTextColor];
  
  CGRect frame = CGRectZero;
  frame.origin.x = 16;
  frame.origin.y = 5;
  frame.size.width = 260;
  frame.size.height = 18;
  label.frame = frame;
  
  [self.contentView addSubview:label];
}


- (void)setupEmailLabel
{
  UILabel *label = [UILabel new];
  self.emailLabel = label;
  
  label.font = [UIFont systemFontOfSize:12];
  label.textColor = [UIColor conquerDarkTextColor];
  
  CGRect frame = CGRectZero;
  frame.origin.x = 16;
  frame.origin.y = CGRectGetMaxY(self.nameLabel.frame);
  frame.size.width = 200;
  frame.size.height = 18;
  label.frame = frame;
  
  [self.contentView addSubview:label];
}

- (void)setupDateLabel
{
  UILabel *label = [UILabel new];
  self.dateLabel = label;
  
  label.font = [UIFont systemFontOfSize:11];
  label.textColor = [UIColor conquerLightTextColor];
  label.textAlignment = NSTextAlignmentRight;
  
  [self setDateLabelFrame];
  
  [self.contentView addSubview:label];
}

- (void)setDateLabelFrame
{
  CGRect frame = CGRectZero;
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - 70;
  frame.origin.y = CGRectGetHeight(self.contentView.frame)/2 - 9;
  frame.size.width = 60;
  frame.size.height = 18;
  self.dateLabel.frame = frame;
}

- (void)showActivityIndicator
{
  UIActivityIndicatorView *view = [UIActivityIndicatorView new];
  view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  self.activityIndicator = view;
  
  CGRect frame = CGRectZero;
  
  frame.origin.x = 0;
  frame.origin.y = 0;
  frame.size.width = 44;
  frame.size.height = 44;
  self.activityIndicator.frame = frame;
  [view startAnimating];
  
  self.accessoryView = self.activityIndicator;
}


- (void)showNoConnectionAvailable
{
  UIImageView *iv = [UIImageView new];
  
  CGRect frame = CGRectZero;
  
  frame.origin.x = 0;
  frame.origin.y = 0;
  frame.size.width = 30;
  frame.size.height = 30;
  
  iv.frame = frame;
  
  iv.image = [UIImage imageNamed:@"errorIcon"];
  self.accessoryView = iv;
}


- (void)setActivityIndicatorFrame
{
  CGFloat rightMargin = 10;

  CGRect frame = CGRectZero;
  frame.size.height = 24;
  frame.size.width = CGRectGetHeight(frame);
  frame.origin.x = CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(frame) - rightMargin;
  frame.origin.y = (CGRectGetHeight(self.contentView.bounds) - CGRectGetHeight(frame)) / 2;
  self.activityIndicator.frame = frame;
}


- (void)hideAccessoryView
{
  self.accessoryView = nil;
}

@end
