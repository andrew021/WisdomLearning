//
//  ZSMessageSearchModel.m
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ZSMessageSearchModel.h"

@implementation ZSMessageSearchModel
+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"FRIEND_LIST" : [ZSMessageFriendListModel class],@"GROUP_LIST" : [ZSMessageGroupModel class]};
}
@end
