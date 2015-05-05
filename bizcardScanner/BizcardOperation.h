//
//  BizcardOperation.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BizcardOperation : NSOperation

- (instancetype)initWithManagedObjectID:(NSManagedObjectID *)objectID;

@end
