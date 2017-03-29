//
//  MineObjectModel.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"
#import "MineObject.h"

@interface MineObjectModel : ZSModel

@end

//我的租户子站列表(我的应用)
@interface MyTenantListModel : ZSModel

@property (nonatomic, strong) NSArray <MyTenantList *> *pageData;
@property (nonatomic, assign) long curPage;//返回数据的页码
@property (nonatomic, assign) long totalPages;//总的分页数

@end

//我获得的证书列表
@interface MyCertificateListModel : ZSModel

@property (nonatomic, strong) NSArray <MyCertificateList *> *pageData;
@property (nonatomic, assign) long totalRecords;//总的符合条件的记录数

@end

//我的订单列表
@interface MyOrderformListModel : ZSModel

@property (nonatomic, assign) long curPage;//返回数据的页码
@property (nonatomic, assign) long totalPages;//总的分页数
@property (nonatomic, strong) NSArray <MyOrderformList *> *pageData;

@end