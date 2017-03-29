//
//  ZSError.h
//  ElevatorUncle
//
//  Created by Shane on 16/7/6.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

// 错误码
typedef enum : NSUInteger {
    ZSErrorCodeCrash		= -10000,
    ZSErrorCodeDisConnect,
    ZSErrorCodeUnknow,
} ZSErrorCode;

@interface ZSError : NSObject

+ (NSError *)errorCode:(ZSErrorCode)code userInfo:(NSDictionary *)dic;
+ (NSString *)transformCodeToStringInfo:(ZSErrorCode)code;

@end
