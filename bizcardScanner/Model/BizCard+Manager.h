//
//  BizCard+Manager.h
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "BizCard.h"

@interface BizCard (Manager)

+ (NSString *)entityName;

+ (NSFetchedResultsController *)fetchedResultsController;

+ (NSString *)generateFilename;

+ (NSString *)documentsDirectory;

+ (NSInteger)notValidatedBizCardsCount;

+ (NSInteger)notExportedBizCardsCount;

+ (NSArray *)emptyBizcards;

+ (void)createContactsAndAccountsFromBizCardsWithCompletionBlock:(void(^)(void))completion failureBlock:(void(^) (NSString *))failure;


@end
