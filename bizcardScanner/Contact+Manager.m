//
//  Contact+Manager.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "Contact+Manager.h"
#import "DataManager.h"

@implementation Contact (Manager)

+ (NSString *)entityName
{
  return @"Contact";
}

+ (instancetype)newObject
{
  NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[DataManager sharedManager].mainContext];
  Contact *contact = (Contact *)object;
  contact.createdDate = [NSDate date];
  return (Contact *)object;
}

+ (NSFetchedResultsController *)fetchedResultsController
{
  NSSortDescriptor *createdDate = [[NSSortDescriptor alloc] initWithKey:@"createdDate" ascending:NO];
  
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entity];
  
  [fetchRequest setSortDescriptors:@[createdDate]];
  
  [fetchRequest setFetchBatchSize:40];
  
  return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
}

@end
