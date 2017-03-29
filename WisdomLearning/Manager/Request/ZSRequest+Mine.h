//
//  ZSRequest+Mine.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "MineObjectModel.h"
#import "StudyModel.h"

@interface ZSRequest (Mine)

/**
 *  学习系统-我的租户子站列表(我的应用)
 *
 *  @param block      返回Block
 */
-(void)requestMyTenantListWithDic:(NSDictionary *)dic block:(void (^)(MyTenantListModel *model, NSError *error))block;

/**
 *  学习系统-我获得的证书列表
 *
 *  @param block      返回Block
 */
-(void)requestMyCertificateListWithDic:(NSDictionary *)dic block:(void (^)(MyCertificateListModel *model, NSError *error))block;

/**
 *  学习系统-我的资讯列表
 *
 *  @param block      返回Block
 */
-(void)requestMyNewsListWithdic:(NSDictionary *)dic block:(void (^)(DiscoveryInformationModel *model, NSError *error))block;

/**
 *  学习系统-我的订单列表
 *
 *  @param block      返回Block
 */
-(void)requestMyOrderformListWithdic:(NSDictionary *)dic block:(void (^)(MyOrderformListModel *model, NSError *error))block;

@end
