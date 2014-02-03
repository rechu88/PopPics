//
//  PPImageViewController.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 29/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "PPImage.h"

@interface PPImageViewController : UIViewController {
    Completion shareStart;
}

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) PPImage* ppImage;


- (IBAction)onShare:(id)sender;

- (void)setShare:(Completion)complete;

@end
