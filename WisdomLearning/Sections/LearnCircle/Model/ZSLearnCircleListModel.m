//
//  ZSLearnCircleListModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSLearnCircleListModel.h"

@implementation ZSLearnCircleListModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"ID" : @"id",
             };
}

@end

@implementation CLassMateListModel

@end

@implementation SearchKeyArrModel

@end

@implementation SearchKeyWordModel

@end

@implementation WorkTestResultModel

@end

@implementation WorkTestQuestionModel

@end

@implementation NewThingModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",
             };
}

@end

@implementation SystemSetModel

@end


@implementation SystemMsgModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",
             };
}

@end

@implementation IntelligentOrderModel

@end

@implementation FilterFieldModel

@end

