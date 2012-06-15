//
//  MenuItem.m
//  FastCalc
//
//  Created by Петросян Геворг on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize menuName, menuPrice;

- (id)initWithArray:(NSArray *)array {
    self = [super initWithArray:array];
    if(self) {
        menuName = [self getFieldValue:@"Menu item info_Name" attrFieldType:STRING_VALUE];
        menuPrice = [self getFieldValue:@"Menu item info_Price" attrFieldType:FLOAT_VALUE];
    }
    return self;
}

@end
