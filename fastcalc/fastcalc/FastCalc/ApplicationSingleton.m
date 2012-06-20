//
//  ApplicationSingleton.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 02.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationSingleton.h"

@implementation ApplicationSingleton

@synthesize idOfCity, nameOfCity, alreadyRun, firstStart, controllerDiraction;

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
    [idOfCity release];
    [super dealloc];
}

#pragma mark - Public functions


- (void)updateSettings {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs synchronize];
    alreadyRun = [prefs boolForKey:ALREADY_RUN];
    firstStart = true;
    if(alreadyRun) {
        firstStart = false;
        self.idOfCity = [NSNumber numberWithInt:[prefs integerForKey:ID_OF_CITY]];
        self.nameOfCity = [prefs stringForKey:NAME_OF_CITY];
        self.alreadyRun = [prefs boolForKey:ALREADY_RUN];
        self.controllerDiraction = [prefs integerForKey:CONTROLLERS_DIRACTION];
    } else {
        self.idOfCity = [NSNumber numberWithInt:0];
        self.nameOfCity = @"";
        self.alreadyRun = YES;
        self.controllerDiraction = 1;
        [self commitSettings];
    }
}

- (void)commitSettings {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:idOfCity.intValue forKey:ID_OF_CITY];
    [prefs setBool:alreadyRun forKey:ALREADY_RUN];
    [prefs setObject:nameOfCity forKey:NAME_OF_CITY];
    [prefs setInteger:controllerDiraction forKey:CONTROLLERS_DIRACTION];
    [prefs synchronize];
}

@end
