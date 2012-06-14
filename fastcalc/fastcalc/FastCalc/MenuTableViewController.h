//
//  MenuTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InternetUtils;

@interface MenuTableViewController : UITableViewController {
    NSMutableArray *mArrayOfProducts;
    
    InternetUtils *mInternetUtils;
}

- (void)nextMenu;
- (void)requsetMenuById:(NSNumber *)menuId;

@end
