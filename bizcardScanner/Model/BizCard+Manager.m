//
//  BizCard+Manager.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/28/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "BizCard+Manager.h"
#import "DataManager.h"
#import "Contact+Manager.h"
#import "Account+Manager.h"

@implementation BizCard (Manager)

+ (NSString *)entityName
{
  return @"BizCard";
}

- (NSString *)title
{
  return @"Business Card";
}

#pragma mark - Public - Class - CoreData

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


+ (NSString *)generateFilename
{
  NSDate *date = [NSDate date];
  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:@"dd-MM-YY-HH-mm-ss"];
  NSString *dateString = [df stringFromDate:date];
  NSString *pathString = [NSString stringWithFormat:@"bizCard-%@.png", dateString];
  return pathString;
}


+ (NSString *)documentsDirectory
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
  NSString *documentsPath = [paths objectAtIndex:0];
  return documentsPath;
}


+ (NSInteger)notValidatedBizCardsCount
{
  NSFetchRequest *request = [NSFetchRequest new];
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSEntityDescription *entity = [NSEntityDescription entityForName:[BizCard entityName] inManagedObjectContext:context];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isValidated == %@) || (isValidated = nil)", @0];
  request.entity = entity;
  request.predicate = predicate;
  
  NSError *error;
  return [context countForFetchRequest:request error:&error];
}


+ (NSInteger)notExportedBizCardsCount
{
  NSFetchRequest *request = [NSFetchRequest new];
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSEntityDescription *entity = [NSEntityDescription entityForName:[BizCard entityName] inManagedObjectContext:context];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(isExported == %@) || (isExported = nil)", @0];
  request.entity = entity;
  request.predicate = predicate;
  
  NSError *error;
  return [context countForFetchRequest:request error:&error];
}


+ (NSArray *)validatedBizCardsToExport
{
  NSFetchRequest *request = [NSFetchRequest new];
  
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:[BizCard entityName] inManagedObjectContext:context];
  
  NSPredicate *exportPredicate = [NSPredicate predicateWithFormat:@"(isExported == %@) || (isExported = nil)", @0];
  NSPredicate *validatePredicate = [NSPredicate predicateWithFormat:@"isValidated == %@", @1];
  NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[exportPredicate, validatePredicate]];
  
  request.entity = entity;
  request.predicate = compoundPredicate;
  
  NSError *error;
  return [context executeFetchRequest:request error:&error];
}


+ (NSArray *)emptyBizcards
{
  NSFetchRequest *request = [NSFetchRequest new];
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSEntityDescription *entity = [NSEntityDescription entityForName:[BizCard entityName] inManagedObjectContext:context];
  
  NSPredicate *noDataPredicate = [NSPredicate predicateWithFormat:@"dateProcessed = nil"];
  
  request.resultType = NSManagedObjectIDResultType;
  request.entity = entity;
  request.fetchLimit = 10;
  request.predicate = noDataPredicate;
  
  NSError *error;
  return [context executeFetchRequest:request error:&error];
}


+ (void)createContactsAndAccountsFromBizCardsWithCompletionBlock:(void(^)(void))completion failureBlock:(void(^) (NSString *))failure
{
  NSArray *bizCards = [BizCard validatedBizCardsToExport];
  
  NSMutableArray *subsetArray = [NSMutableArray array];
  
  if (bizCards.count > 50) {
    [subsetArray addObjectsFromArray:[bizCards subarrayWithRange:NSMakeRange(0, 50)]];
  } else {
    [subsetArray addObjectsFromArray:bizCards];
  }
  
  NSMutableArray *newAccounts = [NSMutableArray array];
  NSMutableArray *newContacts = [NSMutableArray array];
  
  //export bizcards to contacts
  for (BizCard *bizcard in subsetArray) {

    Contact *contact = [self contactFromBizcard:bizcard];
    if (contact) {
      [newContacts addObject:contact];
    }
    
    Account *account = [self accountFromBizcard:bizcard];
    
    if (account) {
      
      if (contact) {
        [account addContactsObject:contact];
      }
      [newAccounts addObject:account];
    }
  }
  
  [[DataManager sharedManager] saveContext:NO];
  
  completion();
}


+ (Contact *)contactFromBizcard:(BizCard *)bizcard
{
  NSArray *webLinks = [bizcard.responseData objectForKey:@"Web"];
  
  NSMutableArray *webLinksArray = [NSMutableArray array];
  for (int i = 0; i < webLinks.count; i++) {
    NSDictionary *temp = @{@"url": webLinks[i]};
    [webLinksArray addObject:temp];
  }
  
  NSArray *firstName = [bizcard.responseData objectForKey:@"FirstName"];
  NSArray *lastName = [bizcard.responseData objectForKey:@"LastName"];
  NSArray *email = [bizcard.responseData objectForKey:@"Email"];
  NSArray *phNumbers = [bizcard.responseData objectForKey:@"Phone"];
  
  NSString *firstNameString = @"";
  NSString *lastNameString = @"";
  NSString *emailString = @"";
  
  NSMutableArray *phNumbersArray = [NSMutableArray array];
  
  if (firstName.count > 0) {
    firstNameString = [firstName firstObject];
  }
  if (lastName.count > 0) {
    lastNameString = [lastName firstObject];
  }
  if (email.count > 0) {
    emailString = [email firstObject];
  }
  for (int i = 0; i < phNumbers.count; i++) {
    NSDictionary *temp = @{@"number": phNumbers[i], @"type": @"phone"};
    [phNumbersArray addObject:temp];
  }
  
  NSArray *contacts;
  
  if (![emailString isEqualToString:@""]) {
    contacts = [self contactsWithEmailAddress:emailString];
  } else {
    contacts = [self contactsWithFirstName:firstNameString lastName:lastNameString];
  }
  
  if ([contacts count] > 0) {
    
    Contact *contact = [contacts firstObject];
    
    NSArray *phNumbers = [[contact.phoneNumbers allObjects] valueForKey:@"number"];
    NSArray *weblinks = [[contact.webLinks allObjects] valueForKey:@"url"];
    
    NSMutableArray *contactPhNumbers = [NSMutableArray arrayWithArray:contact.phoneNumbers];
    NSMutableArray *contactWebLinks = [NSMutableArray arrayWithArray:contact.webLinks];
    
    for (NSDictionary *temp in phNumbersArray) {
      
      NSString *phNumber = [temp objectForKey:@"number"];
      if (![phNumbers containsObject:phNumber]) {
        [contactPhNumbers addObject:temp];
        contact.modifiedDate = [NSDate date];
      }
    }
    
    for (NSDictionary *temp in webLinksArray) {
      
      NSString *url = [temp objectForKey:@"url"];
      if (![weblinks containsObject:url]) {
        [contactWebLinks addObject:temp];
        contact.modifiedDate = [NSDate date];
      }
    }
    
    contact.phoneNumbers = contactPhNumbers;
    contact.webLinks = contactWebLinks;
    
    [[DataManager sharedManager] saveContext:NO];
    return nil;
  }
  
  Contact *contact = [Contact newObject];
  contact.firstName = firstNameString;
  contact.lastName = lastNameString;
  contact.email = emailString;
  contact.phoneNumbers = phNumbersArray;
  contact.webLinks = webLinksArray;
  
  return contact;
}


+ (NSArray *)contactsWithEmailAddress:(NSString *)email
{
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:[Contact entityName]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
  fetchRequest.predicate = predicate;
  NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
  fetchRequest.sortDescriptors = @[sd];
  NSArray *contacts = [context executeFetchRequest:fetchRequest error:nil];
  
  return  contacts;
}

+ (NSArray *)contactsWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:[Contact entityName]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(firstName = %@) && (lastName = %@)", firstName, lastName];
  fetchRequest.predicate = predicate;
  NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:YES];
  fetchRequest.sortDescriptors = @[sd];
  NSArray *contacts = [context executeFetchRequest:fetchRequest error:nil];
  
  return contacts;
}


+ (NSArray *)accountsWithCompanyName:(NSString *)name
{
  NSManagedObjectContext *context = [DataManager sharedManager].mainContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:[Account entityName]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
  fetchRequest.predicate = predicate;
  NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:YES];
  fetchRequest.sortDescriptors = @[sd];
  NSArray *accounts = [context executeFetchRequest:fetchRequest error:nil];
  
  return  accounts;
}


+ (Account *)accountFromBizcard:(BizCard *)bizcard
{
  NSArray *company = [bizcard.responseData objectForKey:@"Company"];
  
  NSArray *streetAddress = [bizcard.responseData objectForKey:@"StreetAddress"];
  NSArray *city = [bizcard.responseData objectForKey:@"City"];
  NSArray *state = [bizcard.responseData objectForKey:@"Region"];
  NSArray *zip = [bizcard.responseData objectForKey:@"ZipCode"];
  
  NSArray *phNumbers = [bizcard.responseData objectForKey:@"Phone"];
  NSArray *webLinks = [bizcard.responseData objectForKey:@"Web"];
  
  NSMutableArray *webLinksArray = [NSMutableArray array];
  
  for (int i = 0; i < webLinks.count; i++) {
    NSDictionary *temp = @{@"url": webLinks[i]};
    [webLinksArray addObject:temp];
  }
  
  NSMutableArray *phNumbersArray = [NSMutableArray array];
  
  for (int i = 0; i < phNumbers.count; i++) {
    NSDictionary *temp = @{@"number": phNumbers[i], @"type": @"phone"};
    [phNumbersArray addObject:temp];
  }
  
  NSString *cityString = @"";
  NSString *stateString = @"";
  NSString *zipcodeString = @"";
  NSString *streetAddressString = @"";
  
  if (city.count > 0) {
    cityString = [city firstObject];
  }
  if (state.count > 0) {
    stateString = [state firstObject];
  }
  if (zip.count > 0) {
    zipcodeString = [zip firstObject];
  }
  if (streetAddress.count > 0) {
    streetAddressString = [streetAddress firstObject];
  }
  NSDictionary *address = @{
                            @"city": cityString,
                            @"state": stateString,
                            @"zip": zipcodeString,
                            @"street": streetAddressString,
                            @"streetTwo": @""
                            };
  
  NSArray *accounts = [self accountsWithCompanyName:company[0]];

  if (accounts.count > 0) {
    
    Account *account = [accounts firstObject];
    
    NSArray *phNumbers = [[account.phoneNumbers allObjects] valueForKey:@"number"];
    NSArray *weblinks = [[account.webLinks allObjects] valueForKey:@"url"];
    
    NSMutableArray *accountPhNumbers = [NSMutableArray arrayWithArray:account.phoneNumbers];
    NSMutableArray *accountWebLinks = [NSMutableArray arrayWithArray:account.webLinks];
    
    for (NSDictionary *temp in phNumbersArray) {
      
      NSString *phNumber = [temp objectForKey:@"number"];
      if (![phNumbers containsObject:phNumber]) {
        [accountPhNumbers addObject:temp];
        account.modifiedDate = [NSDate date];
      }
    }
    
    for (NSDictionary *temp in webLinksArray) {
      
      NSString *url = [temp objectForKey:@"url"];
      if (![weblinks containsObject:url]) {
        [accountWebLinks addObject:temp];
        account.modifiedDate = [NSDate date];
      }
    }
    
    account.phoneNumbers = accountPhNumbers;
    account.webLinks = accountWebLinks;
    
    [[DataManager sharedManager] saveContext:NO];
    return nil;
  }
  
  if (company.count > 0 && streetAddress.count > 0) {
    
    Account *account = [Account newObject];
    account.name = company[0];
    account.address = address;
    account.webLinks = webLinksArray;
    account.phoneNumbers = phNumbersArray;
    return account;
  }
  return nil;
}


@end

