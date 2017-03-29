//
//  ZSRequestModel.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequestModel.h"
#import "NSString+Utilities.h"

extern NSString *gHost;

@implementation ZSRequestModel

- (instancetype) init
{
    self = [super init];
    if (self) {
      //  NSString * gHost
//        NSString *sss =  [[Config Instance] getSystemSet];
//        NSLog(@"___%@",[[Config Instance] getSystemSet])
//        if (sss != nil && sss.length !=0 && sss != [NSNull class] ){
////           NSString * str = [NSString stringWithFormat:@"%@/",gSystemSet];
////            NSLog(@"___++%@",str);
////            _host = str;
////            _host = @"http://www.witfore.com:8067/api-webapp/";
//        }
        if (gHost && gHost.length != 0) {
            _host = [NSString stringWithFormat:@"%@", gHost];
//            _host = @"http://192.168.1.120:8080/traincoreapi-webapp/"
    
        }
        else{
            NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
            NSDictionary *settingDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][identifier];
            //获取当前bundleId 对应的sysConfig地址
            NSString *sysConfigUrl = settingDict[@"sysConfigUrl"];

            _host = sysConfigUrl;
        }
       
        _userInfoKeyString = [NSString randomString];
        _requestType = kZSRequestTypePost;
        _retryTimes = kZSRequestRetryTimes;
        _timeOutSeconds = kZSRequestTimeOut;
        _requestBody = @{}.mutableCopy;
        _requestParams = @{}.mutableCopy;
        _requestHeader = @{}.mutableCopy;
    }
    return self;
}

- (NSDictionary *)getZSParams
{
//    NSDictionary *para = @{
////                           @"header":[self commonParams],
////                           @"payload":self.requestParams,
//                           @"s":@"d",
//                           @"t":@"d",
//                           };
//    return para;
    NSMutableDictionary *s = [NSMutableDictionary dictionaryWithDictionary:@{@"s":@"d",
                                                                             @"t":@"d"}];
    if (self.requestParams) {
        [s addEntriesFromDictionary:self.requestParams];
    }
    return s;
//  return  self.requestParams;
}

- (NSDictionary*)commonParams
{
    NSMutableDictionary* headerParams = [@{
                                           @"UUID" : @"3952870636",
                                           @"osid" : @"iOS",
                                           @"version" : appVersion(),
                                           @"net_type" : @"wifi"
                                           } mutableCopy];
//    if ([[Config Instance] getUserID]) {
//        [headerParams setObject:[[Config Instance] getUserID] forKey:@"SESSION_TOKEN"];
//    }
//    else {
//    if (gUserID.length>0){
//        [headerParams setObject:gUserID forKey:@"SESSION_TOKEN"];
//    }
//    else{
//        [headerParams setObject:@"3952870636" forKey:@"SESSION_TOKEN"];
//
//    }
    
    return headerParams;

}


@end
