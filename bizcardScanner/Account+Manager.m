//
//  Account+Manager.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "Account+Manager.h"
#import "DataManager.h"

@implementation Account (Manager)

+ (NSString *)entityName
{
  return @"Account";
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


+ (instancetype)newObject
{
  NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[DataManager sharedManager].mainContext];
  Account *account = (Account *)object;
  account.createdDate = [NSDate date];
  return account;
}

@end
