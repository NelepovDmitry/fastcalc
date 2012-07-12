//
//  ApplicationSingleton.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 02.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationSingleton.h"
#import "MainViewController.h"
#import "Brand.h"

@implementation ApplicationSingleton

@synthesize idOfCity, nameOfCity, alreadyRun, firstStart, controllerDiraction, idOfMenu, dictOfMenuImages, mainViewController, brandPath;

+ (ApplicationSingleton *)createSingleton {
    static ApplicationSingleton *singleton;
    @synchronized(self) 
    {
        if (!singleton) {
            singleton = [[ApplicationSingleton alloc] init];
        }
        return singleton;
    }
}

- (id)init {
    self = [super init];
    if(self) {
        [self updateSettings];
    }
    return self;
}

- (void)dealloc {
    [mCacheDirectory release];
    [super dealloc];
}

#pragma mark - Public functions

+ (BOOL)isMenuExistinChache:(NSNumber *)menuId {
    NSString *cachesDirectory = [[ApplicationSingleton createSingleton] cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d", menuId.intValue]];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:storePath];
    return fileExists;
}

+ (BOOL)removeDirectoryById:(NSNumber *)menuId {
    NSString *cachesDirectory = [[ApplicationSingleton createSingleton] cacheDirectory];
    NSString *storePath = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d", menuId.intValue]];
	NSError *error;
    BOOL p = NO;
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
		if ([[NSFileManager defaultManager] removeItemAtPath:storePath error:&error]) {
            p = YES;
        }
	}
    return p;
}

- (void)updateSettings {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    alreadyRun = [prefs boolForKey:ALREADY_RUN];
    firstStart = true;
    self.dictOfMenuImages = [[NSMutableDictionary alloc] init];
    if(alreadyRun) {
        firstStart = false;
        self.idOfMenu = [NSNumber numberWithInt:[prefs integerForKey:ID_OF_MENU]];
        self.idOfCity = [NSNumber numberWithInt:[prefs integerForKey:ID_OF_CITY]];
        self.nameOfCity = [prefs stringForKey:NAME_OF_CITY];
        self.alreadyRun = [prefs boolForKey:ALREADY_RUN];
        self.controllerDiraction = [prefs integerForKey:CONTROLLERS_DIRACTION];
        self.brandPath = [prefs stringForKey:BRAND_PATH];
    } else {
        mCacheDirectory = @"";
        self.idOfCity = [NSNumber numberWithInt:0];
        self.idOfMenu = [NSNumber numberWithInt:0];
        self.nameOfCity = @"";
        self.alreadyRun = YES;
        self.controllerDiraction = 1;
        self.brandPath = @"";
        [self commitSettings];
    }
}

- (void)commitSettings {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:self.idOfMenu.intValue forKey:ID_OF_MENU];
    [prefs setInteger:self.idOfCity.intValue forKey:ID_OF_CITY];
    [prefs setBool:self.alreadyRun forKey:ALREADY_RUN];
    [prefs setObject:self.nameOfCity forKey:NAME_OF_CITY];
    [prefs setInteger:self.controllerDiraction forKey:CONTROLLERS_DIRACTION];
    [prefs setObject:self.brandPath forKey:BRAND_PATH];
    [prefs synchronize];
}

- (NSString *)cacheDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

@end
