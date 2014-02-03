//
//  PPCollectionViewCell.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 28/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import "PPCollectionViewCell.h"

@implementation PPCollectionViewCell

@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = self.imageView;
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return self;
}

// Works with UIImageView+WebCache.h in caching images
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = NO;
    }
    return _imageView;
}

// Used to update the UI aspect of images with respect to Service
- (void)updateUI
{
    switch (_ppImage.service) {
        case PPImageFlickr:
            [self.contentView.layer setBorderColor:FLICKR_BORDER.CGColor];
            break;
            
        case PPImage500px:
            [self.contentView.layer setBorderColor:FIVE_PX_BORDER.CGColor];
            break;
        
        case PPImageInstagram:
            [self.contentView.layer setBorderColor:INSTAGRAM_BORDER.CGColor];
            break;
    }
    
    self.backgroundColor = [UIColor clearColor];
    [self.contentView.layer setBorderWidth:4.0f];
}

@end
