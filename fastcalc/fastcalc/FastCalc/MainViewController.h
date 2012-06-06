//
//  MainViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceTableViewController, MenuTableViewController;

@interface MainViewController : UIViewController {
    IBOutlet UIView *mAnimationView;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerDown;
    IBOutlet UISwipeGestureRecognizer *mGestureRecognizerUp;
    IBOutlet UILabel *mTotalLbl;
    IBOutlet UIView *mCheckView;
    IBOutlet UIScrollView *mMainView;
}

- (void)newCheck;
- (IBAction)gestureTaped:(id)sender;

@property (retain, nonatomic) IBOutlet PriceTableViewController *priceTableViewController;
@property (retain, nonatomic) IBOutlet MenuTableViewController *menuTableViewController;

@end
