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

@end
