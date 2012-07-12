//
//  PriceCell.m
//  FastCalc
//
//  Created by Петросян Геворг on 27.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PriceCell.h"

@implementation PriceCell
@synthesize deleteBtn;
@synthesize nameLbl;
@synthesize priceLbl;
@synthesize countLbl;
@synthesize kCalLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [deleteBtn release];
    [nameLbl release];
    [priceLbl release];
    [countLbl release];
    [kCalLbl release];
    [super dealloc];
}
@end
