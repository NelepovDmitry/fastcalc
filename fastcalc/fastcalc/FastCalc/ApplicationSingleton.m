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

@end
