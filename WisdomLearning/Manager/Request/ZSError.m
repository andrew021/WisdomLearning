//
//  ZSError.m
//  ElevatorUncle
//
//  Created by Shane on 16/7/6.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSError.h"

static NSDictionary *errorDictionary = nil;

@implementation ZSError


+ (void)initialize
{
    if (self == [ZSError class])
    {
        errorDictionary = \
        @{
          /* code        :        errorWithDomain */
          /* ==================================== */
          
          @(ZSErrorCodeCrash)       :        @"Crash",
          @(ZSErrorCodeDisConnect)  :        @"网络连接失败",
          @(ZSErrorCodeUnknow)      :        @"未知错误",
          
          /* ==================================== */
          };
    }
}

+ (NSError *)errorCode:(ZSErrorCode)code userInfo:(NSDictionary *)dic
{
    return [NSError errorWithDomain:errorDictionary[@(code)]
                               code:code
                           userInfo:dic];
}

+ (NSString *)transformCodeToStringInfo:(ZSErrorCode)code
{
    return errorDictionary[@(code)];
}


@end
