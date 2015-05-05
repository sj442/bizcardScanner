//
//  DataManager.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (strong, nonatomic) NSManagedObjectContext *mainContext;
@property (strong, nonatomic) NSManagedObjectContext *privateContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSManagedObjectContext *currentLocalContext;
@end

@implementation DataManager

+ (instancetype)sharedManager
{
  static id sharedInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}


#pragma mark - Core Data stack

- (void)initializeCoreDataStack
{
  [self initializeManagedObjectModel];
  [self initializePersistentStoreCoordinator];
  [self initializePrivateContext];
  [self initializeMainContextWithParentContext:self.privateContext];
}


- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext:(BOOL)wait
{
  NSManagedObjectContext *moc = self.mainContext;
  NSManagedObjectContext *private = self.privateContext;
  
  if (!moc) return;
  if ([moc hasChanges]) {
    [moc performBlockAndWait:^{
      NSError *error = nil;
      [moc save:&error];
      if (error) {
        NSLog(@"Error saving Main Context: %@\n%@", [error localizedDescription], [error userInfo]);
      } else {
        NSLog(@"Main Context Saved");
      }
    }];
  }
  
  void (^savePrivate) (void) = ^{
    NSError *error = nil;
    [private save:&error];
    if (error) {
      NSLog(@"Error saving Private Context: %@\n%@", [error localizedDescription], [error userInfo]);
    } else {
      NSLog(@"Private Context Saved");
    }
  };
  
  if ([private hasChanges]) {
    if (wait) {
      [private performBlockAndWait:savePrivate];
    } else {
      [private performBlock:savePrivate];
    }
  }
}

- (void)saveLocalContext:(NSManagedObjectContext *)localMOC
{
  NSError *error = nil;
  [localMOC save:&error];
  if (error) {
    NSLog(@"Error saving Local Context: %@\n%@", [error localizedDescription], [error userInfo]);
  }
  [self saveContext:NO];
}

- (NSManagedObjectContext *)getCurrentLocalContext
{
  if (!self.currentLocalContext) {
    self.currentLocalContext = [self localContext];
  }
  return self.currentLocalContext;
}

- (void)resetCurrentLocalContext
{
  self.currentLocalContext = nil;
}

- (NSManagedObjectContext *)localContext
{
  NSManagedObjectContext *localMOC = nil;
  NSUInteger type = NSConfinementConcurrencyType;
  localMOC = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  localMOC.undoManager = nil;
  [localMOC setParentContext:self.mainContext];
  return localMOC;
}

- (void)uploadDraftsWithCompletionBlock:(void (^)())completion
{
  
}

# pragma mark - Private

- (void)initializeManagedObjectModel
{
  if (self.managedObjectModel != nil) {
    return;
  }
  
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"bizcardScanner" withExtension:@"momd"];
  self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
}

- (void)initializePersistentStoreCoordinator
{
  if (self.persistentStoreCoordinator != nil) {
    return;
  }
  
  self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bizcardScanner.sqlite"];
  NSError *error = nil;
  NSMutableDictionary *options = [NSMutableDictionary dictionary];
  [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
  [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
  NSString *failureReason = @"There was an error creating or loading the application's saved data.";
  if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
  }
}

- (void)initializePrivateContext
{
  NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
  if (!coordinator) {
    self.privateContext = nil;
    return;
  }
  
  NSManagedObjectContext *privateContext = nil;
  NSUInteger type = NSPrivateQueueConcurrencyType;
  privateContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  [privateContext setPersistentStoreCoordinator:coordinator];
  self.privateContext = privateContext;
}

- (void)initializeMainContextWithParentContext:(NSManagedObjectContext *)parentContext
{
  NSManagedObjectContext *mainContext = nil;
  NSUInteger type = NSMainQueueConcurrencyType;
  mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:type];
  [mainContext setParentContext:parentContext];
  self.mainContext = mainContext;
}

@end
