//
//  CONCustomTextView.m
//  Conquer
//
//  Created by Leo Reubelt on 2/9/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONPlaceholderTextView.h"

@interface CONPlaceholderTextView ()

@end

@implementation CONPlaceholderTextView

#pragma mark - Lifecycle

- (instancetype)init
{
  self = [super init];
  if (self) {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
  }
  
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - Private - Custom Setter

- (void)setPlaceholder:(NSString *)placeholder
{
  if (!self.placeholderTextView) {
    
    UITextView *placeholderTextView = [UITextView new];
    self.placeholderTextView = placeholderTextView;
    [self addSubview:placeholderTextView];
    [self sendSubviewToBack:placeholderTextView];
    
    placeholderTextView.frame = self.bounds;
    placeholderTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    placeholderTextView.font = self.font;
    placeholderTextView.textContainerInset = self.textContainerInset;
    placeholderTextView.textColor = [UIColor lightGrayColor];
    placeholderTextView.userInteractionEnabled = NO;
  }
  
  self.placeholderTextView.text = placeholder;
  
  _placeholder = placeholder;
}

#pragma mark - Private - Handle Text Did Change

- (void)textDidChange:(NSNotification *)notification
{
  UITextView *textView = notification.object;
  
  if (textView != self) {
    return;
  }
  
  if (textView.text && ![textView.text isEqualToString:@""]) {
    self.placeholderTextView.hidden = YES;
  } else {
    self.placeholderTextView.hidden = NO;
  }
}

@end
