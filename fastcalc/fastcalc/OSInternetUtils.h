//
//  OSInternetUtils.h
//  OrionSource FrameWork
//
//  Created by Дмитрий Нелепов on 16.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSInternetUtilsProgressInfo : NSObject
@property(nonatomic,retain) NSString* textProgress;
@property(nonatomic,retain) NSNumber* contentSize;
@property(nonatomic,retain) NSNumber* contentLoaded;
+(OSInternetUtilsProgressInfo*)makeProgress:(NSString*)pTextProgress pContentSize:(NSNumber*) pContentSize pContentLoaded:(NSNumber*) pContentLoaded;
@end


@interface OSInternetUtils : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * receivedData;
    id currentReceiver;
    NSString *currentFunctionName;
    NSString *currentProgressFunctionName;
    NSString *currentErrorFunctionName;
    float mFileTotalSize;
    float mReceivedDataBytes;
    NSURLConnection *requestConnection;
}
+(NSString*)formatRequestParams:(NSDictionary*) requestParams;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest errorFunctionName:(NSString*)errorFunctionName;


-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName;

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName errorFunctionName:(NSString*)errorFunctionName;

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest;

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName;


@end
