//
//  BizCard.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 5/1/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BizCard : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * dateProcessed;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSNumber * isExported;
@property (nonatomic, retain) NSNumber * isValidated;
@property (nonatomic, retain) id responseData;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) id webLinks;
@property (nonatomic, retain) id phoneNumbers;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) id address;
@property (nonatomic, retain) id emails;
@property (nonatomic, retain) NSString *notes;

@end
