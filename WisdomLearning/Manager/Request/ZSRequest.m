//
//  ZSRequest.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSHttpClient.h"
#import "YYKit.h"
#import "ZSModel.h"

@interface ZSRequest ()

@property (nonatomic, strong) NSURLSessionTask *task;

@end

@implementation ZSRequest

-(void)requestWithModel:(ZSRequestModel *)model block:(void (^)(ZSModel *, NSError *))block
{
    _task = [[ZSHttpClient sharedInstance] excuteRequestWithModel:model block:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if (block) {
                block([model.modelClass modelWithJSON:responseObject],nil);
            }
        } else {
            if (block) {
                ZSModel *model = [ZSModel new];
                model.isSuccess = NO;
                model.message =@"无法连接网络";
                block(model,error);
            }
        }
    }];
}

-(void)cancleRequest
{
    [self.task cancel];
}


@end
