//
//  Account+Manager.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "Account.h"

@interface Account (Manager)

+ (NSString *)entityName;

+ (NSFetchedResultsController *)fetchedResultsController;

+ (instancetype)newObject;

@end
