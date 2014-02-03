//
//  PPViewController.m
//  PopPics
//
//  Created by Reshma Unnikrishnan on 27/01/14.
//  Copyright (c) 2014 Reshma Unnikrishnan. All rights reserved.
//

#import "PPAppDelegate.h"
#import "PPViewController.h"
#import "PPImageViewController.h"
#import "PPCollectionViewCell.h"
#import "PPImage.h"
#import "PPImages.h"

#import <UIAlertView+Blocks.h>
#import <FacebookSDK.h>

@interface PPViewController () {
    PPImages * images;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation PPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _imageVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _imageVC.modalPresentationStyle = UIModalPresentationPageSheet;
    
    images = [[PPImages alloc] init];
    
    [images registerServices];
    
    [self.view addSubview:self.activityIndicator];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    
    // Set the Cell View to take the class PPCollectionViewCell
    [self.collection registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self colorizeLabels];
}

// Colorize labels for Services
- (void)colorizeLabels
{
    self.flickrLabel.textColor    = FLICKR_BORDER;
    self.instagramLabel.textColor = INSTAGRAM_BORDER;
    self.fivePxLabel.textColor    = FIVE_PX_BORDER;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setUpInstagram];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [images.collection count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PPCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];

    // Access the correct PPImage
    PPImage *accessedImage = [images.collection objectAtIndex:indexPath.row];
    
    [cell setPpImage:accessedImage];
    
    [cell.imageView cancelCurrentImageLoad];
    [cell.imageView setImageWithURL:accessedImage.url placeholderImage:nil
                            options:SDWebImageCacheMemoryOnly completed:NULL];
    
    // Call updateUI to set the correct borders and other UI enhancements
    [cell updateUI];

    return cell;
}

// Start Image share to Facebook
- (void)startImageShare:(PPImage*)currentImage
{
    __weak typeof(PPImage*) weakSelf = currentImage;
    
    [self showActivityIndicators:YES];
    
    [self openFacebookSession:^(){
        // Always test for an open FB session
        if (FBSession.activeSession.isOpen) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Look at this link", @"name",
                                           @"PopPic lets you share images", @"caption",
                                           @"Share Share Share", @"description",
                                           [weakSelf.url absoluteString], @"link",
                                           [weakSelf.url absoluteString], @"picture",
                                           nil];
            
            // Make the request
            [FBRequestConnection startWithGraphPath:@"/me/feed"
                                         parameters:params
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      [self showActivityIndicators:NO];
                                      if (!error) {
                                          // Link posted successfully to Facebook
                                          UIAlertView* alertView = [[UIAlertView alloc]
                                                                    initWithTitle:@"Woohoo !"
                                                                    message:@"Images posted to FB"
                                                                    delegate:nil
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles:nil];
                                          [alertView show];
                                      } else {
                                          NSLog(@"%@", error);
                                          UIAlertView* alertView = [[UIAlertView alloc]
                                                                    initWithTitle:@"Error"
                                                                    message:[error.userInfo valueForKey:@"body.error.message"]
                                                                    delegate:nil
                                                                    cancelButtonTitle:@"Ok"
                                                                    otherButtonTitles:nil];
                                          [alertView show];
                                      }
                                  }];
        }
    }];
}


// Open a Facebook Session if not available
// If available, call the completion handler
- (void)openFacebookSession:(Completion)myCompletion
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        myCompletion();
        
    } else {
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"share_item", @"status_update"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             PPAppDelegate *delegate = (PPAppDelegate*)[UIApplication sharedApplication].delegate;
             [delegate sessionStateChanged:session state:state error:error];
             myCompletion();
         }];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PPImage *accessedImage = [images.collection objectAtIndex:indexPath.row];
    
    __weak typeof(PPImage*) weakImage = accessedImage;
    __weak typeof(PPViewController*) weakSelf = self;


    UIStoryboard *storyboard = self.storyboard;
    _imageVC = [storyboard instantiateViewControllerWithIdentifier:@"PPImageViewController"];
    
    _imageVC.ppImage = accessedImage;
    
    [_imageVC setShare:^{
        // Show an alert view to confirm sharing
        [UIAlertView showWithTitle:@"Share"
                           message:@"Sure you want to share the image on Facebook?"
                 cancelButtonTitle:@"Cancel"
                 otherButtonTitles:@[@"Share"]
                          tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                              if (buttonIndex == [alertView cancelButtonIndex]) {
                                  NSLog(@"Cancelled");
                              } else {
                                  [weakSelf startImageShare:weakImage];
                              }
                          }];
    }];
    
    [self.navigationController pushViewController:_imageVC animated:YES];
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval = CGSizeMake(80, 80);
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 10, 20);
}

#pragma mark - Activity Indicator

- (UIActivityIndicatorView *)activityIndicator
{
    if (!activityIndicator)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] init];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        activityIndicator.center = self.view.center;
    }
    return activityIndicator;
}

- (void)showActivityIndicators:(BOOL)visible
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    
    if (visible) {
        [self.activityIndicator startAnimating];
    }
    else {
        [self.activityIndicator stopAnimating];
    }
    
    self.collection.userInteractionEnabled = !visible;
}

#pragma mark - IGSessionDelegates

- (void)startAccessingImages {
    // Access Everything AFTER Login
    __weak typeof(self) weakSelf = self;
    
    [self showActivityIndicators:YES];
    
    [images getImages:^(){
        [weakSelf.collection reloadData];
        [weakSelf showActivityIndicators:NO];
    }];
}

-(void)igDidLogin {
    PPAppDelegate* appDelegate = (PPAppDelegate*)[UIApplication sharedApplication].delegate;
    
    // Store the access token for future use
    [[NSUserDefaults standardUserDefaults] setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self startAccessingImages];
}

-(void)igDidNotLogin:(BOOL)cancelled {

    NSString* message = nil;
    if (cancelled) {
        message = @"Access cancelled!";
    } else {
        message = @"Access denied!";
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)igDidLogout {
    // Remove the access token
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"accessToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)igSessionInvalidated {
    NSLog(@"Instagram session was invalidated");
}

// Setup Instagram before accessing services
- (void)setUpInstagram
{
    PPAppDelegate* appDelegate = (PPAppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
    appDelegate.instagram.sessionDelegate = self;
    
    if ([appDelegate.instagram isSessionValid]) {
        [self igDidLogin];
    } else {
        [appDelegate.instagram authorize:[NSArray arrayWithObjects:@"comments", @"likes", nil]];
    }
}

@end
