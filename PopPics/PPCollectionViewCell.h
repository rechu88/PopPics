//
//  PPCollectionViewCell.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 28/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "PPImage.h"

@interface PPCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly, retain) UIImageView *imageView;
@property (nonatomic, retain) PPImage *ppImage;

- (void)updateUI;

@end
