//
//  PPImages.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 27/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Instagram.h>

@class Instagram;

// Define the types of services
typedef NS_OPTIONS(NSInteger, PPImageService) {
    PPImageFlickr    = (1 << 0),
    PPImage500px     = (1 << 1),
    PPImageInstagram      = (1 << 2)
};

typedef void (^Completion)();

#define FLICKR_KEY          @"APIFlickrKey"
#define FLICKR_SECRET_KEY   @"APIFlickrSecretKey"
#define FIVE_PX_KEY         @"APIFpxKey"
#define FIVE_PX_SECRET_KEY  @"APIFpxSecretKey"
#define INSTAGRAM_KEY       @"APIInstagramKey"

#define FLICKR_BORDER       [UIColor colorWithRed:0.3f green:0.3f blue:0.6f alpha:0.7f]
#define FIVE_PX_BORDER      [UIColor colorWithRed:0.6f green:0.2f blue:0.2f alpha:0.7f]
#define INSTAGRAM_BORDER    [UIColor colorWithRed:0.3f green:0.6f blue:0.2f alpha:0.7f]


@interface PPImages : NSObject <IGRequestDelegate> {
    Completion afterAccess;
}

// Collection which stores ALL PPImage objects
@property (nonatomic, retain) NSMutableArray * collection;
@property (nonatomic, assign) Instagram *instagram;

-(void)registerServices;

-(void)getImages:(Completion)completion;

@end
