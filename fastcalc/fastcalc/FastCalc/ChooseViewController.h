//
//  ChooseViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLocationGetter.h"

@class InternetUtils, ApplicationSingleton, EGOCache;

@interface ChooseViewController : UIViewController<MLocationGetterDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *mArrayOfBrands;
    
    InternetUtils *mInternetUtils;
    MLocationGetter *mLocationGetter;
    ApplicationSingleton *mApplicationSingleton;
    EGOCache *mCache;
    
    bool isLoadingAddress;
    IBOutlet UITableView *mBrandsTable;
}

- (void)getBrandsFromCacheById:(NSNumber *)brandId;

@end
