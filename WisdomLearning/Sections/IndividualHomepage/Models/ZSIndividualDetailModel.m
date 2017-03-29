//
//  ZSIndividalDetailModel.m
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSIndividualDetailModel.h"

@implementation ZSIndividualDetail

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"freshList" : [ZSFreshInfo class],
              @"visterList" : [ZSVistorsInfo class]};
}


@end


@implementation ZSVistorsInfo


@end


@implementation ZSFreshInfo


@end

@implementation ZSIndividualDetailModel;


@end