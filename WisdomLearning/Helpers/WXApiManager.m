//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    self.delegate = nil;
//    [super dealloc];
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAuthResponse:)]) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_delegate managerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate managerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
//        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
//        WXErrCodeCommon     = -1,   /**< 普通错误类型    */
//        WXErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
//        WXErrCodeSentFail   = -3,   /**< 发送失败    */
//        WXErrCodeAuthDeny   = -4,   /**< 授权失败    */
//        WXErrCodeUnsupport  = -5,   /**< 微信不支持    */
        NSString *strMsg;
        switch (resp.errCode) {
            case WXSuccess:
                if (_fromAward)
                    strMsg = @"打赏成功！";
                else
                    strMsg = @"支付成功！";
                break;
            case WXErrCodeUserCancel:
                if (_fromAward)
                    strMsg = @"打赏取消！";
                else
                    strMsg = @"支付取消！";
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败！";
                break;
            case WXErrCodeUnsupport:
                strMsg = @"微信不支持！";
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败！";
                break;
                
            default:
                if (_fromAward)
                    strMsg = @"打赏失败！";
                else
                    strMsg = @"支付失败！！";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        [alert show];
        if (resp.errCode == WXSuccess) {
            [[ZSPay instance] toPostSuccessOrder:_orderNum];
        }
    }

}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate managerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate managerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate managerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

-(void)payWithOrder:(ZSUnifiedOrder *)order andOrderNum:(NSString *)orderNum andFromAward:(BOOL)fromAward{
    //调起微信支付
    _orderNum = orderNum;
    _fromAward = fromAward;
    PayReq* req = [[PayReq alloc] init];
    req.partnerId = order.partnerid;
    req.prepayId  = order.prepayid;
    req.nonceStr  = order.noncestr;
    req.timeStamp = [order.timestamp intValue];
    req.package   =  order.packageValue;
    req.sign      = order.sign;
    [WXApi sendReq:req];
}

@end
