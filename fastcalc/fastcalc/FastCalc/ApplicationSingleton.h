//
//  ApplicationSingleton.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 02.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID_OF_CITY @"id_of_city"
#define NAME_OF_CITY @"name_of_city"

@interface ApplicationSingleton : NSObject

+ (ApplicationSingleton *)createSingleton;

@property (nonatomic, retain) NSNumber *idOfCity;
@property (nonatomic, retain) NSString *nameOfCity;

- (void)updateSettings;
- (void)commitSettings;

@end
