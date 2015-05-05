//
//  Account.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id address;
@property (nonatomic, retain) id webLinks;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * modifiedDate;
@property (nonatomic, retain) id phoneNumbers;
@property (nonatomic, retain) NSSet *contacts;

@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addContactsObject:(NSManagedObject *)value;
- (void)removeContactsObject:(NSManagedObject *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
