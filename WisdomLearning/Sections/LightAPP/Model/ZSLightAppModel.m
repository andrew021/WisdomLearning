//
//  ZSLightAppModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSLightAppModel.h"

@implementation ZSLightAppModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [LightAppModel class] };
}

@end
