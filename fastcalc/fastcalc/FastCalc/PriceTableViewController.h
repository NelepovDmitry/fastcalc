//
//  PriceTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BEGIN_HEIGHT 306

@class MenuItem;

@protocol PriceTableViewControllerDelegate

- (void)deleteProductWithPrice:(MenuItem *)menuItem count:(NSNumber *)count;

@end

@interface PriceTableViewController : UITableViewController {
    NSMutableArray *mArrayOfProducts;
    NSMutableArray *mArrayOfCounts;
}

@property (retain, nonatomic) id<PriceTableViewControllerDelegate> delegate;

- (void)clearCheck;
- (void)goToTop:(BOOL)toTop;
- (void)addNewProduct:(MenuItem *)menuItem;
- (void)setTableViewFrameByCells;

@end
