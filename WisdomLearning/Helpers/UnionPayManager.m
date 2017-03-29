//
//  UnionPayManager.m
//  WisdomLearning
//
//  Created by Shane on 16/11/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "UnionPayManager.h"
#import "UPPaymentControl.h"

@implementation UnionPayManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static UnionPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[UnionPayManager alloc] init];
    });
    return instance;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        NSString *strMsg;
        //结果code为成功时，先校验签名，校验成功后做后续处理
        if([code isEqualToString:@"success"]) {
            if (_fromAward) {
                strMsg = @"打赏成功！";
            }else{
                strMsg = @"支付成功！";
            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
            [[ZSPay instance]  toPostSuccessOrder:_orderNum];
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            if (_fromAward) {
                strMsg = @"打赏失败！";
            }else{
                strMsg = @"支付失败！";
            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            if (_fromAward) {
                strMsg = @"打赏取消！";
            }else{
                strMsg = @"支付取消！";
            }
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"支付已取消！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    return YES;
}

-(BOOL) verify:(NSString *) resultStr {
    
    //验签证书同后台验签证书
    //此处的verify，商户需送去商户后台做验签
    return NO;
}

-(void)payWithSignedString:(NSString *)orderString andOrderNum:(NSString *)orderNum  andFromAward:(BOOL)fromAward andController:(UIViewController *)controller{
    _fromAward = fromAward;
    _orderNum = orderNum;
     [[UPPaymentControl defaultControl] startPay:orderString fromScheme:[Tool getAppScheme] mode:@"00" viewController:controller];
}

@end
