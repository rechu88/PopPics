//
//  PPImage.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 28/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PPImages.h"

@interface PPImage : NSObject

@property (nonatomic, retain) NSURL * url;
@property (nonatomic) PPImageService service;

+(PPImage*)initWithUrl:(NSURL*)url;

@end
