//
//  PPViewController.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 27/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Instagram.h>

#import "PPImageViewController.h"

@interface PPViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, IGSessionDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView * collection;

@property (nonatomic, weak) IBOutlet UILabel * flickrLabel;
@property (nonatomic, weak) IBOutlet UILabel * instagramLabel;
@property (nonatomic, weak) IBOutlet UILabel * fivePxLabel;
@property (nonatomic, weak) IBOutlet PPImageViewController *imageVC;

- (void)startAccessingImages;

@end
