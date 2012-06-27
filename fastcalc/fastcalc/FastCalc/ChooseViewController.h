//
//  ChooseViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLocationGetter.h"

@class InternetUtils, ApplicationSingleton, BrandCell;

@interface ChooseViewController : UIViewController<MLocationGetterDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mArrayOfBrandsMenus;
    NSMutableArray *mArrayOfBrands;
    UIAlertView *mLoader;
    
    InternetUtils *mInternetUtils;
    MLocationGetter *mLocationGetter;
    ApplicationSingleton *mApplicationSingleton;
    
    IBOutlet UITableView *mBrandsTable;
    IBOutlet UILabel *mLocationLbl;
    IBOutlet BrandCell *mBrandCell;
    IBOutlet UIButton *mSoundBtn;
    
    bool soundClicked;
}

- (void)getBrandsFromCache;
- (void)updateCache;
- (IBAction)reloadLocationClicked:(id)sender;
- (IBAction)reloadListClicked:(id)sender;
- (IBAction)rateClicked:(id)sender;
- (IBAction)infoClicked:(id)sender;
- (IBAction)soundClicked:(id)sender;

@end
