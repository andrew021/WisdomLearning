//
//  MineObject.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineObject : NSObject

@end

//我的租户子站列表(我的应用)
@interface MyTenantList : NSObject
@property (nonatomic, copy) NSString *Id;//租户子站ID
@property (nonatomic, copy) NSString *joinTime;//参与租户时间
@property (nonatomic, copy) NSString *logoImg;//租户子站图片
@property (nonatomic, copy) NSString *name;//租户子站名称

@end

//我获得的证书列表
@interface MyCertificateList : NSObject

@property (nonatomic, copy) NSString *certImg;//证书图片url
@property (nonatomic, copy) NSString *certNo;//编号
@property (nonatomic, copy) NSString *certificateId;//证书ID
@property (nonatomic, copy) NSString *certificateName;//证书名称
@property (nonatomic, copy) NSString *gainTime;//获得证书时间
@property (nonatomic, copy) NSString *getCertDesc;//获取描述
@property (nonatomic, copy) NSString *myAvater;//获取人头像
@property (nonatomic, copy) NSString *myName;//获取人姓名

@end

//我的订单列表
@interface MyOrderformList : NSObject

//@property (nonatomic, copy) NSString *Id;//订单ID
//@property (nonatomic, copy) NSString *name;//订单名称
//@property (nonatomic, copy) NSString *productIcon;//订单项目图片
//@property (nonatomic, assign) int status;//订单状态1已完成2未完成3已失效
//@property (nonatomic, copy) NSString *statusString;//订单状态说明间
//@property (nonatomic, copy) NSString *createTime;//创建时间
//@property (nonatomic, copy) NSString *payPath;//支付方式
//@property (nonatomic, assign) double price;//订单价格
//@property (nonatomic, assign) double learnCurrency;//订单学币
//@property (nonatomic, assign) double factMoney;//实际支付金额（现金）

@property (nonatomic, copy) NSString *Id;//订单ID
@property (nonatomic, copy) NSString *orderNo;//订单号
@property (nonatomic, copy) NSString *name;//订单名称
@property (nonatomic, copy) NSString *productIcon;//购买产品图片
@property (nonatomic, assign) double learnCurrency;//订单学币
@property (nonatomic, assign) double factMoney;//实际支付金额（现金）
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, assign) int status;//订单状态  1已完成  2未完成  3已失效
@property (nonatomic, copy) NSString *statusString;//订单状态说明间
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *userId;//订单userId
@property (nonatomic, copy) NSString *clazzId;//订单报名班级，对应报名订单有值
@property (nonatomic, copy) NSString *courseId;//订单购买课程，对应课程订单有值
@property (nonatomic, copy) NSString *payPath;//支付方式(支付宝  微信  银联)
@property (nonatomic, assign) double price;//订单价格
@property (nonatomic, copy) NSString *bussType;//订单业务类型 值：course 课程，put充值，sign 报名




@end