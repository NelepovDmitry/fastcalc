//
//  MenuTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuTableViewControllerDelegate <NSObject>

- (void)getNewPrice:(NSNumber *)price;

@end

@class InternetUtils;

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
