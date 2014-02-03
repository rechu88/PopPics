//
//  PPImages.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 27/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPViewController.h"

#import "PPImages.h"
#import "PPImage.h"

#import <PXAPI.h>
#import <FlickrKit/FlickrKit.h>
#import <Instagram.h>

@implementation PPImages

// To set the Services with client and secret keys
// These keys are defined in the plist
- (void)registerServices
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    [self registerService:PPImageFlickr key:[bundle objectForInfoDictionaryKey:FLICKR_KEY] secret:[bundle objectForInfoDictionaryKey:FLICKR_SECRET_KEY]];
    
    [self registerService:PPImage500px key:[bundle objectForInfoDictionaryKey:FIVE_PX_KEY] secret:[bundle objectForInfoDictionaryKey:FIVE_PX_SECRET_KEY]];
    
    PPAppDelegate *delegate = (PPAppDelegate*)[UIApplication sharedApplication].delegate;
    
    delegate.instagram = [[Instagram alloc] initWithClientId:[bundle objectForInfoDictionaryKey:INSTAGRAM_KEY] delegate:nil];
    
    self.instagram = delegate.instagram;
}

- (void)registerService:(PPImageService)service key:(NSString*)key secret:(NSString*)secret
{
    switch (service) {
        case PPImageFlickr:
            [[FlickrKit sharedFlickrKit] initializeWithAPIKey:key sharedSecret:secret];
            break;
        
        case PPImage500px:
            [PXRequest setConsumerKey:key consumerSecret:secret];
            break;
            
        default:
            break;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _collection = [[NSMutableArray alloc] init];
    }
    return self;
}

// To access Flickr photos
- (void)accessFlickrPhotos
{
    FlickrKit *fkr = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    [fkr call:interesting completion:^(NSDictionary *response, NSError *error) {
        if (response) {
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                NSURL *url = [fkr photoURLForSize:FKPhotoSizeSmall240 fromPhotoDictionary:photoData];
                
                PPImage *image = [PPImage initWithUrl:url];
                
                // The service used for the image is PPImageFlickr
                [image setService:PPImageFlickr];
                
                [[weakSelf collection] addObject:image];
            }
            
            // Flickr does not run on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                afterAccess();
            });
        }   
    }];
}

// To access 500px photos
- (void)access500PxPhotos
{
    __weak typeof(self) weakSelf = self;
    [PXRequest requestForPhotoFeature:PXAPIHelperPhotoFeaturePopular completion:^(NSDictionary *results, NSError *error){
        if (results) {
            NSArray * photos = [results valueForKey:@"photos"];
            for (NSDictionary *data in photos) {
                NSObject *urls = [data objectForKey:@"image_url"];
                NSURL *url;
                
                // We see that the image_url could be one url or an array
                // If an array, we take the first one in the array
                if ([urls isKindOfClass:[NSArray class]]) {
                    url = [NSURL URLWithString:[(NSArray*)urls objectAtIndex:0]];
                } else {
                    url = [NSURL URLWithString:(NSString*)urls];
                }
                
                PPImage *image = [PPImage initWithUrl:url];
                
                // The service used for the image is PPImage500px
                [image setService:PPImage500px];
                
                [[weakSelf collection] addObject:image];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                afterAccess();
            });
        }
    }];
}

// To access Instagram photos
- (void)accessInstagramPhotos
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"media/popular", @"method", nil];
    // The delegate for the Instagram access is Self
    [self.instagram requestWithParams:params delegate:self];
}

//Start getting all images
-(void)getImages:(void(^)())completion
{
    // Store the complation handler as the Instagram SDK works with delegates
    afterAccess = completion;
    
    [self accessFlickrPhotos];
    
    [self access500PxPhotos];
    
    [self accessInstagramPhotos];
    
}

#pragma mark - IGRequestDelegate

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

// Delegate callback after Instagram Photos access
- (void)request:(IGRequest *)request didLoad:(id)result {
    NSArray * data = (NSArray*)[result objectForKey:@"data"];
    
    __weak typeof(self) weakSelf = self;
    
    for (NSDictionary *dict in data) {
        NSString *urlStr = [dict valueForKeyPath:@"images.thumbnail.url"];
        NSURL *url = [NSURL URLWithString:urlStr];
        
        PPImage *image = [PPImage initWithUrl:url];
        
        // The service used for the image is PPImageInstagram
        [image setService:PPImageInstagram];
        
        [[weakSelf collection] addObject:image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            afterAccess();
        });
    }
}

@end
