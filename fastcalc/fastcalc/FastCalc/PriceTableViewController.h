//
//  PriceTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BEGIN_HEIGHT 370

@class MenuItem;

@interface PriceTableViewController : UITableViewController {
    NSMutableArray *mArrayOfProducts;
}

- (void)clearCheck;
- (void)goToTop:(BOOL)toTop;
- (void)addNewProduct:(MenuItem *)menuItem;

@end
