//
//  MenuItem.m
//  FastCalc
//
//  Created by Петросян Геворг on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuItem.h"
#import "ApplicationSingleton.h"

@interface MenuItem()

- (void)loadImageToCache;

@end

@implementation MenuItem

@synthesize menuName, menuPrice, menuPicturePath, menuKcal;

- (id)initWithArray:(NSArray *)array {
    self = [super initWithArray:array];
    if(self) {
        menuName = [self getFieldValue:@"Menu item info_Name" attrFieldType:STRING_VALUE];
        menuPrice = [self getFieldValue:@"Menu item info_Price" attrFieldType:FLOAT_VALUE];
        menuPicturePath = [self getFieldValue:@"Menu item info_Item picture" attrFieldType:CONTENT_VALUE];
        menuKcal = [self getFieldValue:@"Menu item info_Calories" attrFieldType:FLOAT_VALUE];
        [self loadImageToCache];
    }
    return self;
}

- (void)loadImageToCache {
    ApplicationSingleton *applicationSingleton = [ApplicationSingleton createSingleton];
    NSString *path = [applicationSingleton cacheDirectory];
    path = [NSString stringWithFormat:@"%@/%d", path, applicationSingleton.idOfMenu.integerValue];
    NSString *imagePath = [path stringByAppendingPathComponent:menuPicturePath];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if(image != nil) {
        [applicationSingleton.dictOfMenuImages setObject:image forKey:menuPicturePath];
    }
}

+ (id)menuItemWithName:(NSString *)name price:(NSNumber *)price {
    MenuItem *menuItem = [[[MenuItem alloc] init] autorelease];
    menuItem.menuName = name;
    menuItem.menuPrice = price;
    return menuItem;
}

@end
