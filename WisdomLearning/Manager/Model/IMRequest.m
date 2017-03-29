//
//  IMRequest.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IMRequest.h"
#import "YYKit.h"
#import "IMHttpClient.h"
#import "ZSModel.h"


@interface IMRequest ()

@property (nonatomic, strong) NSURLSessionTask* task;

@end
@implementation IMRequest



- (void)requestWithModel:(IMRequestModel*)model
                   block:(void (^)(ZSModel* model, NSError* error))block
{
    _task = [[IMHttpClient sharedInstance] excuteRequestWithModel:model block:^(NSURLResponse* response, id responseObject, NSError* error) {
        if (!error) {
            if (block) {
                block([model.modelClass modelWithJSON:responseObject], nil);
            }
        }
        else {
            if (block) {
                block(nil, error);
            }
        }
    }];
}

- (void)cancleRequest
{
    [self.task cancel];
}

@end
