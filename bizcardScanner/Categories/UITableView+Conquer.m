//
//  UITableView+Conquer.m
//  Conquer
//
//  Created by Edward Paulosky on 1/22/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "UITableView+Conquer.h"

@implementation UITableView (Conquer)

- (void)hideEmptyCells
{
  self.tableFooterView = [UIView new];
}

@end
