//
//  GroupItem.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 22.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

@synthesize groupName;

- (id)initWithArray:(NSArray *)array {
    self = [super initWithArray:array];
    if(self) {
        groupName = [self getFieldValue:@"Group menu item info_Name" attrFieldType:STRING_VALUE];
    }
    return self;
}

@end
