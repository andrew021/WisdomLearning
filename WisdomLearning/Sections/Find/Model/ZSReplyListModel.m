//
//  ZSReplyListModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/3.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSReplyListModel.h"

@implementation ZSReplyListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"pageData":[ZSReplyListInfo class] };
}

@end


@implementation ZSReplyInfo

@end


@implementation ZSReplyListInfo

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"replyList":[ZSReplyInfo class] };
}

@end