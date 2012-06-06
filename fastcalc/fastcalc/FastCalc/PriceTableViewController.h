//
//  PriceTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceTableViewController : UITableViewController {
    
    IBOutlet UITableView *mTableView;
}

- (void)goToTop:(BOOL)toTop;

@end
