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

@interface CONBizcardDetailTableViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) BizCard *bizcard;

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

@end

@implementation CONBizcardDetailTableViewController

#pragma mark - Lifecycle

- (instancetype)initWithBizcard:(BizCard *)bizcard
{
  self = [super initWithStyle:UITableViewStyleGrouped];
  
  if (self) {
    
    self.bizcard = bizcard;
    
    self.firstName = bizcard.firstName;
    self.lastName = bizcard.lastName;
    self.jobTitle = bizcard.jobTitle;
    self.company = bizcard.companyName;
    self.notes = bizcard.notes;
    
    if ([bizcard.emails count] > 0) {
      self.emails = [NSMutableArray arrayWithArray:bizcard.emails];
    }
    
    if ([bizcard.phoneNumbers count] > 0) {
      self.phoneNumbers = [NSMutableArray arrayWithArray:bizcard.phoneNumbers];
    }

    if ([bizcard.webLinks count] > 0) {
      self.URLs = [NSMutableArray arrayWithArray:bizcard.webLinks];
    }

    self.bizcardInfo = [NSMutableDictionary dictionary];
    [self.bizcardInfo addEntriesFromDictionary:bizcard.responseData];
  }
  return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
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


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Custom Accessors

- (NSString *)firstName
{
  if (!_firstName) {
    NSArray *firstNameArray = [_bizcardInfo objectForKey:@"FirstName"];
    if (firstNameArray.count > 0) {
      _firstName = [firstNameArray firstObject];
    }
  }
  return _firstName;
}


- (NSString *)lastName
{
  if (!_lastName) {
    NSArray *lastNameArray = [_bizcardInfo objectForKey:@"LastName"];
    if (lastNameArray.count > 0) {
      _lastName = [lastNameArray firstObject];
    }
  }
  return _lastName;
}


- (NSString *)company
{
  if (!_company) {
    NSArray *companyArray = [_bizcardInfo objectForKey:@"Company"];
    if (companyArray.count > 0) {
      _company = [companyArray firstObject];
    }
  }
  return _company;
}


- (NSString *)jobTitle
{
  if (!_jobTitle) {
    NSArray *jobTitleArray = [_bizcardInfo objectForKey:@"Job"];
    if (jobTitleArray.count > 0) {
      _jobTitle = [jobTitleArray firstObject];
    }
  }
  return _jobTitle;
}


- (NSString *)streetAddress
{
  if (!_streetAddress) {
    if ([_bizcard.address objectForKey:@"streetAddress"] != nil) {
      _streetAddress = [_bizcard.address objectForKey:@"streetAddress"];
      return _streetAddress;
    }
    NSArray *streetAddressArray = [_bizcardInfo objectForKey:@"StreetAddress"];
    if (streetAddressArray.count > 0) {
      _streetAddress = [streetAddressArray firstObject];
    }
  }
  return _streetAddress;
}


- (NSString *)city
{
  if (!_city) {
    if ([_bizcard.address objectForKey:@"city"] != nil) {
      _city = [_bizcard.address objectForKey:@"city"];
      return _city;
    }
    NSArray *cityArray = [_bizcardInfo objectForKey:@"City"];
    if (cityArray.count > 0) {
      _city = [cityArray firstObject];
    }
  }
  return _city;
}


- (NSString *)region
{
  if (!_region) {
    if ([_bizcard.address objectForKey:@"region"] != nil) {
      _region = [_bizcard.address objectForKey:@"region"];
      return _region;
    }
    NSArray *regionArray = [_bizcardInfo objectForKey:@"Region"];
    if (regionArray.count > 0) {
      _region = [regionArray firstObject];
    }
  }
  return _region;
}


- (NSString *)zipcode
{
  if (!_zipcode) {
    if ([_bizcard.address objectForKey:@"zipcode"] != nil) {
      _zipcode = [_bizcard.address objectForKey:@"zipcode"];
      return _zipcode;
    }
    NSArray *zipcodeArray = [_bizcardInfo objectForKey:@"ZipCode"];
    if (zipcodeArray.count > 0) {
      _zipcode = [zipcodeArray firstObject];
    }
  }
  return _zipcode;
}


- (NSMutableArray *)emails
{
  if (!_emails) {
    _emails = [NSMutableArray array];
    [_emails addObjectsFromArray:[_bizcardInfo objectForKey:@"Email"]];
  }
  return _emails;
}


- (NSMutableArray *)URLs
{
  if (!_URLs) {
    _URLs = [NSMutableArray array];
    [_URLs addObjectsFromArray: [_bizcardInfo objectForKey:@"Web"]];
  }
  return _URLs;
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

#pragma mark - Setup

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

@end