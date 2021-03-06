//
//  UDBObject.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UDBObject.h"
#import "JSON.h"

@implementation UDBObject

@synthesize objectId;

- (id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (id)initWithArray:(NSArray *)array {
    self = [super init];
    if(self) {
        objectId = [[[array objectAtIndex:0] objectForKey:@"object_id"] retain];
        mValues = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < array.count; ++i) {
            NSDictionary *oneValue = [array objectAtIndex:i];
            NSString *attrName = [oneValue objectForKey:@"attrname"];
            [mValues setValue:oneValue forKey:attrName];
        }
    }
    return self;
}

- (id)getFieldValue:(NSString *)attrName attrFieldType:(NSString *)fieldType {
    NSDictionary *attribute = [mValues objectForKey:attrName];
    return [attribute objectForKey:fieldType];
}

@end
