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

#define BEGIN_RECT CGRectMake(0, 416, 288, 416)


@interface MainViewController : UIViewController <MenuTableViewControllerDelegate, PriceTableViewControllerDelegate> {
    IBOutlet UIView *mAnimationView;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerDown;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerUp;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerLeft;
    IBOutlet UILabel *mTotalLbl;
    IBOutlet UIView *mCheckView;
    IBOutlet UIView *mMaskView;
    IBOutlet UIView *mPriceView;
    IBOutlet UIScrollView *mMainView;
    IBOutlet UIImageView *mPaperBottomImageView;
    IBOutlet UIImageView *mPaperTopImageView;
    IBOutlet UILabel *mPriceLbl;
    IBOutlet UIButton *currentGroupBtn;
    IBOutlet UIPageControl *mPageControl;
    
    NSInteger mPrice;
}

- (void)newCheck;
- (IBAction)gestureTaped:(id)sender;
- (IBAction)changeMenuClicked:(id)sender;
- (IBAction)menuClicked:(id)sender;
- (IBAction)newChecked:(id)sender;


@property (retain, nonatomic) IBOutlet PriceTableViewController *priceTableViewController;
@property (retain, nonatomic) IBOutlet MenuTableViewController *menuTableViewController;

@end
