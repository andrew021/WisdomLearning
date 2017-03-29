//
//  ZSRequest+Comment.h
//  WisdomLearning
//
//  Created by Shane on 16/11/3.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSReplyListModel.h"

@interface ZSRequest (Comment)


#pragma mark ---评论列表---
-(void)requestCommentListWithData:(NSDictionary *)dict withBlock:(void (^)(ZSReplyListModel *model,NSError *error))block;


#pragma mark ---提交评论---
-(void)toCommentWith:(NSDictionary *)dict withBlock:(void (^)(ZSModel *model,NSError *error))block;


@end
