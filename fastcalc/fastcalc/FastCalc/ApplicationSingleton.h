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
#define ALREADY_RUN @"already_run"
//-1 0 1
#define CONTROLLERS_DIRACTION @"controller_diractions"

@interface ApplicationSingleton : NSObject

+ (ApplicationSingleton *)createSingleton;

@property (nonatomic, retain) NSNumber *idOfCity;
@property (nonatomic, retain) NSString *nameOfCity;
@property (nonatomic, assign) BOOL alreadyRun;
@property (nonatomic, assign) BOOL firstStart;
@property (nonatomic, assign) NSInteger controllerDiraction;

- (void)updateSettings;
- (void)commitSettings;

@end
