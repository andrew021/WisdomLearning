//
//  ZSHttpClient.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSHttpClient.h"
#import "ZSRequestModel.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NSObject+YYModel.h"
#import "NSString+YYAdd.h"
#import "ZSError.h"

#import "YYKit.h"

#define kZSUploadAudioUrl (@"")
#define kZSUploadVideoUrl (@"")

#define kBoundary      @"----WebKitFormBoundaryVnD2S3sOElp1cDdI"
#define KNewLine [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]

@interface ZSHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation ZSHttpClient

+(ZSHttpClient *) sharedInstance
{
    static ZSHttpClient *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}

- (id) init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.timeoutIntervalForRequest = kZSRequestTimeOut;
        _manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:config];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        _manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript", nil];
        _manager.requestSerializer =[AFJSONRequestSerializer serializer];
        _manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    return self;
}

//开启新任务
- (NSURLSessionDataTask*)excuteRequestWithModel:(ZSRequestModel*)model
                                          block:(void (^)(NSURLResponse* response, id responseObject, NSError* error))block
{
//    if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
//        if (block) {
//            block(nil, nil, [ZSError errorCode:ZSErrorCodeDisConnect userInfo:nil]);
//        }
//        return nil;
//    }
    if (![[YYReachability reachability] isReachable]) {
        if (block) {
            block(nil, nil, [ZSError errorCode:ZSErrorCodeDisConnect userInfo:nil]);
        }
        return nil;
    }
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    NSString *requestStr = [NSString stringWithFormat:@"%@%@",model.host,model.requestName];
    NSDictionary<NSString *,NSString *> *headerFiledValueDictionary = model.requestHeader;
    if (headerFiledValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFiledValueDictionary.allKeys) {
            NSString *value =headerFiledValueDictionary[httpHeaderField];
            [_manager.requestSerializer setValue:value forKey:httpHeaderField];
        }
    }
    
    NSError* serializationError = nil;
    NSURLRequest* urlRequest = nil;
    urlRequest = [_manager.requestSerializer requestWithMethod:@"GET" URLString:requestStr parameters:[[model getZSParams] copy] error:&serializationError];
    
    NSURLSessionDataTask* task = [_manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse* _Nonnull response, id _Nullable responseObject, NSError* _Nullable error) {
        if (block) {
            block(response, responseObject, error);
        }
    }];
    [task resume];
    return task;
}


@end
