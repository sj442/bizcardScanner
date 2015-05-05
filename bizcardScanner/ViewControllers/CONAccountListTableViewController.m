//
//  CONAccountListTableViewController.m
//  bizcardScanner
//
//  Created by Sunayna Jain on 4/29/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONAccountListTableViewController.h"
#import "Account+Manager.h"
#import "UITableView+Conquer.h"
#import "UIColor+Conquer.h"

#import "DataManager.h"

@interface CONAccountListTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CONAccountListTableViewController

static NSString *CellIdentifier = @"cell";

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [self registerTableViewCells];
  
  [self setupNavigationBar];
  
  [self setupTableView];
  
  [NSFetchedResultsController deleteCacheWithName:[Account entityName]];
  self.fetchedResultsController = [Account fetchedResultsController];
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
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(donePressed:)];
  self.navigationController.navigationBar.tintColor = [UIColor conquerDarkTextColor];
  self.title = @"Accounts";
}

#pragma mark - IBActions

- (void)donePressed:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
  Account *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = account.name;
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
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    Account *a = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [[DataManager sharedManager].mainContext deleteObject:a];
  }
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


@end
