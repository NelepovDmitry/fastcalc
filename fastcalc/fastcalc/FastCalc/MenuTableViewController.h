//
//  MenuTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InternetUtils, MenuItem, ApplicationSingleton, MenuCell;

@protocol MenuTableViewControllerDelegate <NSObject>

- (void)getNewPrice:(MenuItem *)price;
- (void)getAllProducts;

@end


@interface MenuTableViewController : UITableViewController {
    NSMutableArray *mArrayOfProductsNames;
    NSMutableDictionary *mDictOfProducts;
    NSInteger indexOfMenu;
    
    InternetUtils *mInternetUtils;
    ApplicationSingleton *mApplicationSingleton;
    
    UIAlertView *mLoader;
}

@property (nonatomic, assign) id<MenuTableViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *arrayOfMenuItemGroups;
@property (retain, nonatomic) IBOutlet MenuCell *menuCell;

- (void)nextMenuByIndex:(NSInteger)menuIndex;
- (void)requsetMenuById:(NSNumber *)menuId;

@end
