//
//  DataManager.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;
@property (strong, nonatomic, readonly) NSManagedObjectContext *privateContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (instancetype)sharedManager;

- (void)initializeCoreDataStack;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext:(BOOL)wait;
- (void)saveLocalContext:(NSManagedObjectContext *)localMOC;
- (NSManagedObjectContext *)localContext;
- (NSManagedObjectContext *)getCurrentLocalContext;
- (void)resetCurrentLocalContext;
@end
