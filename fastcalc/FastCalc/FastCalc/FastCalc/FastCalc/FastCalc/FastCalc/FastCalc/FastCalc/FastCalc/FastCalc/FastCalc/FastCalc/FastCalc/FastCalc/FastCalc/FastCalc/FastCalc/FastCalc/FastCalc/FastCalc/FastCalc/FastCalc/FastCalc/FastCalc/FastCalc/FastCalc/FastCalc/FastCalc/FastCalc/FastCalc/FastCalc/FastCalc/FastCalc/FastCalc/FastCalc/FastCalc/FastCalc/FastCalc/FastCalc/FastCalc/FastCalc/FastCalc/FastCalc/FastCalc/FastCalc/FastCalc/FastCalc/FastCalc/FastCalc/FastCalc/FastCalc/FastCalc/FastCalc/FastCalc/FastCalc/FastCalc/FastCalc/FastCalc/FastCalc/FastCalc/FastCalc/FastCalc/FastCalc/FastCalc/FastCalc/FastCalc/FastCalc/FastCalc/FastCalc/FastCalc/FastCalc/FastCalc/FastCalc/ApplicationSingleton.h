//
//  ApplicationSingleton.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 02.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ID_OF_CITY @"id_of_city"
#define ID_OF_MENU @"id_of_menu"
#define NAME_OF_CITY @"name_of_city"
#define ALREADY_RUN @"already_run"
//-1 0 1
#define CONTROLLERS_DIRACTION @"controller_diractions"

@class MainViewController;

@interface ApplicationSingleton : NSObject {
    NSString *mCacheDirectory;
}

+ (ApplicationSingleton *)createSingleton;

@property (nonatomic, retain) NSNumber *idOfMenu;
@property (nonatomic, retain) NSNumber *idOfCity;
@property (nonatomic, retain) NSString *nameOfCity;
@property (nonatomic, assign) BOOL alreadyRun;
@property (nonatomic, assign) BOOL firstStart;
@property (nonatomic, assign) NSInteger controllerDiraction;

@property (nonatomic, retain) NSMutableDictionary *dictOfMenuImages;
@property (nonatomic, retain) MainViewController *mainViewController;

- (void)updateSettings;
- (void)commitSettings;

+ (BOOL)isMenuExistinChache:(NSNumber *)menuId;
+ (BOOL)removeDirectoryById:(NSNumber *)menuId;
- (NSString *)cacheDirectory;

@end
