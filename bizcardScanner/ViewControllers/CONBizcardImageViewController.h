//
//  CONBizcardImageViewController.h
//  Conquer
//
//  Created by Sunayna Jain on 3/23/15.
//  Copyright (c) 2015 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>

/*

- setup
 
- create Bizcard
 
*/

@protocol BizcardImageDelegate <NSObject>

- (void)didSaveImage:(BOOL)imageSaved;

@end

@interface CONBizcardImageViewController : UIViewController

@property (weak, nonatomic) id <BizcardImageDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image;

@end
