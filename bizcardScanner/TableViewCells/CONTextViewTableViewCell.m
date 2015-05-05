//
//  CONTextViewTableViewCell.m
//  Conquer
//
//  Created by Edward Paulosky on 1/25/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONTextViewTableViewCell.h"

#import "UIFont+Conquer.h"
#import "UIColor+Conquer.h"

@implementation CONTextViewTableViewCell

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self setupTextView];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

#pragma mark - Layout

- (UIEdgeInsets)layoutMargins
{
  return UIEdgeInsetsZero;
}

#pragma mark - Setup

- (void)setupTextView
{
  if (self.textView) {
    
    return;
  }
  
  CONPlaceholderTextView *textView = [CONPlaceholderTextView new];
  self.textView = textView;
  [self.contentView addSubview:textView];
  
  textView.clipsToBounds = NO;
  textView.font = [UIFont systemFontOfSize:16];
  textView.textColor = [UIColor darkTextColor];
  textView.textContainerInset = UIEdgeInsetsMake(4, 15, 4, 15);
  textView.textContainer.lineFragmentPadding = 0;
  textView.scrollEnabled = NO;
  textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
  [self setTextViewFrame];
}

- (void)setTextViewFrame
{
  CGRect frame = CGRectZero;
  frame.size.width = CGRectGetWidth(self.bounds);
  frame.size.height = 44.0;
  self.textView.frame = frame;
}

+ (CGFloat)heightForCellWithWidth:(CGFloat)width text:(NSString *)text
{
  UIFont *font = [UIFont systemFontOfSize:16];
  
  width -= 30;
  NSDictionary *attributes = @{NSFontAttributeName: font};
  
  CGRect rect = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes
                                   context:nil];
  
  return MAX(88, ceil(CGRectGetHeight(rect) + 16));
}

@end
