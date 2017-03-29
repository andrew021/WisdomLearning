//
//  IMHttpClient.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class IMRequestModel;
@class ZSModel;
@class ZSUploadRespModel;

@interface IMHttpClient : NSObject

+(IMHttpClient *) sharedInstance;

/**
 * 开启新任务
 */
- (NSURLSessionDataTask*)excuteRequestWithModel:(IMRequestModel*)model
                                          block:(void (^)(NSURLResponse* response, id responseObject, NSError* error))block;

@end
