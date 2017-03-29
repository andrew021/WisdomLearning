//
//  IMRequestModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IMRequestModel.h"
#import "NSString+Utilities.h"

extern NSString *gIMHost;

@implementation IMRequestModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        NSString *sss =  [[Config Instance] getSystemIM];
//        if (sss != nil && sss.length !=0 && sss != [NSNull class] ){
//            _host = sss;
//        }
        if (gIMHost && gIMHost.length != 0) {
            _host = [NSString stringWithFormat:@"%@", gIMHost];;
        }
        else{
        _host = kIMHost;
            
        }
        _userInfoKeyString = [NSString randomString];
        _requestType = kIMRequestTypePost;
        _retryTimes = kIMRequestRetryTimes;
        _timeOutSeconds = kIMRequestTimeOut;
        _requestBody = @{}.mutableCopy;
        _requestParams = @{}.mutableCopy;
        _requestHeader = @{}.mutableCopy;
    }
    return self;
}

- (NSDictionary*)commonParams
{
    NSMutableDictionary* headerParams = [@{
                                           @"UUID" : @"6319907486",
                                           @"osid" : @"iOS",
                                           @"version" : appVersion(),
                                           @"net_type" : @"wifi"
                                           } mutableCopy];
    if ([[Config Instance] getUserid]) {
        [headerParams setObject:gUserID forKey:@"SESSION_TOKEN"];
    }
    else {
        [headerParams setObject:@"6319907486" forKey:@"SESSION_TOKEN"];
    }
    
    return headerParams;
}

- (NSDictionary*)getZSParams
{
    NSDictionary* para = @{
                           @"header" : [self commonParams],
                           @"payload" : self.requestParams
                           };
    return para;
}


@end
