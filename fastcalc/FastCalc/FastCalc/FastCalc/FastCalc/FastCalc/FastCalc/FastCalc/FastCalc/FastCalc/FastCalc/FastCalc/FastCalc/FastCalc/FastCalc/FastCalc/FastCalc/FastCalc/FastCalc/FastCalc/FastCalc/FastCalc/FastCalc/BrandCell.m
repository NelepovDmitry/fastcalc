//
//  BarndCell.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 26.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrandCell.h"

@implementation BrandCell
@synthesize brandImageView;
@synthesize brandLbl;
@synthesize reloadBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [brandImageView release];
    [brandLbl release];
    [reloadBtn release];
    [super dealloc];
}

@end
