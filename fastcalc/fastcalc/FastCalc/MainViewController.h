//
//  MainViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewController.h"
#import "PriceTableViewController.h"
#import "IIViewDeckController.h"

#define BEGIN_Y 416

@class EClockPlayer;

@interface MainViewController : UIViewController <MenuTableViewControllerDelegate, PriceTableViewControllerDelegate, UIGestureRecognizerDelegate, IIViewDeckControllerDelegate> {
    IBOutlet UIView *mAnimationView;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerDown;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerUp;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerLeft;
    IBOutlet UILabel *mTotalLbl;
    IBOutlet UIView *mCheckView;
    IBOutlet UIView *mMaskView;
    IBOutlet UIView *mThanksView;
    IBOutlet UILabel *mThanksLabel;
    IBOutlet UIView *mPriceView;
    IBOutlet UIScrollView *mMainView;
    IBOutlet UIImageView *mPaperBottomImageView;
    IBOutlet UIImageView *mPaperTopImageView;
    IBOutlet UILabel *mPriceLbl;
    IBOutlet UIButton *currentGroupBtn;
    IBOutlet UIPageControl *mPageControl;
    IBOutlet UIImageView *mPriceMask;
    
    NSInteger mPrice;
    
    EClockPlayer *mKassaPlayer;
    EClockPlayer *mBumagaPlayer;
}

- (void)newCheck;
- (IBAction)gestureTaped:(id)sender;
- (IBAction)changeMenuClicked:(id)sender;
- (IBAction)menuClicked:(id)sender;
- (IBAction)newChecked:(id)sender;
- (void)volume:(float)volume;

@property (retain, nonatomic) IBOutlet PriceTableViewController *priceTableViewController;
@property (retain, nonatomic) IBOutlet MenuTableViewController *menuTableViewController;

@end
