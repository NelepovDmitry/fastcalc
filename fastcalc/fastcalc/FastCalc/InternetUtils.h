//
//  InternetUtils.h
//  Rent
//
//  Created by Gevorg Petrosyan on 04.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define URL @"http://tfc.orionsource.ru/api/"

@interface OSInternetUtilsProgressInfo : NSObject
@property(nonatomic,retain) NSString* textProgress;
@property(nonatomic,retain) NSNumber* contentSize;
@property(nonatomic,retain) NSNumber* contentLoaded;
+(OSInternetUtilsProgressInfo*)makeProgress:(NSString*)pTextProgress pContentSize:(NSNumber*) pContentSize pContentLoaded:(NSNumber*) pContentLoaded;
@end

@interface InternetUtils : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * receivedData;
    id currentReceiver;
    NSString *currentFunctionName;
    NSString *currentProgressFunctionName;
    NSString *currentErrorFunctionName;
    float mFileTotalSize;
    float mReceivedDataBytes;
}
+(NSString*)formatRequestParams:(NSDictionary*) requestParams;

-(void)makeURLDataRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall responder:(id)responderRequest data:(NSData *)data;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest errorFunctionName:(NSString*)errorFunctionName;


-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName errorFunctionName:(NSString*)errorFunctionName;

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest;

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName;

@end
