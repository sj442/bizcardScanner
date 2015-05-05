//
//  CONBizcardImageViewController.m
//  Conquer
//
//  Created by Sunayna Jain on 3/23/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONBizcardImageViewController.h"
#import "CONABBYYManager.h"

#import "BizCard+Manager.h"
#import "DataManager.h"

#import "Reachability.h"

@interface CONBizcardImageViewController ()

@property (weak, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) BizCard *bizcard;

@end

@implementation CONBizcardImageViewController

#pragma mark - Lifecycle

- (instancetype)initWithImage:(UIImage *)image
{
  self = [super init];
  if (self) {
    self.image = image;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  
  [self setupImageView];
  
  [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
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

- (void)setupNavigationBar
{
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelPressed:)];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(confirmPressed:)];
}

- (void)setupImageView
{
  UIImageView *iv = [UIImageView new];
  
  CGRect frame = CGRectZero;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = CGRectGetHeight(self.view.frame);
  
  iv.frame = frame;
  iv.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:iv];
  self.imageView = iv;
  self.imageView.image = self.image;
}


#pragma mark - IBActions

- (void)cancelPressed:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmPressed:(id)sender
{
  [self createBizCard];
  
  [self dismissViewControllerAnimated:YES completion:^{
    [self.delegate didSaveImage:YES];
  }];
}

#pragma mark - Bizcard Create

- (void)createBizCard
{
  BizCard *bizCard = [NSEntityDescription insertNewObjectForEntityForName:[BizCard entityName] inManagedObjectContext:[DataManager sharedManager].mainContext];
  bizCard.createdDate = [NSDate date];
  bizCard.isValidated = @0;
  bizCard.isExported = @0;
   
  NSString *filename = [BizCard generateFilename];
  bizCard.fileName = filename;
  
  dispatch_queue_t globalConcurrentQueue =
  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
  
  dispatch_async(globalConcurrentQueue, ^{
    
    NSData *pngData = UIImagePNGRepresentation(self.image);
    NSString *documentsPath = [BizCard documentsDirectory];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:filename];
    [pngData writeToFile:filePath atomically:YES];
  });
  
  [[DataManager sharedManager] saveContext:NO];
  
  NSManagedObjectID *objectID = bizCard.objectID;
  
  [[CONABBYYManager sharedManager] processBusinessCardFrontImage:self.image backImage:nil completion:^(NSDictionary *cardData) {
    NSManagedObject *object = [[DataManager sharedManager].mainContext objectWithID:objectID];
    BizCard *bizcard = (BizCard *)object;
    bizcard.dateProcessed = [NSDate date];
    bizcard.responseData = cardData;
    [[DataManager sharedManager] saveContext:NO];
  }];
}


@end
