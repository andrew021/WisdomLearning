//
//  ZSProgramCourseListModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSProgramCourseListModel.h"

@implementation ZSProgramCourseListModel

@end


@implementation ZSProgramCourseInfo

@end

@implementation ZSProgramInfo


+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"mustContentList":[ZSProgramInfo class],
              @"selectContentList":[ZSProgramInfo class]};
}

@end