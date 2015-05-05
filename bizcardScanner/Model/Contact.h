//
//  Contact.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) id phoneNumbers;
@property (nonatomic, retain) id webLinks;
@property (nonatomic, retain) NSSet *accounts;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end
