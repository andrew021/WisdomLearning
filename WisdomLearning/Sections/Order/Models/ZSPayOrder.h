//
//  ZSPayOrder.h
//  WisdomLearning
//
//  Created by Shane on 16/11/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSPayOrder;
@class ZSUnifiedOrder;


@interface ZSPayOrderModel : ZSModel

@property(nonatomic, strong) ZSPayOrder *data;

@end

@interface ZSPayOrder : NSObject

@property (nonatomic, copy) NSString *coinFee;
@property (nonatomic, copy) NSString *courseStr;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *onlineFee;
@property (nonatomic, copy) NSString *orderNum;
@property (nonatomic, copy) NSString *orderTime;
@property (nonatomic, copy) NSString *payStatus;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) ZSUnifiedOrder *unifiedorder;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *sign;


@end

@interface ZSUnifiedOrder : NSObject

@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *packageValue;
@property (nonatomic, copy) NSString *partnerid;
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *timestamp;

@end
