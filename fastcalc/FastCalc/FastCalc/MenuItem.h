//
//  MenuItem.h
//  FastCalc
//
//  Created by Петросян Геворг on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UDBObject.h"

@interface MenuItem : UDBObject

@property (nonatomic, retain) NSString *menuName;
@property (nonatomic, retain) NSNumber *menuPrice;
@property (nonatomic, retain) NSNumber *menuKcal;
@property (nonatomic, retain) NSString *menuPicturePath;

+ (id)menuItemWithName:(NSString *)name price:(NSNumber *)price;

@end
