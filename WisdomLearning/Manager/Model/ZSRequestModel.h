//
//  ZSRequestModel.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kZSHost (@"http://www.witfore.com:8067/api-webapp/app/api/jsstudy/")


#define kZSRequestTimeOut (20)
#define kZSRequestRetryTimes (0)
#define kZSRequestTypePost (@"POST")
#define kZSRequestTypeGet (@"GET")

@interface ZSRequestModel : NSObject

/**
 *  请求的host地址
 */
@property (nonatomic, copy) NSString *host;

/**
 *  标记请求的唯一标识，由model自动生成，业务可以得到此唯一标识，做为cancel的依据
 */
@property (nonatomic, copy) NSString *userInfoKeyString;

/**
 *  只读的url中的host之后"?"之前的参数字符串
 */
@property (nonatomic, copy) NSString *requestName;

@property (nonatomic, strong, readonly) NSMutableDictionary <NSString *, NSString *> *requestHeader;

/**
 *  只读的url中的host之后“？”之后的参数
 */
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString*, NSObject*>* requestParams;

@property (nonatomic, strong) NSMutableDictionary<NSString*, NSString*>* requestBody;

/**
 *  请求方式（“GET”“POST”）（默认为POST）
 */
@property (nonatomic, copy) NSString *requestType;

/**
 *  请求自动连接几次（默认为1）
 */
@property (nonatomic, assign) NSInteger retryTimes;

/**
 *  超时时间(默认30s)
 */
@property (nonatomic, assign) NSInteger timeOutSeconds;

/**
 *  解析的子model的class(不可为空)
 */
@property (nonatomic, assign) Class modelClass;

- (NSMutableDictionary*)getZSParams;


@end
