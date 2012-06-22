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
#import "MenuItem.h"
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "GroupItem.h"

@interface MainViewController ()

- (void)initGestureProp;
- (void)setMainProp;
- (void)newPriceViewAnimate;
- (void)finishAnimation;

- (void)setTotalPriceFrame;
- (void)setMainCheckViewFrame;

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
    [mMaskView release];
    mMaskView = nil;
    [mPriceView release];
    mPriceView = nil;
    [mPaperBottomImageView release];
    mPaperBottomImageView = nil;
    [mPaperTopImageView release];
    mPaperTopImageView = nil;
    [mPriceLbl release];
    mPriceLbl = nil;
    [currentGroupBtn release];
    currentGroupBtn = nil;
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
    [mMaskView release];
    [mPriceView release];
    [mPaperBottomImageView release];
    [mPaperTopImageView release];
    [mPriceLbl release];
    [currentGroupBtn release];
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
    mPriceView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    menuTableViewController.delegate = self;
    priceTableViewController.delegate = self;
    
    //set scroll prop
    [mMainView setContentSize:CGSizeMake(320, 830)];
    CGPoint bottomOffset = CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
    [mMainView setContentOffset:bottomOffset animated:NO];
    [mMainView setScrollEnabled:NO];
    
    //set price prop
    [priceTableViewController goToTop:NO];
    [priceTableViewController tableView].scrollEnabled = NO;
    
    //set price frame
    CGRect priceRect = [priceTableViewController tableView].frame;
    priceRect.origin.x = 0;
    priceRect.origin.y = 0;
    [[priceTableViewController tableView] setFrame:priceRect];
    CGRect totalRect = mPriceView.frame;
    totalRect.origin.x = 0;
    totalRect.origin.y = priceRect.origin.y + priceRect.size.height;
    [mPriceView setFrame:totalRect];
    
    CGRect rect = BEGIN_RECT;
    rect.size.height = [priceTableViewController tableView].frame.size.height + mPriceView.frame.size.height;
    rect.origin.y = rect.origin.y - rect.size.height;
    [mCheckView setFrame:rect];
}

- (void)newCheck {
    [priceTableViewController clearCheck];
    mPrice = 0;
    mPriceLbl.text = [NSString stringWithFormat:@"%d руб.", mPrice];
    [UIView transitionWithView:mCheckView
                      duration:1
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        mCheckView.hidden = YES;
                        mMaskView.clipsToBounds = NO;
                    }
                    completion:^(BOOL finished) {
                        [self setTotalPriceFrame];
                        CGRect rect = BEGIN_RECT;
                        rect.size.height = [priceTableViewController tableView].frame.size.height + mPriceView.frame.size.height;
                        mCheckView.frame = rect;
                        mCheckView.hidden = NO;
                        mMaskView.clipsToBounds = YES;
                        [self newPriceViewAnimate];
                    }];
}

- (void)newPriceViewAnimate {
    mPaperTopImageView.hidden = YES;
    [UIView beginAnimations : @"Display notif" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationBeginsFromCurrentState:FALSE];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    CGRect priceRect = [priceTableViewController tableView].frame;
    priceRect.origin.x = 0;
    priceRect.origin.y = 0;
    [[priceTableViewController tableView] setFrame:priceRect];
    [self setTotalPriceFrame];
    [self setMainCheckViewFrame];
    [UIView commitAnimations];
}

- (void)finishAnimation {
    mPaperTopImageView.hidden = NO;
}

#pragma mark - Actions

- (IBAction)gestureTaped:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UISwipeGestureRecognizer *gesture = sender;
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown) {
        CGPoint topOffset = CGPointMake(0, 0);
        [mMainView setContentOffset:topOffset animated:YES];
        [priceTableViewController goToTop:YES];
        [appDelegate.viewController disableGestureRecognizer:YES];
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        CGPoint bottomOffset =  CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
        [mMainView setContentOffset:bottomOffset animated:YES];
        [priceTableViewController goToTop:NO];
        [appDelegate.viewController disableGestureRecognizer:NO];
    } else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self newCheck];
    }
}

- (IBAction)changeMenuClicked:(id)sender {
    static int index = 0;
    index = (index + 1) % menuTableViewController.arrayOfMenuItemGroups.count;
    [menuTableViewController nextMenuByIndex:index];
    GroupItem *groupItem = [menuTableViewController.arrayOfMenuItemGroups objectAtIndex:index];
    [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
}

- (IBAction)menuClicked:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.viewController showLeftController:YES];
}

- (IBAction)newChecked:(id)sender {
    [self newCheck];
}

#pragma mark - MenuTableViewController Delegate

- (void)getNewPrice:(MenuItem *)menu {
    
    GroupItem *groupItem = [menuTableViewController.arrayOfMenuItemGroups objectAtIndex:0];
    [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
    
    mPrice += menu.menuPrice.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d руб.", mPrice];
    [priceTableViewController addNewProduct:menu];
    
    [self setTotalPriceFrame];
    CGRect rect = BEGIN_RECT;
    rect.size.height = [priceTableViewController tableView].frame.size.height + mPriceView.frame.size.height;
    mCheckView.frame = rect;
    [self setMainCheckViewFrame];
}

#pragma mark - PriceTableViewController Delegate

- (void)deleteProductWithPrice:(MenuItem *)menuItem {
    mPrice -= menuItem.menuPrice.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d руб.", mPrice];
    [self setTotalPriceFrame];
    CGRect rect = BEGIN_RECT;
    rect.size.height = [priceTableViewController tableView].frame.size.height + mPriceView.frame.size.height;
    mCheckView.frame = rect;
    [self setMainCheckViewFrame];
}

#pragma mark - Set Frames Functions

- (void)setTotalPriceFrame {
    CGRect priceRect = [priceTableViewController tableView].frame;
    CGRect totalRect = mPriceView.frame;
    totalRect.origin.x = 0;
    totalRect.origin.y = priceRect.origin.y + priceRect.size.height;
    [mPriceView setFrame:totalRect];
}

- (void)setMainCheckViewFrame {
    CGRect checkRect = mCheckView.frame;
    checkRect.origin.y -= checkRect.size.height;
    [mCheckView setFrame:checkRect];
}

@end
