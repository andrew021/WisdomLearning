//
//  ZSPay.h
//  WisdomLearning
//
//  Created by Shane on 16/11/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AliPayManager.h"
#import "UnionPayManager.h"
#import "WXApiManager.h"

typedef void(^paySuccessBlock)();

@interface ZSPay : NSObject


// 0---支付宝   1---微信    2---银联

#pragma mark  --生成订单和支付
-(void)payCourseWithPayType:(NSString *)payType andFromAward:(BOOL)fromAward andDataDicitonary:(NSDictionary *)dict andViewController:(UIViewController *)controller successBlock:(paySuccessBlock)successBlock;


//提交成功支付的订单
-(void)toPostSuccessOrder:(NSString *)orderNum;

+ (instancetype)instance;

@property(nonatomic, copy) paySuccessBlock successBlock;

@end
