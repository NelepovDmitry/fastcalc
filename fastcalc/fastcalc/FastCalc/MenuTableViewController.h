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
    NSMutableArray *arrayOfProducts;
    ApplicationSingleton *mApplicationSingleton;
}

@property (nonatomic, assign) id<MenuTableViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet MenuCell *menuCell;

- (void)setArrayOfTableView:(NSArray *)array;

@end
