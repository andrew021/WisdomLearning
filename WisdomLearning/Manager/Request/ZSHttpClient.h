//
//  ZSHttpClient.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class ZSRequestModel;
@class ZSModel;
@class ZSUploadRespModel;

@interface ZSHttpClient : NSObject

+(ZSHttpClient *) sharedInstance;

/**
 * 开启新任务
 */
- (NSURLSessionDataTask*)excuteRequestWithModel:(ZSRequestModel*)model
                                          block:(void (^)(NSURLResponse* response, id responseObject, NSError* error))block;

@end
