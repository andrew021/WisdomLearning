//
//  ZSMessageModel.m
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ZSMessageModel.h"
@implementation ZSMessageModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageNewFriendModel class] };
}

@end

@implementation ZSMessageFriendModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageFriendListModel class] };
}

@end

@implementation ZSMessageSearchListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageSearchModel class]};
}

@end

@implementation ZSMessageGroupMemberListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageGroupMemberModel class] };
}

@end

@implementation ZSMessageGroupListModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageGroupModel class] };
}


@end

@implementation ZSMessageGroupSetModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSMessageGroupSettingModel class] };
}


@end

@implementation ZSIsFriendOrShieldModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [ZSIsFriendModel class] };
}


@end



