//
//  MineObjectModel.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MineObjectModel.h"

@implementation MineObjectModel

@end

//我的租户子站列表(我的应用)
@implementation MyTenantListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [MyTenantList class]};
}

@end

//我获得的证书列表
@implementation MyCertificateListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [MyCertificateList class]};
}

@end

@implementation MyOrderformListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [MyOrderformList class]};
}

@end