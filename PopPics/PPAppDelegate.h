//
//  PPAppDelegate.h
//  PopPics
//
//  Created by Reshma Unnikrishnan on 27/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Instagram.h>
#import <FacebookSDK.h>

@interface PPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Instagram *instagram;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
