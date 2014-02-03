//
//  PPTestImages.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 29/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import <FlickrKit.h>
#import <PXAPI.h>
#import <Instagram.h>

#import "PPAppDelegate.h"
#import "PPImages.h"
#import "PPViewController.h"

@interface PPTestImages : XCTestCase {
    id flickrMock, pxRequestMock, instagramMock;
}

@end

@implementation PPTestImages

- (void)setUp
{
    [super setUp];
    
    flickrMock = [OCMockObject mockForClass:[FlickrKit class]];
    [[[flickrMock stub] andReturn:nil] initializeWithAPIKey:[OCMArg any] sharedSecret:[OCMArg any]];
    
    pxRequestMock = [OCMockObject mockForClass:[PXRequest class]];
    [[[pxRequestMock stub] andReturn:nil] setConsumerKey:[OCMArg any] consumerSecret:[OCMArg any]];
    
    instagramMock = [OCMockObject mockForClass:[Instagram class]];
    PPAppDelegate *delegate = (PPAppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.instagram = [[[instagramMock stub] andReturn:nil] initWithClientId:[OCMArg any] delegate:nil];
    
    [[[instagramMock stub] andReturn:nil] authorize:[OCMArg any]];
    
    id viewMock = [OCMockObject mockForClass:[PPViewController class]];
    [[[viewMock stub] andReturn:nil] startAccessingImages];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testServices
{
    PPImages *images = [[PPImages alloc] init];
    
    [[flickrMock expect] initializeWithAPIKey:[OCMArg any] sharedSecret:[OCMArg any]];
    
    [images registerServices];
    
    // Typecast because Flickr also has verify
    [(OCMockObject*)flickrMock verify];
}

@end
