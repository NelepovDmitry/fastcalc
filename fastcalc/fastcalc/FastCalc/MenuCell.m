//
//  MenuCell.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 04.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell
@synthesize backgroundImage;
@synthesize menuImage;
@synthesize textLabel;
@synthesize priceLabel;

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
    // Configure the view for the selected state
}

- (void)dealloc {
    [backgroundImage release];
    [menuImage release];
    [textLabel release];
    [priceLabel release];
    [super dealloc];
}
@end
