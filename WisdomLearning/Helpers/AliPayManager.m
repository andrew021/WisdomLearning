//
//  AliPayManager.m
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AliPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ZSRequest.h"

@implementation AliPayManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AliPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AliPayManager alloc] init];
    });
    return instance;
}

-(void)payWithSignedString:(NSString *)orderString andOrderNum:(NSString *)orderNum andFromAward:(BOOL)fromAward{
    _orderNum = orderNum;
    _fromAward = fromAward;
    
    NSString *appScheme = [Tool getAppScheme];
    
    // NOTE: 调用支付结果开始支付
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        
        int statusCode = [resultDic[@"resultStatus"] intValue];
        
        NSString *strMsg;
        switch (statusCode) {
            case 9000:
                if (fromAward)
                    strMsg = @"打赏成功！";
                else
                    strMsg = @"支付成功！";
                break;
            case 8000:
                strMsg = @"正在处理中！";
                break;
            case 6001:
                if (_fromAward)
                    strMsg = @"打赏取消！";
                else
                    strMsg = @"支付取消！";
                break;
            case 6002:
                strMsg = @"网络连接出错！";
                break;
            case 4000:
                if (_fromAward)
                    strMsg = @"打赏失败！";
                else
                    strMsg = @"支付失败！！";
                break;
            default:
                strMsg = @"其他错误！";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        if (statusCode == 9000) {
            [[ZSPay instance] toPostSuccessOrder:_orderNum];
        }
    }];
}

-(BOOL)handleOpenURL:(NSURL *)url{
    
    /*
     9000 订单支付成功
     8000 正在处理中
     4000 订单支付失败
     6001 用户中途取消
     6002 网络连接出错
     */
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic[@"result"]);
            int statusCode = [resultDic[@"resultStatus"] intValue];
            NSString *strMsg;
            switch (statusCode) {
                case 9000:
                    if (_fromAward)
                        strMsg = @"打赏成功！";
                    else
                        strMsg = @"支付成功！";
                    break;
                case 8000:
                    strMsg = @"正在处理中！";
                    break;
                case 6001:
                    if (_fromAward)
                        strMsg = @"打赏取消！";
                    else
                        strMsg = @"支付取消！";
                    break;
                case 6002:
                    strMsg = @"网络连接出错！";
                    break;
                case 4000:
                    if (_fromAward)
                        strMsg = @"打赏失败！";
                    else
                        strMsg = @"支付失败！！";
                    break;
                default:
                    strMsg = @"其他错误！";
                    break;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
            
            if (statusCode == 9000) {
                [[ZSPay instance]  toPostSuccessOrder:_orderNum];
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;

}

//+ (void)doAlipayPay
//{
//    //重要说明
//    //这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
//    //真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
//    //防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *appID = @"2016110502562482";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAM4j9sHZ+uNzFKRW147R1+oIuY25utFju22j+2KWUelCJ4kpuX6Ejn24Lk1oJcyJ34fp8ZZTJZdOYljgvmIUH/taUGcJeIUM38VAPAuSgQaGsVDEH+IAyRNJIVbdoHSEZ3O2sUAVWNGryF2MQx+uUL7oUVl9CivZdvbkfCGDdZ+rAgMBAAECgYEAg9iS0ggWpPWNJVN6CZoDzGeKLrC1YYm1bnnspnDYsSWj3eH3B4nHDXgI/W94hatFckvaPjiuGWmEE66jdl3C2b5cgEIAIKdp6KEbBAyDv4h6Pc7cra1sqD+7p9X6owKy+vwKWQaTBKNJNAMq7veGZA8uw1dY4+BtcwWSOh1eRJkCQQDmR6+JdC4ryFSt1X9/s/+YPrxXNcD0OHs2HEbix2j9B2fpq3ONZZjFNghZQyvPapirUOWTPSMTfpy55awWlnTPAkEA5SoQpTbWMesYJOLyKoK8zLARAG1wY3ORaKnCxHWZjVxC8ZEWgNQloVikMFl9tCbb3CjGsOjxe/W0eyjwMmRWZQJAYVy7xhT+FHrd+qWDA75Z+cfEn+bVTyy2Q3mPKwD+zcSc1bos4AKtpewjeYIh+s9p/zzz4938f5iPsTV/Hgm9FwJBAIA16p4kce33s8hfWFFEV9DE6J4unGRnsgC2iYtUqBYYejOgktB84JjGeQW768Iww20HOzKbAQ/zRYhqPQhUbqkCQH/3PEkrItOdNT2fSJf3k2c+FViGnhQp2kXEHyCuGLUZM6JVY7vGffBOikI+6zxfGiU7dWX+K5dDOP7DWEdqUa4=";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([appID length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少appId或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order* order = [Order new];
//    
//    // NOTE: app_id设置
//    order.app_id = appID;
//    
//    // NOTE: 支付接口名称
//    order.method = @"alipay.trade.app.pay";
//    
//    // NOTE: 参数编码格式
//    order.charset = @"utf-8";
//    
//    // NOTE: 当前时间点
//    NSDateFormatter* formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    order.timestamp = [formatter stringFromDate:[NSDate date]];
//    
//    // NOTE: 支付版本
//    order.version = @"1.0";
//    
//    // NOTE: sign_type设置
//    order.sign_type = @"RSA";
//    
//    order.notify_url = @"http://www.devashen.com/Notify/Alipay/"; //回调URL
//    
//    // NOTE: 商品数据
//    order.biz_content = [BizContent new];
//    order.biz_content.body = @"我是测试数据";
//    order.biz_content.subject = @"1";
//    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.biz_content.timeout_express = @"30m"; //超时时间设置
//    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
//    
//    //将商品信息拼接成字符串
//    NSString *orderInfo = [order orderInfoEncoded:NO];
//    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
//    NSLog(@"orderSpec = %@",orderInfo);
//    
//    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
//    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderInfo];
//    
//    // NOTE: 如果加签成功，则继续执行支付
//    if (signedString != nil) {
//        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = @"alisdkdemo";
//        
//        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
//        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
//                                 orderInfoEncoded, signedString];
//        
//        // NOTE: 调用支付结果开始支付
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }
//}
//
//+ (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}


@end
