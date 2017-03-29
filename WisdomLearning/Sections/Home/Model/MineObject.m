//
//  MineObject.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MineObject.h"

@implementation MineObject

@end

//我的租户子站列表(我的应用)
@implementation MyTenantList
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",
             };
}

@end

//我获得的证书列表
@implementation MyCertificateList


@end

//我的订单列表
@implementation MyOrderformList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",
             };
}

@end
