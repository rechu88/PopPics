//
//  PPImage.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 28/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import "PPImage.h"

@implementation PPImage

// Used to create and object with atleast URL
+(PPImage*)initWithUrl:(NSURL*)url
{
    PPImage *image = [[PPImage alloc] init];
    if (image) {
        [image setUrl:url];
    }
    return image;
}

@end
