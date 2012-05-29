//
//  OSInternetUtils.m
//  OrionSource FrameWork
//
//  Created by Дмитрий Нелепов on 16.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OSInternetUtils.h"
#import "Reachability.h"

@implementation OSInternetUtilsProgressInfo 
@synthesize contentSize,textProgress,contentLoaded;

+(OSInternetUtilsProgressInfo*)makeProgress:(NSString*)pTextProgress pContentSize:(NSNumber*) pContentSize pContentLoaded:(NSNumber*) pContentLoaded{
    OSInternetUtilsProgressInfo * progressInfo=[[[OSInternetUtilsProgressInfo alloc] init] autorelease];
    progressInfo.textProgress=[NSString  stringWithFormat:pTextProgress];
    progressInfo.contentSize=pContentSize ;
    progressInfo.contentLoaded=pContentLoaded;
    return progressInfo;
}

@end


@implementation OSInternetUtils

- (bool)checkInternetConnaction {
    Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
	if ([internetConnection currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}


+(NSString*)formatRequestParams:(NSDictionary*) requestParams{
    NSString * retRequest=@"";
    NSMutableString * requestStrings=[[NSMutableString alloc] initWithString:@""];
    NSLog(@"PARAMS:%@",requestParams);
    
    for (NSString * key in requestParams){
        NSLog(@"KEY:%@ and Value:%@",key,[requestParams objectForKey:key]);
        [requestStrings appendFormat:@"%@=%@&",key,[requestParams objectForKey:key]];
        
    }
    NSString * completeString=[NSString stringWithString:requestStrings];
    if (completeString.length>0){
        retRequest=[completeString substringToIndex:completeString.length-1];
    }
    [requestStrings release];
    return retRequest;
}

-(id) init{
    self=[super init];
    if (self){
        receivedData=[[NSMutableData alloc] init];
    }
    return self;
}

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest{
    currentReceiver=responderRequest;
    currentFunctionName=functionName;
    
    if ([self checkInternetConnaction]){
        
        NSString * requestParams=[OSInternetUtils formatRequestParams:requestParameters]; // задаем параметры POST запроса
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:urlCall];
        request.HTTPMethod = @"POST";
        if (requestParams.length>0){
            request.HTTPBody = [requestParams dataUsingEncoding:NSUTF8StringEncoding]; // следует обратить внимание на кодировку
        }
        NSLog(@"Request:%@",request.URL.absoluteString); 
        requestConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self] ;
        //[NSURLConnection connectionWithRequest:<#(NSURLRequest *)#> delegate:<#(id)#>
        if (requestConnection){
            //receivedData=[[NSMutableData data] retain];
            [receivedData setLength:0];
            //[requestConnection release];
        }
        //[requestConnection release];
    }else{
        if (currentErrorFunctionName!=nil){
            [currentReceiver performSelectorOnMainThread:NSSelectorFromString(currentErrorFunctionName) withObject:@"No internet" waitUntilDone:NO];
            //[currentReceiver performSelector:NSSelectorFromString(currentErrorFunctionName) withObject:@"No internet"];
        }
    }
    // [requestConnection release];
}

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest errorFunctionName:(NSString*)errorFunctionName{
    currentErrorFunctionName=errorFunctionName;
    [self makeURLRequestByNameResponser:functionName urlCall:urlCall requestParams:requestParameters responder:responderRequest];
}

//Method with connection catcher delegate methods
-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest  progressFunctionName:(NSString*)progressFunctionName{
    currentProgressFunctionName=progressFunctionName;
    [self makeURLRequestByNameResponser:functionName urlCall:urlCall requestParams:requestParameters responder:responderRequest];
}

-(void)makeURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName errorFunctionName:(NSString*)errorFunctionName{
    currentErrorFunctionName=errorFunctionName;
    [self makeURLRequestByNameResponser:functionName urlCall:urlCall requestParams:requestParameters responder:responderRequest progressFunctionName:progressFunctionName];
}

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest{
    currentReceiver=responderRequest;
    currentFunctionName=functionName;
    
    NSString * requestParams=[OSInternetUtils formatRequestParams:requestParameters]; // задаем параметры GET запроса
    
    NSString * getRequest=[NSString stringWithFormat:@"%@%@", [urlCall absoluteString],requestParams];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getRequest]];
    
    requestConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (requestConnection){
        [receivedData setLength:0];
    }
    //[requestConnection release];
    
}

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName{
    currentProgressFunctionName=progressFunctionName;
    [self makeGetURLRequestByNameResponser:functionName urlCall:urlCall requestParams:requestParameters responder:responderRequest];
}



#pragma mark - NSURL Delegates methods


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (currentProgressFunctionName!=nil){
        mReceivedDataBytes += [data length];
        [currentReceiver performSelectorOnMainThread:NSSelectorFromString(currentProgressFunctionName) withObject:[OSInternetUtilsProgressInfo makeProgress:@"Downloading" pContentSize:[NSNumber numberWithFloat:mFileTotalSize] pContentLoaded:[NSNumber numberWithFloat:mReceivedDataBytes]] waitUntilDone:NO];

    }
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    mFileTotalSize=response.expectedContentLength;
    mReceivedDataBytes=0;
    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [connection release];
    //[receivedData release];
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    SEL functionSelector=NSSelectorFromString(currentFunctionName);
    [currentReceiver performSelectorOnMainThread:functionSelector withObject:receivedData waitUntilDone:NO];
    // release the connection, and the data object
    [connection release];
}

-(void)dealloc{
    [receivedData release];
    [super dealloc];
}

@end
