//
//  CONContactListTableViewController.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/29/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONContactListTableViewController.h"

#import "CONAccountListTableViewController.h"

#import "DataManager.h"

#import "Contact+Manager.h"
#import "UITableView+Conquer.h"
#import "UIColor+Conquer.h"

#import <AddressBook/AddressBook.h>

@interface CONContactListTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CONContactListTableViewController

static NSString *CellIdentifier = @"cell";

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self registerTableViewCells];
  
  [self setupNavigationBar];
  
  [self setupTableView];
  
  [NSFetchedResultsController deleteCacheWithName:[Contact entityName]];
  self.fetchedResultsController = [Contact fetchedResultsController];
  self.fetchedResultsController.delegate = self;
  
  [self.fetchedResultsController performFetch:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];

}


- (void)viewDidLayoutSubviews
{
  self.tableView.separatorInset = UIEdgeInsetsZero;
  self.tableView.layoutMargins = UIEdgeInsetsZero;
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Setup

- (void)setupTableView
{
  self.tableView.backgroundColor = [UIColor conquerGroupedTableViewBackgroundColor];
  [self.tableView hideEmptyCells];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  [self.tableView setEditing:YES];
}


- (void)registerTableViewCells
{
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}


- (void)setupNavigationBar
{
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Accounts" style:UIBarButtonItemStylePlain target:self action:@selector(accountsPressed:)];
  UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
  UIBarButtonItem *save = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed:)];
  self.navigationItem.rightBarButtonItems = @[done, save];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
  self.navigationController.navigationBar.tintColor = [UIColor conquerDarkTextColor];
  self.title = @"Contacts";
}

#pragma mark - IBActions

- (void)accountsPressed:(id)sender
{
  CONAccountListTableViewController *tableVC = [CONAccountListTableViewController new];
  UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:tableVC];
  [self presentViewController:navC animated:YES completion:nil];
}


- (void)donePressed:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)savePressed:(id)sender
{
  NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
  Contact *c = [self.fetchedResultsController objectAtIndexPath:ip];
  
  if (![self duplicateCheckForContact:c]) {
    
    [self saveToAddressBook:c];
    
  } else {
    
    [self showDuplicateContactAlert];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger numberOfRows = 0;
  
  NSArray *sections = self.fetchedResultsController.sections;
  if (sections.count > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    numberOfRows = [sectionInfo numberOfObjects];
  }
  return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  [self tableView:tableView configureCell:cell indexPath:indexPath];
  return cell;
}


- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
  Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = contact.firstName;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.layoutMargins = UIEdgeInsetsZero;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 56;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    Contact *c = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[DataManager sharedManager].mainContext deleteObject:c];
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate: {
      UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
      [self tableView:tableView configureCell:cell indexPath:indexPath];
    }
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray
                                         arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray
                                         arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    default:
      break;
  }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

#pragma mark - Save to Address Book


- (BOOL)duplicateCheckForContact:(Contact *)contact
{
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);

  NSArray *array = (__bridge NSArray *)(ABAddressBookCopyPeopleWithName(addressBook, (__bridge CFStringRef)(contact.lastName)));
  
  for (int i = 0; i < array.count; i++) {
    ABRecordRef person = (__bridge ABRecordRef)([array objectAtIndex:i]);
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    if ([firstName isEqualToString:contact.firstName]) {
      return YES;
    }
  }
  return NO;
}


- (void)saveToAddressBook:(Contact *)contact
{
  ABRecordRef aRecord = ABPersonCreate();
  
  CFErrorRef anError = NULL;
  
  if (contact.firstName) {
    ABRecordSetValue(aRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)(contact.firstName), &anError);
  }
  
  if (contact.lastName) {
    ABRecordSetValue(aRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)(contact.lastName), &anError);
  }
  
  if (contact.email) {
    
    ABMutableMultiValueRef multiEmail =  ABMultiValueCreateMutable(kABMultiStringPropertyType);
    NSString *email = contact.email;
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(email), kABWorkLabel, NULL);
    ABRecordSetValue(aRecord, kABPersonEmailProperty, multiEmail, &anError);
    
    CFRelease(multiEmail);
  }
  
  ABMutableMultiValueRef multiPhone =  ABMultiValueCreateMutable(kABMultiStringPropertyType);
  
  NSArray *numbers = [[contact.phoneNumbers allObjects] valueForKey:@"number"];
  for (NSString *number in numbers) {
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(number), kABPersonPhoneMainLabel, NULL);
  }
  ABRecordSetValue(aRecord, kABPersonPhoneProperty, multiPhone, nil);
  
  ABMutableMultiValueRef multiURLs =  ABMultiValueCreateMutable(kABMultiStringPropertyType);
  
  NSArray *urls = [[contact.webLinks allObjects] valueForKey:@"url"];
  for (NSString *url in urls) {
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(url), kABPersonHomePageLabel, NULL);
  }
  ABRecordSetValue(aRecord, kABPersonURLProperty, multiURLs, nil);
  
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
  
  if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
      // First time access has been granted, add the contact
      
      ABAddressBookAddRecord(addressBook, aRecord, nil);
      ABAddressBookSave(addressBook, nil);
    });
  } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
    
    ABAddressBookAddRecord(addressBook, aRecord, nil);
    ABAddressBookSave(addressBook, nil);
  }
  
  CFRelease(addressBook);
  CFRelease(aRecord);
  CFRelease(multiURLs);
  CFRelease(multiPhone);

  if (anError != NULL)
  {
    CFStringRef errorDesc = CFErrorCopyDescription(anError);
    NSLog(@"Contact not saved: %@", errorDesc);
    CFRelease(errorDesc);
  } else {
    [self showContactSavedAlert];
  }
  
}


- (void)showContactSavedAlert
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Contact Saved" message:nil preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
  
  [alert addAction:okAction];
  
  [self presentViewController:alert animated:YES completion:nil];
}


- (void)showDuplicateContactAlert
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Contact already exists" message:nil preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
  
  [alert addAction:okAction];
  
  [self presentViewController:alert animated:YES completion:nil];
}

@end
