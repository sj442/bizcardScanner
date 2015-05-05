//
//  Contact+Manager.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "Contact.h"

@interface Contact (Manager)

+ (NSString *)entityName;

+ (instancetype)newObject;

+ (NSFetchedResultsController *)fetchedResultsController;

@end
