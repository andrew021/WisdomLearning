 //
//  ZSPay.m
//  WisdomLearning
//
//  Created by Shane on 16/11/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSPay.h"
#import "ZSRequest.h"

@implementation ZSPay

+(instancetype)instance {
    static dispatch_once_t onceToken;
    static ZSPay *payInstance;
    dispatch_once(&onceToken, ^{
        payInstance = [[ZSPay alloc] init];
    });
    return payInstance;
}


#pragma mark  --生成订单和支付
-(void)payCourseWithPayType:(NSString *)payType andFromAward:(BOOL)fromAward andDataDicitonary:(NSDictionary *)dict andViewController:(UIViewController *)controller successBlock:(paySuccessBlock)successBlock{
    //     流程  1.从提交订单信息给后台，后台返回经过签名的格式化的订单串
    //           2.向支付的平台发起支付，并获取支付后的信息
    //           3.将支付后的信息再次提交给后台
    ZSRequest *request = [[ZSRequest alloc] init];
    _successBlock = successBlock;
    if ([payType isEqualToString:@"ali"]) {
        [request requestAliPayOrderWithDict:dict block:^(ZSPayOrderModel *model, NSError *error) {
            if (model.isSuccess) {
                if (model.data == nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"生成订单失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    [[AliPayManager sharedManager] payWithSignedString:model.data.sign andOrderNum:model.data.orderNum andFromAward:fromAward];
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:model.message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }else if ([payType isEqualToString:@"wx"]){
        [request requestWxPayOrderWithDict:dict block:^(ZSPayOrderModel *model, NSError *error) {
            if (model.isSuccess) {
                if (model.data == nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"生成订单失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                    [alert show];
                }else{
                    [[WXApiManager sharedManager] payWithOrder:model.data.unifiedorder andOrderNum:model.data.orderNum andFromAward:fromAward];
                }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:model.message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }else if ([payType isEqualToString:@"union"]){
        [request requestUnionPayOrderWithDict:dict block:^(ZSPayOrderModel *model, NSError *error) {
            if (model.isSuccess) {
                if (model.data == nil) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"生成订单失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                        [alert show];
                    }else{
                        [[UnionPayManager sharedManager] payWithSignedString:model.data.sign andOrderNum:model.data.orderNum andFromAward:fromAward andController:controller];
                    }
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:model.message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        
    }
}


-(void)toPostSuccessOrder:(NSString *)orderNum{
    ZSRequest *request = [[ZSRequest alloc] init];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    
    NSString *dateTime = [formatter stringFromDate:date];
    
    NSDictionary *dict = @{@"orderNum":orderNum, @"payTime":dateTime};
    [request postServerWithPayDict:dict block:^(ZSModel *model, NSError *error) {
        if (model.isSuccess) {
            if (self.successBlock) {
                _successBlock();
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:model.message message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

@end
