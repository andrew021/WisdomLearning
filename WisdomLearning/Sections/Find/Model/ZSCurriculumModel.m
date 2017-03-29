//
//  ZSCurriculumModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSCurriculumModel.h"

@implementation ZSCurriculumModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"pageData":[ZSCurriculumInfo class] };
}

@end

@implementation ZSCurriculumInfo

@end
