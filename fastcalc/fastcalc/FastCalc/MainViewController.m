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
#import "MenuItem.h"
#import "AppDelegate.h"
#import "GroupItem.h"
#import "IIViewDeckController.h"
#import "EClockPlayer.h"

@interface MainViewController ()

- (void)initGestureProp;
- (void)initPlayers;
- (void)setMainProp;
- (void)finishAnimation;

- (void)setMainCheckViewFrameWithAnimation:(BOOL)animate duration:(float)duration;

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
    [self performSelectorInBackground:@selector(initPlayers) withObject:nil];
    [self performSelectorInBackground:@selector(initGestureProp) withObject:nil];
    
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
    [mPageControl release];
    mPageControl = nil;
    [mPriceMask release];
    mPriceMask = nil;
    [mThanksView release];
    mThanksView = nil;
    [mThanksLabel release];
    mThanksLabel = nil;
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
    [mPageControl release];
    [mPriceMask release];
    [mThanksView release];
    [mThanksLabel release];
    [super dealloc];
}

#pragma mark - Custom functions

- (void)initGestureProp {
    [mGestureRecognizerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [mGestureRecognizerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [mGestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [mThanksView addGestureRecognizer:mGestureRecognizerDown];
    [mThanksView addGestureRecognizer:mGestureRecognizerUp];
    [mThanksView addGestureRecognizer:mGestureRecognizerLeft];
    [mPriceMask addGestureRecognizer:mGestureRecognizerDown];
    [mPriceMask addGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask addGestureRecognizer:mGestureRecognizerLeft];
}

- (void)initPlayers {
    mKassaPlayer = [[EClockPlayer alloc] initWithFileName:@"Kassa.wav"];
    [mKassaPlayer adjustVolume:0.4f];
    mBumagaPlayer = [[EClockPlayer alloc] initWithFileName:@"Bumaga.wav"];
    [mBumagaPlayer adjustVolume:0.2f];
}

- (void)setMainProp {
    //set main prop
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgorund.png"]];
    self.viewDeckController.delegate = self;
    mPriceView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    mThanksLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paper_texture.png"]];
    menuTableViewController.delegate = self;
    priceTableViewController.delegate = self;
    
    //set scroll prop
    [mMainView setContentSize:CGSizeMake(320, 830)];
    CGPoint bottomOffset = CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
    [mMainView setContentOffset:bottomOffset animated:NO];
    [mMainView setScrollEnabled:NO];
    
    [self setMainCheckViewFrameWithAnimation:NO duration:0];
    CGRect rect = mCheckView.frame;
    rect.origin.y = BEGIN_Y - BEGIN_OFFSET;
    [mCheckView setFrame:rect];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.5f];
}

- (void)volume:(float)volume {
    [mKassaPlayer adjustVolume:volume];
    [mBumagaPlayer adjustVolume:volume];
}

- (void)newCheck {
    [mBumagaPlayer playAudio];
    [priceTableViewController clearCheck];
    mPrice = 0;
    mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
    [UIView transitionWithView:mCheckView
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{
                        mCheckView.hidden = YES;
                        mMaskView.clipsToBounds = NO;
                    }
                    completion:^(BOOL finished) {
                        [self setMainCheckViewFrameWithAnimation:NO duration:0.0f];
                        CGRect rect = mCheckView.frame;
                        rect.origin.y = BEGIN_Y - BEGIN_OFFSET;
                        [mCheckView setFrame:rect];
                        mCheckView.hidden = NO;
                        mMaskView.clipsToBounds = YES;
                        mPaperTopImageView.hidden = YES;
                        [self setMainCheckViewFrameWithAnimation:YES duration:0.5f];
                    }];
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
        appDelegate.viewController.viewDeckController.panningMode = IIViewDeckNoPanning;
    } else if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        CGPoint bottomOffset =  CGPointMake(0, mMainView.contentSize.height - mMainView.frame.size.height);
        [mMainView setContentOffset:bottomOffset animated:YES];
        [priceTableViewController goToTop:NO];
        appDelegate.viewController.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    } else if(gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self newCheck];
    }
}

- (IBAction)changeMenuClicked:(id)sender {
    static int index = 0;
    if(menuTableViewController.arrayOfMenuItemGroups.count > 0) {
        index = (index + 1) % menuTableViewController.arrayOfMenuItemGroups.count;
        [menuTableViewController nextMenuByIndex:index];
        GroupItem *groupItem = [menuTableViewController.arrayOfMenuItemGroups objectAtIndex:index];
        [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
        mPageControl.currentPage = index;
    }
}

- (IBAction)menuClicked:(id)sender {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.viewController.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)newChecked:(id)sender {
    [self newCheck];
}

#pragma mark - MenuTableViewController Delegate

- (void)getAllProducts {
    GroupItem *groupItem = [menuTableViewController.arrayOfMenuItemGroups objectAtIndex:0];
    [currentGroupBtn setTitle:groupItem.groupName forState:UIControlStateNormal];
    mPageControl.numberOfPages = menuTableViewController.arrayOfMenuItemGroups.count;
    mPageControl.currentPage = 0;
}

- (void)getNewPrice:(MenuItem *)menu {
    [mKassaPlayer playAudio];
    
    mPrice += menu.menuPrice.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
    [priceTableViewController addNewProduct:menu];
    
    //CGRect rect = mCheckView.frame;
    //rect.origin.y = BEGIN_Y;
    //[mCheckView setFrame:rect];
    [priceTableViewController goToTop:NO];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.3f];
}

#pragma mark - PriceTableViewController Delegate

- (void)deleteProductWithPrice:(MenuItem *)menuItem count:(NSNumber *)count{
    mPrice -= menuItem.menuPrice.integerValue * count.integerValue;
    mPriceLbl.text = [NSString stringWithFormat:@"%d", mPrice];
    //CGRect rect = mCheckView.frame;
    //rect.origin.y = BEGIN_Y;
    //[mCheckView setFrame:rect];
    [self setMainCheckViewFrameWithAnimation:YES duration:0.3f];
}

#pragma mark - Set Frames Functions

- (void)setMainCheckViewFrameWithAnimation:(BOOL)animate duration:(float)duration {
    if(animate) {
        [UIView beginAnimations : @"Display notif" context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(finishAnimation)];
    }
    CGRect frameOfThanksView = mThanksView.frame;
    
    [priceTableViewController setTableViewFrameByCells];
    CGRect frameOfPriceTableView = priceTableViewController.tableView.frame;
    frameOfPriceTableView.origin.y = frameOfThanksView.size.height + frameOfThanksView.origin.y;
    
    [priceTableViewController.tableView setFrame:frameOfPriceTableView];
    CGRect frameOfPriceView = mPriceView.frame;
    frameOfPriceView.origin.y = frameOfPriceTableView.origin.y + frameOfPriceTableView.size.height;
    [mPriceView setFrame:frameOfPriceView];
    
    CGRect frameOfCheckView = mCheckView.frame;
    frameOfCheckView.size.height = frameOfThanksView.size.height + frameOfPriceTableView.size.height + frameOfPriceView.size.height;
    frameOfCheckView.origin.y = BEGIN_Y - frameOfCheckView.size.height;
    [mCheckView setFrame:frameOfCheckView];
    if(animate) {
        [UIView commitAnimations];
    }
}

#pragma mark - IIViewDeckCountroller Delegate

- (void)viewDeckControllerDidOpenLeftView:(IIViewDeckController*)viewDeckController animated:(BOOL)animated {
    [mThanksView removeGestureRecognizer:mGestureRecognizerDown];
    [mThanksView removeGestureRecognizer:mGestureRecognizerUp];
    [mThanksView removeGestureRecognizer:mGestureRecognizerLeft];
    [mPriceMask removeGestureRecognizer:mGestureRecognizerDown];
    [mPriceMask removeGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask removeGestureRecognizer:mGestureRecognizerLeft];
}

- (void)viewDeckControllerDidCloseLeftView:(IIViewDeckController *)viewDeckController animated:(BOOL)animated {
    [mThanksView addGestureRecognizer:mGestureRecognizerDown];
    [mThanksView addGestureRecognizer:mGestureRecognizerUp];
    [mThanksView addGestureRecognizer:mGestureRecognizerLeft];
    [mPriceMask addGestureRecognizer:mGestureRecognizerDown];
    [mPriceMask addGestureRecognizer:mGestureRecognizerUp];
    [mPriceMask addGestureRecognizer:mGestureRecognizerLeft];
}

#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
