//
//  CONTextViewTableViewCell.h
//  Conquer
//
//  Created by Edward Paulosky on 1/25/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CONPlaceholderTextView.h"

@interface CONTextViewTableViewCell : UITableViewCell

@property (weak, nonatomic) CONPlaceholderTextView *textView;

+ (CGFloat)heightForCellWithWidth:(CGFloat)width text:(NSString *)text;

@end
