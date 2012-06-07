//
//  MainViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ChooseViewController.h"
#import "PriceTableViewController.h"
#import "MenuViewController.h"

@interface MainViewController ()

- (void)initGestureProp;
- (void)setMainProp;
- (void)newPriceViewAnimate;

@end

@implementation MainViewController
@synthesize priceTableViewController;
@synthesize menuTableViewController;

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
    [self performSelector:@selector(newCheck) withObject:nil afterDelay:3.0f];
    [self setMainProp];
    [self initGestureProp];
}

- (void)viewDidUnload
{
    [self setPriceTableViewController:nil];
    [self setMenuTableViewController:nil];
    [mAnimationView release];
    mAnimationView = nil;
    [mGestureRecognizerDown release];
    mGestureRecognizerDown = nil;
    [mTotalLbl release];
    mTotalLbl = nil;
    [mCheckView release];
    mCheckView = nil;
    [mMainView release];
    mMainView = nil;
    [mGestureRecognizerUp release];
    mGestureRecognizerUp = nil;
    [mGestureRecognizerLeft release];
    mGestureRecognizerLeft = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [priceTableViewController release];
    [menuTableViewController release];
    [mAnimationView release];
    [mGestureRecognizerDown release];
    [mTotalLbl release];
    [mCheckView release];
    [mMainView release];
    [mGestureRecognizerUp release];
    [mGestureRecognizerLeft release];
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initGestureProp {
    [mGestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [mGestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [mGestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [mCheckView addGestureRecognizer:mGestureRecognizerDown];
    [mCheckView addGestureRecognizer:mGestureRecognizerUp];
    [mCheckView addGestureRecognizer:mGestureRecognizerLeft];
}

- (void)setMainProp {
    //set main prop
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgorund.png"]];
    mCheckView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    
    //set scroll prop
    [mMainView setContentSize:CGSizeMake(320, 830)];
    CGPoint bottomOffset = CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
    [mMainView setContentOffset:bottomOffset animated:NO];
    [mMainView setScrollEnabled:NO];
    
    //set price prop
    [priceTableViewController goToTop:NO];
    [priceTableViewController tableView].scrollEnabled = NO;
}

- (void)newCheck {
    [UIView transitionWithView:mCheckView
                    
                      duration:1
     
                       options:UIViewAnimationOptionTransitionCurlUp
     
                    animations:^{
                        mCheckView.hidden = YES;
                    }
     
                    completion:^(BOOL finished) {
                        mCheckView.frame = BEGIN_RECT;
                        mCheckView.hidden = NO;
                        [self newPriceViewAnimate];
                    }];
}

- (void)newPriceViewAnimate {
    [UIView beginAnimations : @"Display notif" context:nil];
    [UIView setAnimationDuration:4.0f];
    [UIView setAnimationBeginsFromCurrentState:FALSE];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(rotationAnimationFinished)];
    mCheckView.frame = END_RECT;
    [UIView commitAnimations];
}

- (IBAction)gestureTaped:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UISwipeGestureRecognizer *gesture = sender;
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        CGPoint topOffset = CGPointMake(0, 0);
        [mMainView setContentOffset:topOffset animated:YES];
        [priceTableViewController goToTop:YES];
        [priceTableViewController tableView].scrollEnabled = YES;
        [appDelegate.viewController disableGestureRecognizer:YES];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        CGPoint bottomOffset =  CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
        [mMainView setContentOffset:bottomOffset animated:YES];
        [priceTableViewController goToTop:NO];
        [priceTableViewController tableView].scrollEnabled = NO;
        [appDelegate.viewController disableGestureRecognizer:NO];
    } else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self newCheck];
    }
}

@end
