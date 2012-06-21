//
//  MenuItem.m
//  FastCalc
//
//  Created by Петросян Геворг on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize menuName, menuPrice, menuPicturePath;

- (id)initWithArray:(NSArray *)array {
    self = [super initWithArray:array];
    if(self) {
        menuName = [self getFieldValue:@"Menu item info_Name" attrFieldType:STRING_VALUE];
        menuPrice = [self getFieldValue:@"Menu item info_Price" attrFieldType:FLOAT_VALUE];
        menuPicturePath = [self getFieldValue:@"Menu item info_Item picture" attrFieldType:CONTENT_VALUE];
    }
    return self;
}

+ (id)menuItemWithName:(NSString *)name price:(NSNumber *)price {
    MenuItem *menuItem = [[[MenuItem alloc] init] autorelease];
    menuItem.menuName = name;
    menuItem.menuPrice = price;
    return menuItem;
}

@end
