//
//  MainViewController.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "ChooseViewController.h"

@interface MainViewController ()

- (void)initGestureProp;
- (void)setMainProp;

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
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self initGestureProp];
    [self setMainProp];
    //[self performSelector:@selector(newCheck) withObject:nil afterDelay:3];
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    // Do any additional setup after loading the view from its nib.
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
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initGestureProp {
    //mGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTaped:)];
    [mGestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [mGestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [mCheckView addGestureRecognizer:mGestureRecognizerDown];
    [mCheckView addGestureRecognizer:mGestureRecognizerUp];
}

- (void)setMainProp {
    [mMainView setContentSize:CGSizeMake(320, 830)];
    CGPoint bottomOffset = CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
    [mMainView setContentOffset:bottomOffset animated:NO];
    [mMainView setScrollEnabled:NO];
}

- (void)newCheck {
    float viewHeight = 200;
    [UIView beginAnimations : @"Display notif" context:nil];
    [UIView setAnimationDuration:4.0f];
    [UIView setAnimationBeginsFromCurrentState:FALSE];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(rotationAnimationFinished)];
    mAnimationView.frame = CGRectMake(mAnimationView.frame.origin.x, mAnimationView.frame.origin.y - viewHeight, mAnimationView.frame.size.width, mAnimationView.frame.size.height + viewHeight);
    [UIView commitAnimations];
}

- (IBAction)gestureTaped:(id)sender {
    UISwipeGestureRecognizer *gesture = sender;
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        CGPoint bottomOffset = CGPointMake(0, 0);
        [mMainView setContentOffset:bottomOffset animated:YES];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp){
        CGPoint bottomOffset =  CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
        [mMainView setContentOffset:bottomOffset animated:YES];
    }
}

#pragma mark - Scroll View Delegate

- (void) scrollRectToVisible:(CGRect)rect animated:(BOOL)animated {
    NSLog(@"gveorg");
}

@end
