//
//  BrandMenu.m
//  FastCalc
//
//  Created by Петросян Геворг on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrandMenu.h"

@implementation BrandMenu

@synthesize brandMenuName, brandMenuCityId;

- (id)initWithArray:(NSArray *)array {
    self = [super initWithArray:array];
    if(self) {
        brandMenuName = [self getFieldValue:@"Menu info_Name" attrFieldType:STRING_VALUE];
        brandMenuCityId = [self getFieldValue:@"Menu info_City ID" attrFieldType:REFERENCE_VALUE];
    }
    return self;
}

@end
