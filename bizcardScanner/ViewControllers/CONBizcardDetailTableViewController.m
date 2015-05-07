//
//  CONBizcardDetailViewController.m
//  Conquer
//
//  Created by Sunayna Jain on 3/24/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.

#import "CONBizcardDetailTableViewController.h"

#import "BizCard+Manager.h"
#import "UITableView+Conquer.h"
#import "UIColor+Conquer.h"

#import "DataManager.h"

#import "CONTextFieldTableViewCell.h"
#import "CONTextViewTableViewCell.h"

static NSString *CONTextFieldCellIdentifier =  @"CONTextFieldCell";
static NSString *CONPipelineCellIdentifier = @"CONPipelineCell";
static NSString *CONTextViewCellIdentifier = @"CONTextViewCell";

typedef NS_ENUM(NSUInteger, CONSection) {
  CONSectionFirstName,
  CONSectionLastName,
  CONSectionJobTitle,
  CONSectionCompany,
  CONSectionEmail,
  CONSectionPhoneNumbers,
  CONSectionURL,
  CONSectionAddress,
  CONSectionNotes
};

@interface CONBizcardDetailTableViewController () <UITextFieldDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) BizCard *bizcard;

@property (strong, nonatomic) NSManagedObjectID *objectID;

@property (strong, nonatomic) NSMutableDictionary *bizcardInfo;

@property (strong, nonatomic) NSMutableArray *emails;

@property (strong, nonatomic) NSMutableArray *phoneNumbers;

@property (strong, nonatomic) NSMutableArray *URLs;

@property (strong, nonatomic) NSString *firstName;

@property (strong, nonatomic) NSString *lastName;

@property (strong, nonatomic) NSString *jobTitle;

@property (strong, nonatomic) NSString *company;

@property (strong, nonatomic) NSString *streetAddress;

@property (strong, nonatomic) NSString *city;

@property (strong, nonatomic) NSString *region;

@property (strong, nonatomic) NSString *zipcode;

@property (strong, nonatomic) NSString *notes;

@property (strong, nonatomic) UITextView *notesTextView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation CONBizcardDetailTableViewController

#pragma mark - Lifecycle

- (instancetype)initWithBizcard:(NSManagedObjectID *)objectID
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  
  if (self) {
    self.objectID = objectID;
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [NSFetchedResultsController deleteCacheWithName:[BizCard entityName]];
  self.fetchedResultsController = [BizCard fetchedResultsController];
  self.fetchedResultsController.delegate = self;
  self.fetchedResultsController.fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self == %@", self.objectID];
  
  [self.fetchedResultsController performFetch:nil];
  
  [self setupData];
  
  [self setupTableView];
  
  [self registerTableViewCells];
  
  [self setupTableHeaderView];
  
  [self setupNavigationBar];
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


- (void)setupData
{
  if ([self.fetchedResultsController.fetchedObjects count] > 0) {
    
    BizCard *bizcard  = [self.fetchedResultsController.fetchedObjects firstObject];
    
    self.bizcard = bizcard;
    self.notes = bizcard.notes;
    
    self.bizcardInfo = [NSMutableDictionary dictionary];
    [self.bizcardInfo addEntriesFromDictionary:bizcard.responseData];
    
    self.firstName =  [self setFirstNameValue];
    self.lastName =   [self setlastNameValue];
    self.company =  [self setCompanyValue];
    self.jobTitle =  [self setJobTitleValue];
    self.streetAddress =  [self setStreetAddressValue];
    self.city = [self setCityValue];
    self.region = [self setRegionValue];
    self.zipcode = [self setZipcodeValue];
    
    self.emails = nil;
    self.phoneNumbers = nil;
    self.URLs = nil;
    
    if ([bizcard.emails count] > 0) {
      self.emails = [NSMutableArray arrayWithArray:bizcard.emails];
    }
    
    if ([bizcard.phoneNumbers count] > 0) {
      self.phoneNumbers = [NSMutableArray arrayWithArray:bizcard.phoneNumbers];
    }
    
    if ([bizcard.webLinks count] > 0) {
      self.URLs = [NSMutableArray arrayWithArray:bizcard.webLinks];
    }
   
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors

- (NSMutableArray *)emails
{
  if (!_emails) {
    _emails = [NSMutableArray array];
    [_emails addObjectsFromArray:[_bizcardInfo objectForKey:@"Email"]];
  }
  return _emails;
}

- (NSMutableArray *)phoneNumbers
{
  if (!_phoneNumbers) {
    _phoneNumbers = [NSMutableArray array];
    NSArray *phNumberArray = [_bizcardInfo objectForKey:@"Phone"];
    NSArray *mobileArray = [_bizcardInfo objectForKey:@"Mobile"];
    
    if (phNumberArray.count > 0) {
      [_phoneNumbers addObjectsFromArray:phNumberArray];
    }
    
    if (mobileArray.count > 0) {
      [_phoneNumbers addObjectsFromArray:mobileArray];
    }
  }
  return _phoneNumbers;
}

- (NSMutableArray *)URLs
{
  if (!_URLs) {
    _URLs = [NSMutableArray array];
    [_URLs addObjectsFromArray: [_bizcardInfo objectForKey:@"Web"]];
  }
  return _URLs;
}


#pragma mark - Setup

- (NSString *)setFirstNameValue
{
  if (!_bizcard.firstName) {
    NSArray *firstNameArray = [_bizcardInfo objectForKey:@"FirstName"];
    if (firstNameArray.count > 0) {
      _firstName = [firstNameArray firstObject];
    }
  } else {
    _firstName = _bizcard.firstName;
  }
  return _firstName;
}


- (NSString *)setlastNameValue
{
  if (!_bizcard.lastName) {
    NSArray *lastNameArray = [_bizcardInfo objectForKey:@"LastName"];
    if (lastNameArray.count > 0) {
      _lastName = [lastNameArray firstObject];
    }
  } else {
    _lastName = _bizcard.lastName;
  }
  return _lastName;
}


- (NSString *)setCompanyValue
{
  if (!_bizcard.companyName) {
    NSArray *companyArray = [_bizcardInfo objectForKey:@"Company"];
    if (companyArray.count > 0) {
      _company = [companyArray firstObject];
    }
  } else {
    _company = _bizcard.companyName;
  }
  return _company;
}


- (NSString *)setJobTitleValue
{
  if (!_bizcard.jobTitle) {
    NSArray *jobTitleArray = [_bizcardInfo objectForKey:@"Job"];
    if (jobTitleArray.count > 0) {
      _jobTitle = [jobTitleArray firstObject];
    }
  } else {
    _jobTitle = _bizcard.jobTitle;
  }
  return _jobTitle;
}


- (NSString *)setStreetAddressValue
{
  if ([_bizcard.address objectForKey:@"streetAddress"] != nil) {
    _streetAddress = [_bizcard.address objectForKey:@"streetAddress"];
    return _streetAddress;
  }
  NSArray *streetAddressArray = [_bizcardInfo objectForKey:@"StreetAddress"];
  if (streetAddressArray.count > 0) {
    _streetAddress = [streetAddressArray firstObject];
  }
  return _streetAddress;
}


- (NSString *)setCityValue
{
  if ([_bizcard.address objectForKey:@"city"] != nil ) {
    _city = [_bizcard.address objectForKey:@"city"];
    return _city;
  }
  NSArray *cityArray = [_bizcardInfo objectForKey:@"City"];
  if (cityArray.count > 0) {
    _city = [cityArray firstObject];
  }
  return _city;
}


- (NSString *)setRegionValue
{
  if ([_bizcard.address objectForKey:@"region"] != nil) {
    _region = [_bizcard.address objectForKey:@"region"];
    return _region;
  }
  NSArray *regionArray = [_bizcardInfo objectForKey:@"Region"];
  if (regionArray.count > 0) {
    _region = [regionArray firstObject];
  }
  return _region;
}


- (NSString *)setZipcodeValue
{
  if ([_bizcard.address objectForKey:@"zipcode"] != nil) {
    _zipcode = [_bizcard.address objectForKey:@"zipcode"];
    return _zipcode;
  }
  NSArray *zipcodeArray = [_bizcardInfo objectForKey:@"ZipCode"];
  if (zipcodeArray.count > 0) {
    _zipcode = [zipcodeArray firstObject];
  }
  return _zipcode;
}

- (void)setupTableView
{
  self.tableView.backgroundColor = [UIColor conquerGroupedTableViewBackgroundColor];
  [self.tableView hideEmptyCells];
  self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
  self.tableView.editing = NO;
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
  tapGesture.cancelsTouchesInView = NO;
  [self.view addGestureRecognizer:tapGesture];
}


- (void)registerTableViewCells
{
  [self.tableView registerClass:[CONTextFieldTableViewCell class] forCellReuseIdentifier:CONTextFieldCellIdentifier];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CONPipelineCellIdentifier];
  [self.tableView registerClass:[CONTextViewTableViewCell class] forCellReuseIdentifier:CONTextViewCellIdentifier];
}


- (void)setupNavigationBar
{
  self.title = @"Business Card Info";
  self.navigationController.navigationBar.tintColor = [UIColor conquerDarkTextColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(savePressed:)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor conquerGreenColor];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)setupTableHeaderView
{
  UIImageView *iv = [UIImageView new];
  
  CGRect frame = CGRectZero;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = CGRectGetWidth(self.view.frame) * 3/4;
  
  iv.frame = frame;
  iv.contentMode = UIViewContentModeScaleAspectFit;
  
  NSString *fileName = self.bizcard.fileName;
  NSString *documentsPath = [BizCard documentsDirectory];
  NSString *url = [documentsPath stringByAppendingPathComponent:fileName];

  NSData *pngData = [NSData dataWithContentsOfFile:url options:0 error:nil];
  UIImage *image = [UIImage imageWithData:pngData];
  iv.image = image;
  
  self.tableView.tableHeaderView = iv;
}

#pragma mark - IBActions

- (void)addPressed:(UIButton *)button
{
  if (button.tag == CONSectionEmail) {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.emails count] inSection:CONSectionEmail];
    [self.emails addObject:@""];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];
    
  } else if (button.tag == CONSectionPhoneNumbers) {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.phoneNumbers count] inSection:CONSectionPhoneNumbers];
    [self.phoneNumbers addObject:@""];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];

  } else if (button.tag == CONSectionURL) {
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.URLs count] inSection:CONSectionURL];
    [self.URLs addObject:@""];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationBottom];
  }
}


- (void)savePressed:(id)sender
{
  [self cleanUpData];
  
  self.bizcard.firstName = self.firstName;
  self.bizcard.lastName = self.lastName;
  self.bizcard.companyName = self.company;
  self.bizcard.jobTitle = self.jobTitle;
  self.bizcard.emails = self.emails;
  self.bizcard.phoneNumbers = self.phoneNumbers;
  self.bizcard.webLinks = self.URLs;
  self.bizcard.notes = self.notes;
  
  self.bizcard.address = [NSMutableDictionary dictionary];
  
  if (self.streetAddress) {
    [self.bizcard.address setObject:self.streetAddress forKey:@"streetAddress"];
  }
  if (self.city) {
    [self.bizcard.address setObject:self.city forKey:@"city"];
  }
  if (self.region) {
    [self.bizcard.address setObject:self.region forKey:@"region"];
  }
  if (self.zipcode) {
    [self.bizcard.address setObject:self.zipcode forKey:@"zipcode"];
  }

  self.bizcard.isValidated = [NSNumber numberWithBool:YES];
  [[DataManager sharedManager] saveContext:NO];
  [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Data Cleanup

- (void)cleanUpData
{
  NSMutableArray *phNumbersCopy = [self.phoneNumbers copy];
  
  for (NSString *phNumber in phNumbersCopy) {
    
    if ([phNumber isEqualToString:@""]) {
      [self.phoneNumbers removeObject:phNumber];
    }
  }
  
  NSMutableArray *urlCopy = [self.URLs copy];
  
  for (NSString *url in urlCopy) {
    
    if ([url isEqualToString:@""]) {
      [self.URLs removeObject:url];
    }
  }
  
  NSMutableArray *emailCopy = [self.emails copy];
  
  for (NSString *email in emailCopy) {
    
    if ([email isEqualToString:@""]) {
      [self.emails removeObject:email];
    }
  }
  
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 9;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (section == CONSectionAddress) {
    return 4;
    
  } else if (section == CONSectionEmail) {
    return self.emails.count;
    
  } else if (section == CONSectionPhoneNumbers) {
    return self.phoneNumbers.count ;
    
  } else if (section == CONSectionURL) {
    return self.URLs.count;
  }
  return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case CONSectionFirstName:
      return @"First Name";
      break;
      
    case CONSectionLastName:
      return @"Last Name";
      break;
      
    case CONSectionJobTitle:
      return @"Job Title";
      break;
      
    case CONSectionCompany:
      return @"Company";
      break;
      
    case CONSectionEmail:
      return @"Email";
      break;
      
    case CONSectionPhoneNumbers:
      return @"Phone Numbers";
      break;
      
    case CONSectionURL:
      return @"URL";
      break;
    
    case CONSectionAddress:
      return @"Address";
      break;
      
    case CONSectionNotes:
      return @"Note";
      break;
      
    default:
      break;
  }
  return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  if (section == CONSectionPhoneNumbers || section == CONSectionEmail || section == CONSectionURL) {
    return 32;
  }
  return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  if (section == CONSectionPhoneNumbers || section == CONSectionEmail || section == CONSectionURL) {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    button.tag = section;
    [button setTitleColor:[UIColor conquerGreenColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectZero;
    frame.size.width = CGRectGetWidth(self.view.frame);
    frame.size.height = 32;
    button.frame = frame;
    return button;
  }
  return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CONTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CONTextFieldCellIdentifier];
  cell.textField.delegate = self;
  cell.textField.tag = indexPath.section;
  
  switch (indexPath.section) {
      
    case CONSectionFirstName:
      [self tableView:tableView firstNameCell: (CONTextFieldTableViewCell *)cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionLastName:
      [self tableView:tableView lastNameCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionJobTitle:
      [self tableView:tableView jobTitleCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionCompany:
      [self tableView:tableView companyCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionEmail:
      [self tableView:tableView emailCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionPhoneNumbers:
      [self tableView:tableView phoneNumberCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionURL:
      [self tableView:tableView urlCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionAddress:
      [self tableView:tableView addressCell:cell forRowAtIndexPath:indexPath];
      break;
      
    case CONSectionNotes:
      return [self tableView:tableView noteCellForRowAtIndexPath:indexPath];
      break;
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView firstNameCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add first name";
  cell.textField.text = self.firstName;
}


- (void)tableView:(UITableView *)tableView lastNameCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add last name";
  cell.textField.text = self.lastName;
}


- (void)tableView:(UITableView *)tableView jobTitleCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add job title";
  cell.textField.adjustsFontSizeToFitWidth = YES;
  cell.textField.text = self.jobTitle;
}


- (void)tableView:(UITableView *)tableView companyCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add company";
  cell.textField.text = self.company;
}


- (void)tableView:(UITableView *)tableView emailCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add email";
  
  if (self.emails.count > indexPath.row) {
    cell.textField.text = self.emails[indexPath.row];
  }
  cell.textField.autocapitalizationType = NO;
  cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
  cell.textField.autocorrectionType = NO;
  cell.textField.tag = CONSectionEmail + 100 * indexPath.row;
}


- (void)tableView:(UITableView *)tableView phoneNumberCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add phone number";
  
  if (self.phoneNumbers.count > indexPath.row) {
    cell.textField.text = self.phoneNumbers[indexPath.row];
  }
  cell.textField.tag = CONSectionPhoneNumbers + 100 * indexPath.row;
}


- (void)tableView:(UITableView *)tableView urlCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.placeholder = @"Add url";
  
  if (self.URLs.count > indexPath.row) {
    cell.textField.text = self.URLs[indexPath.row];
  }
  cell.textField.autocapitalizationType = NO;
  cell.textField.keyboardType = UIKeyboardTypeURL;
  cell.textField.tag = CONSectionURL + 100 * indexPath.row;
}


- (void)tableView:(UITableView *)tableView addressCell:(CONTextFieldTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.textField.tag = CONSectionAddress + 100 * indexPath.row;
  
  if (indexPath.row == 0) {
    cell.textField.placeholder = @"Add street";
    cell.textField.adjustsFontSizeToFitWidth = YES;
    cell.textField.text = self.streetAddress;
    
  } else if (indexPath.row == 1) {
    cell.textField.placeholder = @"Add city";
    cell.textField.text = self.city;
    
  } else if (indexPath.row == 2) {
    cell.textField.placeholder = @"Add state";
    cell.textField.text = self.region;
    
  } else if (indexPath.row == 3) {
    cell.textField.placeholder = @"Add zipcode";
    cell.textField.text = self.zipcode;
  }
}

- (CONTextViewTableViewCell *)tableView:(UITableView *)tableView noteCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CONTextViewTableViewCell *textViewCell = [tableView dequeueReusableCellWithIdentifier:CONTextViewCellIdentifier];
  textViewCell.textView.keyboardType = UIKeyboardTypeDefault;
  textViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
  textViewCell.textView.placeholder = @"Add a note";
  textViewCell.textView.delegate = self;
  textViewCell.textView.text = self.notes;
  self.notesTextView = textViewCell.textView;
  
  if (self.notes && ![self.notes isEqualToString:@""]) {
    textViewCell.textView.placeholderTextView.hidden = YES;
  } else {
    textViewCell.textView.placeholderTextView.hidden = NO;
  }
  return textViewCell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  cell.layoutMargins = UIEdgeInsetsZero;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == CONSectionNotes) {
    
    CGFloat width  = CGRectGetWidth(tableView.frame);
    NSString *text = self.notesTextView.text;

    return [CONTextViewTableViewCell heightForCellWithWidth:width text:text];
  }
  return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *sectionLabel = [UILabel new];
  sectionLabel.font = [UIFont systemFontOfSize:13];
  sectionLabel.textColor = [UIColor conquerTableViewSectionTitleColor];
  sectionLabel.text = [[self tableView:tableView titleForHeaderInSection:section] uppercaseString];
  
  CGRect frame = CGRectZero;
  frame.origin.x = 8;
  frame.size.width = CGRectGetWidth(self.tableView.frame) - 16;
  frame.size.height = 32;
  sectionLabel.frame = frame;
  
  UIView *sectionView = [UIView new];
  [sectionView addSubview:sectionLabel];
  
  return sectionView;
}


#pragma mark - UITableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == CONSectionEmail || indexPath.section == CONSectionPhoneNumbers || indexPath.section == CONSectionURL) {
    return YES;
  }
  return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    
    if (indexPath.section == CONSectionURL) {
      [self.URLs removeObjectAtIndex:indexPath.row];
      
    } else if (indexPath.section == CONSectionEmail) {
      [self.emails removeObjectAtIndex:indexPath.row];
      
    } else if (indexPath.section == CONSectionPhoneNumbers) {
      [self.phoneNumbers removeObjectAtIndex:indexPath.row];
    }
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return NO;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSInteger section = textField.tag % 100;
  NSInteger row = textField.tag / 100;
  
  if (section == CONSectionJobTitle) {
    
    [self jobTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionCompany) {
    
    [self companyTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionFirstName) {
    
    [self firstNameTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionLastName) {
    
    [self lastNameTextFieldDidEndEditingText:textField.text atRow:row];

  } else if (section == CONSectionURL) {
    
    [self urlTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionEmail) {
    
    [self emailTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionPhoneNumbers) {
    
    [self phoneNumberTextFieldDidEndEditingText:textField.text atRow:row];
    
  } else if (section == CONSectionAddress) {
    
    [self addressTextFieldDidEndEditingText:textField.text atRow:row];
  }
}


- (void)jobTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.jobTitle = text;
}


- (void)companyTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.company = text;
}


- (void)firstNameTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.firstName = text;
}


- (void)lastNameTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.lastName = text;
}


- (void)urlTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.URLs[row] = text;
}


- (void)emailTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.emails[row] = text;
}


- (void)phoneNumberTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  self.phoneNumbers[row] = text;
}


- (void)addressTextFieldDidEndEditingText:(NSString *)text atRow:(NSInteger)row
{
  if (row == 0) {
    self.streetAddress = text;
    
  } else if (row == 1) {
    self.city = text;
    
  } else if (row == 2) {
    self.region = text;
    
  } else {
    self.zipcode = text;
  }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  NSInteger section = textField.tag % 100;
  NSInteger row = textField.tag / 100;
  
  if (section == CONSectionJobTitle) {
    
    [self jobTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionCompany) {
    
    [self companyTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionFirstName) {
    
    [self firstNameTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionLastName) {
    
    [self lastNameTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionURL) {
    
    [self urlTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionEmail) {
    
    [self emailTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionPhoneNumbers) {
    
    [self phoneNumberTextFieldDidEndEditingText:newText atRow:row];
    
  } else if (section == CONSectionAddress) {
    
    [self addressTextFieldDidEndEditingText:newText atRow:row];
  }
  return YES;
}


#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
  [self adjustTextViewHeight:textView];
}

- (void)adjustTextViewHeight:(UITextView *)textView
{
  [UIView setAnimationsEnabled:NO];
  [self.tableView beginUpdates];
  [self.tableView endUpdates];
  [UIView setAnimationsEnabled:YES];
  
  CGSize size = textView.contentSize;
  
  CGRect textViewFrame = textView.frame;
  textViewFrame.size.height = size.height;
  
  textView.frame = textViewFrame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
  self.notes = newText;
  return YES;
}

#pragma mark - UITapGestureRecognizer

- (void)viewWasTapped:(UITapGestureRecognizer *)gestureRecognizer
{
  [self.notesTextView resignFirstResponder];
}

#pragma mark - NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      break;
      
    case NSFetchedResultsChangeDelete:
      break;
      
    case NSFetchedResultsChangeUpdate: {
      
      BizCard *bizcard = [[self.fetchedResultsController fetchedObjects] firstObject];
      NSDictionary *responseData = bizcard.responseData;
      
      if ([self.emails count] == 0) { //no user added emails
        
        NSArray *emails = [responseData objectForKey:@"Email"];
        NSMutableArray *emailArray = [NSMutableArray array];
        
        for (int i = 0; i < [emails count]; i++) {
          NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:CONSectionEmail];
          [emailArray addObject:ip];
        }
        [tableView insertRowsAtIndexPaths:emailArray withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      
      if ([self.phoneNumbers count] == 0) { // no user added phone numbers
        
        NSMutableArray *phoneNumbers = [NSMutableArray array];
        NSArray *phone = [responseData objectForKey:@"Phone"];
        NSArray *mobile = [responseData objectForKey:@"Mobile"];
        
        [phoneNumbers addObjectsFromArray:phone];
        [phoneNumbers addObjectsFromArray:mobile];
        
        NSMutableArray *phnumberArray = [NSMutableArray array];
        
        for (int i = 0; i < [phoneNumbers count]; i++) {
          NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:CONSectionPhoneNumbers];
          [phnumberArray addObject:ip];
        }
        [tableView insertRowsAtIndexPaths:phnumberArray withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      
      if ([self.URLs count ] == 0) {
        
        NSArray *urls = [responseData objectForKey:@"Web"];
        NSMutableArray *urlArray = [NSMutableArray array];
        
        for (int i = 0; i < [urls count]; i++) {
          NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:CONSectionURL];
          [urlArray addObject:ip];
        }
        [tableView insertRowsAtIndexPaths:urlArray withRowAnimation:UITableViewRowAnimationAutomatic];
      }
      
      [self setupData];
      [tableView reloadData];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView endUpdates];
}

@end
