//
//  ZSLearnCircleModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSLearnCircleModel.h"

@implementation ZSLearnCircleModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [ZSLearnCircleListModel class] };
}

@end


@implementation ZSClassMateModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [CLassMateListModel class] };
}

@end

@implementation ZSSearchKeyModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [SearchKeyWordModel class] };
}

@end

@implementation ZSWorkTestResultModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [WorkTestResultModel class] };
}

@end

@implementation ZSWorkTestPaperModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [WorkTestQuestionModel class] };
}

@end

@implementation ZSNewThingrModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [NewThingModel class] };
}

@end

@implementation ZSSystemSetModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [SystemSetModel class] };
}

@end

@implementation ZSSystemMsgModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [SystemMsgModel class] };
}

@end

@implementation ZSIntelligentOrderModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [IntelligentOrderModel class] };
}

@end

@implementation ZSFilterFieldModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [FilterFieldModel class] };
}

@end