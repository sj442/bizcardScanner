//
//  CONBizCardTableViewCell.h
//  Conquer
//
//  Created by Sunayna Jain on 3/20/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CONBizCardTableViewCell : UITableViewCell

@property (weak, nonatomic) UILabel *nameLabel;

@property (weak, nonatomic) UILabel *emailLabel;

@property (weak, nonatomic) UILabel *dateLabel;

@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) UIButton *checkMarkAccessoryView;

- (void)showNoConnectionAvailable;

- (void)showActivityIndicator;

- (void)hideAccessoryView;

@end
