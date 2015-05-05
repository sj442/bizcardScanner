//
//  CONBizcardListTableTableViewController.m
//  Conquer
//
//  Created by Sunayna Jain on 3/20/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONBizcardListTableViewController.h"
#import "CONBizcardScannerViewController.h"
#import "CONBizcardDetailTableViewController.h"
#import "CONBizCardTableViewCell.h"
#import "BizcardOperation.h"

#import "DataManager.h"
#import "BizCard+Manager.h"

#import "CONABBYYManager.h"

#import "UITableView+Conquer.h"
#import "UIColor+Conquer.h"

#import "Reachability.h"

static NSString *CONBizCardTableViewCellIdentifier = @"CONBizCardCell";

@interface CONBizcardListTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSDateFormatter *fullDateFormatter;

@property (strong, nonatomic) Reachability *internetReachable;

@property (assign, nonatomic) BOOL internetActive;

@property (assign, nonatomic) BOOL presentScanner;

@end

@implementation CONBizcardListTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self registerTableViewCells];
  
  [self setupNavigationBar];
  
  [self setupTableView];
  
  [NSFetchedResultsController deleteCacheWithName:[BizCard entityName]];
  self.fetchedResultsController = [BizCard fetchedResultsController];
  self.fetchedResultsController.delegate = self;
  
  [self.fetchedResultsController performFetch:nil];
  
  self.internetReachable = [Reachability reachabilityForInternetConnection];
  [self.internetReachable startNotifier];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (!self.presentScanner) {
    [self scanPressed:nil];
  }

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
  
  if (self.internetActive == YES && self.presentScanner == YES) {
    [self processEmptyBizcards];
  }
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


#pragma mark - Custom Accessors

- (BOOL)internetActive
{
  NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
  if (internetStatus == NotReachable) {
    _internetActive = NO;
  } else if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
    _internetActive = YES;
  }
  return _internetActive;
}

#pragma mark - Setup

- (void)setupTableView
{
  self.tableView.backgroundColor = [UIColor conquerGroupedTableViewBackgroundColor];
  [self.tableView hideEmptyCells];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}


- (void)registerTableViewCells
{
  [self.tableView registerClass:[CONBizCardTableViewCell class] forCellReuseIdentifier:CONBizCardTableViewCellIdentifier];
}


- (void)setupNavigationBar
{
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
  self.navigationController.navigationBar.tintColor = [UIColor conquerDarkTextColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"SCAN" style:UIBarButtonItemStylePlain target:self action:@selector(scanPressed:)];
  self.title = @"Business Cards";
}

#pragma mark - Getters

- (NSDateFormatter *)dateFormatter
{
  if (!_dateFormatter) {
    _dateFormatter = [NSDateFormatter new];
    [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
  }
  return _dateFormatter;
}

- (NSDateFormatter *)fullDateFormatter
{
  if (!_fullDateFormatter) {
    _fullDateFormatter = [NSDateFormatter new];
    [_fullDateFormatter setDateStyle:NSDateFormatterFullStyle];
  }
  return _fullDateFormatter;
}


#pragma mark - IBActions

- (IBAction)scanPressed:(id)sender
{
  CONBizcardScannerViewController *vc = [CONBizcardScannerViewController new];
  UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:vc];
  [self presentViewController:navC animated:YES completion:^{
    self.presentScanner = YES;
  }];
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
  CONBizCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONBizCardTableViewCellIdentifier];
  [self tableView:tableView configureCell:cell indexPath:indexPath];
  return cell;
}


- (void)tableView:(UITableView *)tableView configureCell:(CONBizCardTableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
  BizCard *bizcard = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  if (bizcard.responseData) { //Post processing
    
    [cell hideAccessoryView];
    
      if ([bizcard.emails count] > 0) {
        cell.emailLabel.text = [bizcard.emails firstObject];
      } else {
        NSArray *emails = [bizcard.responseData valueForKey:@"Email"];
        if (emails.count > 0) {
          cell.emailLabel.text = [emails firstObject];
        } else {
          cell.emailLabel.text = @"Email unavailable";
        }
      }
    
    if (bizcard.firstName || bizcard.lastName) {
      cell.nameLabel.text = [self fullNameFromFirstName:bizcard.firstName lastName:bizcard.lastName];
    } else {
      cell.nameLabel.text = [self fullNameFromBizcard:bizcard];
    }
    
    cell.dateLabel.text = [self todayYesterdayOrFormattedStringForDate:bizcard.createdDate withFormatter:self.dateFormatter];
    
  } else { //Pre Processing
    
    if (self.internetActive == YES) {
      
      if (bizcard.firstName || bizcard.lastName) {
        cell.nameLabel.text = [self fullNameFromFirstName:bizcard.firstName lastName:bizcard.lastName];
      } else {
        cell.nameLabel.text = [self.fullDateFormatter stringFromDate:[NSDate date]];
      }
      
      if ([bizcard.emails count] > 0) {
        cell.emailLabel.text = [bizcard.emails firstObject];
        cell.dateLabel.text = [self todayYesterdayOrFormattedStringForDate:bizcard.createdDate withFormatter:self.dateFormatter];
        [cell hideAccessoryView];
      } else {
        cell.emailLabel.text = @"Processing...";
        [cell showActivityIndicator];
      }
      
    } else {
      
      if (bizcard.firstName || bizcard.lastName) {
        cell.nameLabel.text = [self fullNameFromFirstName:bizcard.firstName lastName:bizcard.lastName];
      } else {
        cell.nameLabel.text = [self.fullDateFormatter stringFromDate:[NSDate date]];
      }
      
      if ([bizcard.emails count] > 0) {
        cell.emailLabel.text = [bizcard.emails firstObject];
        cell.dateLabel.text = [self todayYesterdayOrFormattedStringForDate:bizcard.createdDate withFormatter:self.dateFormatter];
        [cell hideAccessoryView];
      } else {
        cell.emailLabel.text = @"No Internet Connection";
        [cell showNoConnectionAvailable];
      }
    }
  }
  
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  BizCard *bizcard = [self.fetchedResultsController objectAtIndexPath:indexPath];
  CONBizcardDetailTableViewController *bizcardDetail = [[CONBizcardDetailTableViewController alloc]initWithBizcard:bizcard];
  [self.navigationController pushViewController:bizcardDetail animated:YES];
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
      CONBizCardTableViewCell *cell = (CONBizCardTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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

#pragma mark - Network call

- (void)processEmptyBizcards
{
  if (self.internetActive == YES) {
    
    NSArray *emptyBizcards = [BizCard emptyBizcards];
    
    for (NSManagedObjectID *objectID in emptyBizcards) {
      
      BizcardOperation *bo = [[BizcardOperation alloc]initWithManagedObjectID:objectID];
      [[NSOperationQueue mainQueue] addOperation:bo];
    }
    
    [[DataManager sharedManager] saveContext:NO];
  }
}


#pragma mark - Network Reachability

- (void)checkNetworkStatus:(NSNotification *)notice
{
  // called after network status changes
  NetworkStatus internetStatus = [self.internetReachable currentReachabilityStatus];
  
  if (internetStatus == NotReachable) {
    NSLog(@"The internet is down.");
    self.internetActive = NO;
    
  } else if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN) {
    self.internetActive = YES;
    [self processEmptyBizcards];
  }
}

#pragma mark - Helpers

- (NSString *)fullNameFromFirstName:(NSString *)firstName lastName:(NSString *)lastName
{
  NSString *name = @"";
  if (firstName) {
    name = [name stringByAppendingString:firstName];
  }
  if (lastName) {
    NSString *withSpace = [NSString stringWithFormat:@" %@", lastName];
    name = [name stringByAppendingString:withSpace];
  }
  if ([name isEqualToString:@""]) {
    name = @"Name unavailable";
  }
  return name;
}


- (NSString *)fullNameFromBizcard:(BizCard *)bizcard
{
  NSString *name = @"";
  NSArray *firstNameArray = [bizcard.responseData objectForKey:@"FirstName"];
  NSArray *lastNameArray = [bizcard.responseData objectForKey:@"LastName"];
  if (firstNameArray.count > 0) {
    name = [name stringByAppendingString:firstNameArray[0]];
  }
  if (lastNameArray.count > 0) {
    NSString *lastName = lastNameArray[0];
    NSString *lastNameAndSpace = [NSString stringWithFormat:@" %@", lastName];
    name = [name stringByAppendingString:lastNameAndSpace];
  }
  if ([name isEqualToString:@""]) {
    name = @"Name unavailable";
  }
  return name;
}


- (NSString *)todayYesterdayOrFormattedStringForDate:(NSDate *)date withFormatter:(NSDateFormatter *)formatter
{
  NSCalendar *cal = [NSCalendar currentCalendar];
  NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
  NSDate *today = [cal dateFromComponents:components];
  NSTimeInterval oneDay = 24*60*60;
  
  NSDate *yesterday = [today dateByAddingTimeInterval:-oneDay];
  components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
  NSDate *roundedDate = [cal dateFromComponents:components];
  
  if([today isEqualToDate:roundedDate]) {
    return @"Today";
  } else if ([yesterday isEqualToDate:roundedDate]) {
    return @"Yesterday";
  }
  
  return [formatter stringFromDate:date];
}


@end
