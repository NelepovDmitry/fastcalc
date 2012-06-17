//
//  MenuTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InternetUtils, MenuItem;

@protocol MenuTableViewControllerDelegate <NSObject>

- (void)getNewPrice:(MenuItem *)price;

@end


@interface MenuTableViewController : UITableViewController {
    NSMutableArray *mArrayOfProductsNames;
    NSMutableDictionary *mDictOfProducts;
    NSInteger indexOfMenu;
    
    InternetUtils *mInternetUtils;
    
    
}

@property (nonatomic, assign) id<MenuTableViewControllerDelegate> delegate;

- (void)nextMenu;
- (void)requsetMenuById:(NSNumber *)menuId;

@end
