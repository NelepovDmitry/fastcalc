//
//  UDBObject.h
//  FastCalc
//
//  Created by Gevorg Petrosyan on 15.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STRING_VALUE @"string_value"
#define INTEGER_VALUE @"integer_value"
#define FLOAT_VALUE @"float_value"
#define DATE_VALUE @"date_value"
#define CONTENT_VALUE @"content_value"
#define REFERENCE_VALUE @"reference_value"

@interface UDBObject : NSObject {
    NSMutableDictionary *mValues;
}

@property (nonatomic, retain) NSNumber *objectId;

- (id)initWithArray:(NSArray *)array;
- (id)getFieldValue:(NSString *)attrName attrFieldType:(NSString *)fielddType;

@end
