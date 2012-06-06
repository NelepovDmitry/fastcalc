//
//  PriceTableViewController.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COUNT 3
#define BEGIN_HEIGHT 370

@interface PriceTableViewController : UITableViewController {
    
    IBOutlet UITableView *mTableView;
}

- (void)goToTop:(BOOL)toTop;

@end
