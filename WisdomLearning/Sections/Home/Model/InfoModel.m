//
//  InfoModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "InfoModel.h"

@implementation InfoModel

@end

@implementation ZSMyCreditModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [MyCreditModel class] };
}

@end