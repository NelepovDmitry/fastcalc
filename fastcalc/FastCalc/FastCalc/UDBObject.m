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

- (id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (id)initWithDictionary:(NSArray *)array {
    self = [super init];
    if(self) {
        mObjectId = [[array objectAtIndex:0] objectForKey:@"object_id"];
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
    NSDictionary *attribute = [mValues objectForKey:@"attrName"];
    return [attribute objectForKey:fieldType];
}

@end
