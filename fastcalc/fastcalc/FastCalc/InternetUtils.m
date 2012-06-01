//
//  InternetUtils.m
//  Rent
//
//  Created by Gevorg Petrosyan on 04.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InternetUtils.h"
#import "Reachability.h"

@implementation OSInternetUtilsProgressInfo 
@synthesize contentSize,textProgress,contentLoaded;

+(OSInternetUtilsProgressInfo*)makeProgress:(NSString*)pTextProgress pContentSize:(NSNumber*) pContentSize pContentLoaded:(NSNumber*) pContentLoaded{
    OSInternetUtilsProgressInfo * progressInfo=[[OSInternetUtilsProgressInfo alloc] init];
    progressInfo.textProgress=[[NSString alloc] initWithString:pTextProgress];
    progressInfo.contentSize=[pContentSize retain];
    progressInfo.contentLoaded=[pContentLoaded retain];
    return progressInfo;
}

@end


@implementation InternetUtils


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
        
        NSString * requestParams=[InternetUtils formatRequestParams:requestParameters]; // задаем параметры POST запроса
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:urlCall];
        request.HTTPMethod = @"POST";
        if (requestParams.length>0){
            request.HTTPBody = [requestParams dataUsingEncoding:NSUTF8StringEncoding]; // следует обратить внимание на кодировку
        }
        NSLog(@"Request:%@",request.URL.absoluteString); 
        NSURLConnection *requestConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self] ;
        if (requestConnection){
            //receivedData=[[NSMutableData data] retain];
            [receivedData setLength:0];
            //[requestConnection release];
        }
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
    
    NSString * requestParams=[InternetUtils formatRequestParams:requestParameters]; // задаем параметры GET запроса
    
    NSString * getRequest=[NSString stringWithFormat:@"%@%@", [urlCall absoluteString],requestParams];
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getRequest]];
    
    NSURLConnection *requestConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (requestConnection){
        [receivedData setLength:0];
    }
    //[requestConnection release];
    
}

-(void)makeGetURLRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall requestParams:(NSDictionary*)requestParameters responder:(id)responderRequest progressFunctionName:(NSString*)progressFunctionName{
    currentProgressFunctionName=progressFunctionName;
    [self makeGetURLRequestByNameResponser:functionName urlCall:urlCall requestParams:requestParameters responder:responderRequest];
}

-(void)makeURLDataRequestByNameResponser:(NSString*)functionName urlCall:(NSURL*)urlCall responder:(id)responderRequest data:(NSData *)data {
    currentFunctionName = functionName;
    currentReceiver = responderRequest;
    NSURL *requestURL = urlCall;
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];                                    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"BbC04y";
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
     
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    //for (NSString *param in _params) {
    //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    //}
    
    // add image data
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"IMG_0255.JPG\"\r\n", @"pics"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    // set URL
    [request setURL:requestURL];
    
    NSURLConnection *requestConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self] ;
    if (requestConnection){
        //receivedData=[[NSMutableData data] retain];
        [receivedData setLength:0];
        //[requestConnection release];
    }
}
#pragma mark - NSURL Delegates methods


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (currentProgressFunctionName!=nil){
        mReceivedDataBytes += [data length];
        [currentReceiver performSelectorOnMainThread:NSSelectorFromString(currentProgressFunctionName) withObject:[OSInternetUtilsProgressInfo makeProgress:@"" pContentSize:[[NSNumber alloc] initWithFloat:mFileTotalSize] pContentLoaded:[[NSNumber alloc] initWithFloat:mReceivedDataBytes]] waitUntilDone:NO];
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
    [currentReceiver performSelectorOnMainThread:functionSelector withObject:[[NSData alloc] initWithData:receivedData] waitUntilDone:NO];
    // release the connection, and the data object
    [connection release];
}

-(void)dealloc{
    [receivedData release];
    [super dealloc];
}


@end
