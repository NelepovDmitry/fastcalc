//
//  ChooseViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLocationGetter.h"

@class InternetUtils;

@interface ChooseViewController : UIViewController<MLocationGetterDelegate> {
    NSMutableArray *mArrayOfCities;
    NSMutableArray *mArrayOfBrands;
    
    InternetUtils *mInternetUtils;
    MLocationGetter *mLocationGetter;
    
    bool isLoadingAddress;
}

@end
