//
//  PPImageViewController.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 29/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import "PPImageViewController.h"

@interface PPImageViewController ()

@end

@implementation PPImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    switch (self.ppImage.service) {
        case PPImageFlickr:
            [self.imageView.layer setBorderColor:FLICKR_BORDER.CGColor];
            break;
            
        case PPImage500px:
            [self.imageView.layer setBorderColor:FIVE_PX_BORDER.CGColor];
            break;
            
        case PPImageInstagram:
            [self.imageView.layer setBorderColor:INSTAGRAM_BORDER.CGColor];
            break;
    }
    
    [self.imageView cancelCurrentImageLoad];
    [self.imageView setImageWithURL:self.ppImage.url placeholderImage:[UIImage imageNamed:@"loading.png"]
                                options:SDWebImageCacheMemoryOnly completed:NULL];
}

// Works with UIImageView+WebCache.h in caching images
- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = NO;
    }
    return _imageView;
}

// Set the share completion
- (void)setShare:(Completion)complete
{
    shareStart = complete;
}

// Ibaction for the share button
- (IBAction)onShare:(id)sender
{
    if (shareStart) {
        shareStart();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
