//
//  PriceCell.h
//  FastCalc
//
//  Created by Петросян Геворг on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *deleteBtn;
@property (retain, nonatomic) IBOutlet UILabel *nameLbl;
@property (retain, nonatomic) IBOutlet UILabel *priceLbl;
@property (retain, nonatomic) IBOutlet UILabel *countLbl;
@property (retain, nonatomic) IBOutlet UILabel *kCalLbl;

@end
