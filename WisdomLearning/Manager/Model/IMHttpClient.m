//
//  IMHttpClient.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IMHttpClient.h"
#import "IMRequestModel.h"
#import "AFNetworkActivityIndicatorManager.h"


@interface IMHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation IMHttpClient
+(IMHttpClient *) sharedInstance
{
    static IMHttpClient *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}

- (id)init
{
    if (self = [super init]) {
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = kZSRequestTimeOut;
        
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        // _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript", nil];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    
    return self;
}


//开启新任务
- (NSURLSessionDataTask*)excuteRequestWithModel:(IMRequestModel*)model
                                          block:(void (^)(NSURLResponse* response, id responseObject, NSError* error))block
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    NSString* requestStr = [NSString stringWithFormat:@"%@%@", model.host, model.requestName];
    
    NSDictionary<NSString*, NSString*>* headerFieldValueDictionary = model.requestHeader;
    if (headerFieldValueDictionary != nil) {
        for (NSString* httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString* value = headerFieldValueDictionary[httpHeaderField];
            [_manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    
    NSError* serializationError = nil;
    NSURLRequest* urlRequest = nil;
    
    urlRequest = [_manager.requestSerializer requestWithMethod:model.requestType URLString:requestStr parameters:[[model getZSParams] copy] error:&serializationError];
    
    NSURLSessionDataTask* task = [_manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        if (block) {
            block(response, responseObject, error);
        }
    }];
    
    [task resume];
    
    return task;
}


@end
