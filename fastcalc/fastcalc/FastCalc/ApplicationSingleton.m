//
//  ApplicationSingleton.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 02.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ApplicationSingleton.h"

@implementation ApplicationSingleton

@synthesize idOfCity, nameOfCity;

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
    
    self.idOfCity = [NSNumber numberWithInt:[prefs integerForKey:ID_OF_CITY]];
    self.nameOfCity = [prefs stringForKey:NAME_OF_CITY];
}

- (void)commitSettings {
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:idOfCity.intValue forKey:ID_OF_CITY];
    [prefs setObject:nameOfCity forKey:NAME_OF_CITY];
    [prefs synchronize];
}

@end
