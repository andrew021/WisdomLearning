//
//  ZSRequest+Pay.h
//  WisdomLearning
//
//  Created by Shane on 16/11/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSPayOrder.h"

@interface ZSRequest (Pay)


#pragma mark  --请求生成的支付宝订单信息--
-(void)requestAliPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel* model, NSError* error))block;

#pragma mark  --请求生成的微信支付订单信息--
-(void)requestWxPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel* model, NSError* error))block;

#pragma mark  --请求生成的银联支付订单信息--
-(void)requestUnionPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel* model, NSError* error))block;

#pragma mark  --提交支付订单信息给后台--
-(void)postServerWithPayDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

@end
