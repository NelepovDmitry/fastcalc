//
//  Brand.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Brand.h"

@implementation Brand
@synthesize brandName;

- (id)initWithDictionary:(NSArray *)array {
    self = [super initWithDictionary:array];
    if(self) {
        brandName = [self getFieldValue:@"Brand main info_Name" attrFieldType:STRING_VALUE];
    }
    return self;
}

@end
