//
//  ZSRequest+Comment.m
//  WisdomLearning
//
//  Created by Shane on 16/11/3.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Comment.h"

@implementation ZSRequest (Comment)


#pragma mark ---评论列表---
-(void)requestCommentListWithData:(NSDictionary *)dict withBlock:(void (^)(ZSReplyListModel *, NSError *))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"commentList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSReplyListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSReplyListModel *)model, error);
        }
    }];

}


#pragma mark ---提交评论---
-(void)toCommentWith:(NSDictionary *)dict withBlock:(void (^)(ZSModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"saveComment.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSModel *)model, error);
        }
    }];

}

@end
