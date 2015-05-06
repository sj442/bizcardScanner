//
//  CONBizcardDetailViewController.h
//  Conquer
//
//  Created by Sunayna Jain on 3/24/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

/*

- custom Accessors
 
- set up nav bar, table View
 
- TableView DataSource
 
- TableView Delegate
 
- TextField Delegate
 
- Common Selection Delegate
 
*/


@class BizCard;

@interface CONBizcardDetailTableViewController : UITableViewController

- (instancetype)initWithBizcard:(NSManagedObjectID *)objectID;

@end
