//
//  CONBizcardScannerViewController.m
//  Conquer
//
//  Created by Sunayna Jain on 3/20/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import "CONBizcardScannerViewController.h"
#import "CONBizcardImageViewController.h"
#import "UIFont+Conquer.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "AVFoundation/AVFoundation.h"

static CGFloat businessCardRatio = 2/3.3;

@interface CONBizcardScannerViewController () <BizcardImageDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (weak, nonatomic) UIView *containerView;

@property (weak, nonatomic) UIView *buttonView;

@property (weak, nonatomic) UIView *mainOverlayView;

@end

@implementation CONBizcardScannerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setupContainerView];
  
  [self addImagePickerController];
  
  [self setupNavigationBar];
  
  [self requestCameraAccess];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - Camera permissions

- (void)requestCameraAccess
{
  AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
  
  if (authStatus == AVAuthorizationStatusAuthorized) {
    
  } else if (authStatus == AVAuthorizationStatusDenied) {
    
    [self showEnableCameraAccessAlert];
    
  } else if (authStatus == AVAuthorizationStatusRestricted) {
    
  } else if (authStatus == AVAuthorizationStatusNotDetermined) {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
      
      if (granted) {
        
      } else {
        
        [self showEnableCameraAccessAlert];
      }
    }];
  }
}


- (void)showEnableCameraAccessAlert
{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Unable to access camera" message:@"Please go to settings and enable camera access" preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
  }];
  
  [alert addAction:okAction];
  
  [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Layout

- (void)setupContainerView
{
  UIView *containerView = [UIView new];
  [self.view addSubview:containerView];
  self.containerView = containerView;
  CGRect frame = CGRectZero;
  frame.origin.x = 0;
  frame.origin.y = 20;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = CGRectGetHeight(self.view.frame) - CGRectGetMinY(frame);
  containerView.frame =frame;
}


- (void)setupNavigationBar
{
  self.navigationController.navigationBarHidden = YES;
}


- (void)addImagePickerController
{
  UIImagePickerController *imagePicker = [UIImagePickerController new];
  imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  imagePicker.showsCameraControls = NO;
  imagePicker.navigationItem.rightBarButtonItem = nil;
  imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
  imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
  imagePicker.delegate = self;
  self.imagePicker = imagePicker;
  
  [self addChildViewController:imagePicker];
  [self.containerView addSubview:imagePicker.view];
  [imagePicker didMoveToParentViewController:self];
  imagePicker.view.bounds = self.containerView.bounds;
  
  UIView *overlayView = [self setupCustomOverlayView];
  [self.imagePicker setCameraOverlayView:overlayView];
}


- (UIView *)setupCustomOverlayView
{
  UIView *mainOverlayView = [UIView new];
  
  CGRect frame = CGRectZero;
  frame.origin.y = 0;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = CGRectGetHeight(self.view.frame);
  mainOverlayView.frame = frame;
  
  self.mainOverlayView = mainOverlayView;
  
  [self setupCameraFrame];
  
  UIView *buttonView = [UIView new];
  buttonView.backgroundColor = [UIColor blackColor];
  [mainOverlayView addSubview:buttonView];
  
  self.buttonView = buttonView;
  CGFloat buttonViewHeight = CGRectGetHeight(self.view.frame) - CGRectGetWidth(self.view.frame) * 4/3;
  frame = CGRectZero;
  frame.origin.x = 0;
  frame.origin.y = CGRectGetHeight(self.view.frame) - buttonViewHeight;
  frame.size.width = CGRectGetWidth(self.view.frame);
  frame.size.height = buttonViewHeight;
  buttonView.frame = frame;
  
  [self setupCameraButton];
  
  [self setupGalleryButton];
  
  [self setupCancelButton];
  
  return mainOverlayView;
}


- (void)setupCameraFrame
{
  CGFloat cameraHeight = CGRectGetWidth(self.view.frame) * 4/3;
  CGFloat lineViewHeight = cameraHeight - 60;
  CGFloat lineViewWidth = lineViewHeight * businessCardRatio;
  CGFloat xOrigin = (CGRectGetWidth(self.view.frame) - lineViewWidth - 10)/2;
  
  UIView *leftVerticalLine = [UIView new];
  leftVerticalLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:leftVerticalLine];
  CGRect frame = CGRectZero;
  frame.origin.x = xOrigin;
  frame.origin.y = 30;
  frame.size.width = 5;
  frame.size.height = lineViewHeight;
  leftVerticalLine.frame = frame;
  
  UIView *rightVerticalLine = [UIView new];
  rightVerticalLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:rightVerticalLine];
  frame = CGRectZero;
  frame.origin.x = xOrigin + lineViewWidth + 5;
  frame.origin.y = 30;
  frame.size.width = 5;
  frame.size.height = lineViewHeight;
  rightVerticalLine.frame =frame;
  
  UILabel *topLabel = [UILabel new];
  [self.mainOverlayView addSubview:topLabel];
  frame = CGRectZero;
  frame.origin.x = CGRectGetMaxX(rightVerticalLine.frame);
  frame.origin.y = CGRectGetMinY(rightVerticalLine.frame) + CGRectGetHeight(rightVerticalLine.frame)/2 - 20;
  frame.size.width = 40;
  frame.size.height = 20;
  topLabel.frame = frame;
  topLabel.text = @"TOP";
  topLabel.textColor = [UIColor whiteColor];
  topLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
  topLabel.font = [UIFont boldFontOfSize:16];
  topLabel.textAlignment = NSTextAlignmentCenter;
  
  UIView *leftUpperLine = [UIView new];
  leftUpperLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:leftUpperLine];
  frame = CGRectZero;
  frame.origin.x = xOrigin;
  frame.origin.y = 25;
  frame.size.width = 20;
  frame.size.height = 5;
  leftUpperLine.frame = frame;
  
  UIView *leftLowerLine = [UIView new];
  leftLowerLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:leftLowerLine];
  frame = CGRectZero;
  frame.origin.x = xOrigin;
  frame.origin.y = 25 + lineViewHeight;
  frame.size.width = 25;
  frame.size.height = 5;
  leftLowerLine.frame = frame;
  
  UIView *rightUpperLine = [UIView new];
  rightUpperLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:rightUpperLine];
  frame = CGRectZero;
  frame.origin.x = xOrigin + lineViewWidth -10;
  frame.origin.y = 25;
  frame.size.width = 20;
  frame.size.height = 5;
  rightUpperLine.frame = frame;
  
  UIView *rightLowerLine = [UIView new];
  rightLowerLine.backgroundColor = [UIColor whiteColor];
  [self.mainOverlayView addSubview:rightLowerLine];
  frame = CGRectZero;
  frame.origin.x = xOrigin+lineViewWidth - 10;
  frame.origin.y = 25 + lineViewHeight;
  frame.size.width = 20;
  frame.size.height = 5;
  rightLowerLine.frame = frame;
}

- (void)setupCameraButton
{
  UIButton *cameraButton = [UIButton new];
  [cameraButton setImage:[UIImage imageNamed:@"whiteShutter"] forState:UIControlStateNormal];
  [cameraButton setImage:[UIImage imageNamed:@"grayShutter"] forState:UIControlStateHighlighted];
  [cameraButton addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [self.buttonView addSubview:cameraButton];
  CGRect frame = CGRectZero;
  frame.origin.x = CGRectGetWidth(self.view.frame)/2 - 35;
  frame.origin.y = CGRectGetHeight(self.buttonView.frame) - 110;
  frame.size.width = 70;
  frame.size.height = 70;
  cameraButton.frame = frame;
}


- (void)setupCancelButton
{
  UIButton *cancelButton = [UIButton new];
  
  [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
  [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  CGRect frame = CGRectZero;
  frame.origin.x = 10;
  frame.origin.y = CGRectGetHeight(self.buttonView.frame) - 100;
  frame.size.width = 80;
  frame.size.height = 50;
  
  cancelButton.frame = frame;
  
  [self.buttonView addSubview:cancelButton];
  [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setupGalleryButton
{
  UIButton *galleryButton = [UIButton new];
  
  CGRect frame = CGRectZero;
  
  frame.origin.x = CGRectGetWidth(self.view.frame) - 60;
  frame.origin.y = CGRectGetHeight(self.buttonView.frame) - 100;
  frame.size.width = 50;
  frame.size.height = 50;
  galleryButton.frame = frame;
  
  galleryButton.backgroundColor = [UIColor whiteColor];
  
  [self.buttonView addSubview:galleryButton];
  
  [galleryButton addTarget:self
                    action:@selector(galleryButtonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
  
  ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
  
  [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                               usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                 
                                 if (group != nil) {
                                   
                                   [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                   
                                   [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                     
                                     if (asset) {
                                       CGImageRef imageRef = [asset thumbnail];
                                       UIImage *image = [UIImage imageWithCGImage:imageRef];
                                       [galleryButton setImage:image forState:UIControlStateNormal];
                                       *stop = YES;
                                     }
                                   }];
                                 }
                                 
                               } failureBlock:^(NSError *error) {
                                 NSLog(@"error: %@", error);
                                 [galleryButton setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
                               }];
}

#pragma mark - IBActions

- (void)cameraButtonPressed:(id)sender
{
  [self.imagePicker takePicture];
}

- (void)galleryButtonPressed:(id)sender
{
  UIImagePickerController *picker = [UIImagePickerController new];
  
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.delegate = self;
  [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)cancelButtonPressed:(id)sender
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
  
  CONBizcardImageViewController *imageVC = [[CONBizcardImageViewController alloc]initWithImage:image];
  imageVC.delegate = self;
  UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:imageVC];
  [self.navigationController presentViewController:navC animated:YES completion:nil];
}

#pragma mark - BizcardDelegate

- (void)didSaveImage:(BOOL)imageSaved
{
  if (imageSaved) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }
}


@end
