//
//  ZSShare.m
//  WisdomLearning
//
//  Created by Shane on 16/10/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSShare.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@implementation ZSShare

+(void)showShare:(id)sender
{
    //更换分享菜单栏风格
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    //1、创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    NSArray* imageArray = @[[UIImage imageNamed:@"login_logo"
                             ]];
    if (imageArray)
    {
//        [shareParams SSDKSetupShareParamsByText:@""
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://www.mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeImage];
        
        //微信朋友圈
        [shareParams SSDKSetupWeChatParamsByText:@"好视频" title:@"第1课  图表任你差遣" url:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/HbTMxpilOKa7NyPRqdN3FDvIrYgTLhBMB5Hj_-dHcy5IPDOZXFD1HW2WgQUYTpDcBSnUL2xD5rDf2BujUbiMg6_rJl50vg"] thumbImage:[UIImage imageNamed:@"login_logo"] image:[UIImage imageNamed:@"login_logo"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeVideo forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        //微信好友
        [shareParams SSDKSetupWeChatParamsByText:nil title:@"第1课  图表任你差遣" url:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/HbTMxpilOKa7NyPRqdN3FDvIrYgTLhBMB5Hj_-dHcy5IPDOZXFD1HW2WgQUYTpDcBSnUL2xD5rDf2BujUbiMg6_rJl50vg"] thumbImage:[UIImage imageNamed:@"login_logo"] image:[UIImage imageNamed:@"login_logo"] musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeVideo forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        //QQ好友
        [shareParams SSDKSetupQQParamsByText:@"好视频" title:@"第1课  图表任你差遣" url:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/HbTMxpilOKa7NyPRqdN3FDvIrYgTLhBMB5Hj_-dHcy5IPDOZXFD1HW2WgQUYTpDcBSnUL2xD5rDf2BujUbiMg6_rJl50vg"] thumbImage:[UIImage imageNamed:@"login_logo"] image:[UIImage imageNamed:@"login_logo"] type:SSDKContentTypeVideo forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        
        //QQ空间
        [shareParams SSDKSetupQQParamsByText:@"好视频" title:@"第1课  图表任你差遣" url:[NSURL URLWithString:@"http://v.jxvdy.com/sendfile/HbTMxpilOKa7NyPRqdN3FDvIrYgTLhBMB5Hj_-dHcy5IPDOZXFD1HW2WgQUYTpDcBSnUL2xD5rDf2BujUbiMg6_rJl50vg"] thumbImage:[UIImage imageNamed:@"login_logo"] image:[UIImage imageNamed:@"login_logo"] type:SSDKContentTypeVideo forPlatformSubType:SSDKPlatformSubTypeQZone];
//        //新浪微博
//        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@",@“好视频”,shareUrl] title:@"第1课  图表任你差遣" image:kLoadNetImage(shareUrlImg) url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    }
    
    //2、分享
    [ShareSDK showShareActionSheet:sender
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state)
                   {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@", error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
//                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                               message:nil
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"确定"
//                                                                     otherButtonTitles:nil];
//                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
               }];
}


+(void)platShareView:(UIView *)view WithShareContent:(NSString *)shareContent WithShareUrlImg:(NSString *)shareUrlImg WithShareUrl:(NSString *)shareUrl WithShareTitle:(NSString *)shareTitle
{
    //更换分享菜单栏风格
    [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple];
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
   
  
    #pragma mark 平台定制分享参数
    UIImage *image = [ThemeInsteadTool imageWithImageName:shareUrlImg];
    
#pragma mark 公共分享参数
  
    
//    //新浪微博
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@ %@ %@",shareContent,shareTitle, shareUrl] title:shareTitle image:image url:[NSURL URLWithString:shareUrl] latitude:0 longitude:0 objectID:nil type:SSDKContentTypeAuto];
    
    
    //QQ空间
    [shareParams SSDKSetupQQParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:image image:image type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQZone];
    
    //QQ好友
    [shareParams SSDKSetupQQParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:image image:image type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    
    //微信好友
    [shareParams SSDKSetupWeChatParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //微信朋友圈
    [shareParams SSDKSetupWeChatParamsByText:nil title:shareTitle url:[NSURL URLWithString:shareUrl] thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
  
    #pragma mark 设置跳过分享编辑页面，直接分享的平台。
    SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                switch (state)
                {
                     case SSDKResponseStateSuccess:
                       {
                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                               [alertView show];
                              break;
                          }
                       case SSDKResponseStateFail:
                       {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil];
                             [alertView show];
                              break;
                           }
                      case SSDKResponseStateCancel:
                      {
                              break;
                        }
                       default:
                       break;
                     }
          }];
     }

@end
