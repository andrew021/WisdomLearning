//
//  SystemMacro.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#ifndef SystemMacro_h
#define SystemMacro_h

//主色调

//辅色1（橙色）
#define kMainOrange [UIColor colorFromHexString:@"ff7800"]
//辅色2（绿色）
#define kMainGreen [UIColor colorFromHexString:@"05c6b1"]
//深一点绿,先中按钮用
#define kMainDarkGreen [UIColor colorFromHexString:@"07b3a0"]
//文字颜色（大黑）
#define kTextBlack [UIColor colorFromHexString:@"000000"]
//副标题颜色（浅灰）
#define kTextLightGray [UIColor colorFromHexString:@"999999"]
//APP界面总背景色
#define kAppGray [UIColor colorFromHexString:@"ECECEC"]
//APP界面背景色
#define kAppBackWhite [UIColor colorFromHexString:@"FFFFFF"]
//线条色1（浓）
#define kLineStrong [UIColor colorFromHexString:@"d8d8d8"]
//线条色2（浅）
#define kLineLight [UIColor colorFromHexString:@"d8d8d8"]
//按钮选中
#define kButtonHightGray [UIColor colorFromHexString:@"f8f8f8"]
//
#define kButtonBorderGray [UIColor colorFromHexString:@"cfcfcf"]
//浅蓝色
#define kButtonLightblue [UIColor colorFromHexString:@"2989ff"]
//退出登录红色
#define KLogoutButtonRed [UIColor colorFromHexString:@"ff0000"]
//色调

#define kMainThemeColor [Tool getMainColor]

//主色调
#define KMainBlue [UIColor colorFromHexString:@"1b91ff"]
//辅色1（灰色）
#define KMainGray [UIColor colorFromHexString:@"666666"]
//线条色
#define KMainLine [UIColor colorFromHexString:@"d8d8d8"]
//辅色2（红色）
#define KMainRed [UIColor colorFromHexString:@"ff0000"]
//辅色3（黑色）
#define KMainBlack [UIColor colorFromHexString:@"000000"]
//辅色4（浅橘色）
#define KMainLightOrange [UIColor colorFromHexString:@"f49328"]
//辅色4（深橘色）
#define KMainOrange [UIColor colorFromHexString:@"ff7800"]
//辅色5 字体颜色
#define KMainTextBlack [UIColor colorFromHexString:@"333333"]
#define KMainTextGray [UIColor colorFromHexString:@"999999"]
//辅色1（灰色）
#define KMainBarGray [UIColor colorFromHexString:@"f7f7f8"]

#define kSureButtonColor [UIColor colorWithHexString:@"1b91ff"]
#define kCancelButtonColor [UIColor colorFromHexString:@"c9cbcd"]

#define kZSUploadUrl (@"http://139.196.29.225:10010/resources/fileupload")
#define kZSResourceUrl (@"http://139.196.29.225:10010/resources/download/")


//占位头像
#define KPlaceHeaderImage [UIImage imageNamed:@"default_icon"]

//默认的占位图
#define kPlaceDefautImage [UIImage imageNamed:@"no_picture"]

static NSInteger kPageNum = 1;
static NSInteger kPageSize = 10;


//登录
#define LOGINSUCCESS @"LoginSuccess"
#define LOGOUT @"LogOut"
#define IMLOGOUT @"IMLogOut"

//学币
#define USERCOINCHANGE  @"UserCoinChange"

//更换个人图片
#define CHANGEPERSONICONSUCESS  @"ChangePersonIconSucess"

//#define kBaseURL @"http://139.196.29.225:10010/resources/download/"

// 用户信息
#define IMuserId @"10"

#define gSystemIM [[Config Instance] getSystemIM]
#define gSystemSet [[Config Instance] getSystemSet]
#define gUserID [[Config Instance] getUserid]
#define gUserLearnCoin  [[Config Instance] getLearnCoin]

#define gUserLoginId [[Config Instance] getLoginId]
#define gUserPic [[Config Instance] getUsericon]
#define gUserJobLevel [[Config Instance] getUserJobLevel]
#define gUserGP_id [[Config Instance] getUserGP_id]
#define gUserSV_id [[Config Instance] getUserSV_id]
#define gUserNickname [[Config Instance] getUserNickname]
#define gUsername [[Config Instance] getUsername]

#define gUserPSW_Str [[Config Instance] getUserPSW_Str]

#define gRescource_url [[Config Instance] getRescource_url]

#define gReporing_rate [[Config Instance] getReporing_rate]

#define gAbout_url [[Config Instance] getAbout_url]

#define gRescource_download_url [[Config Instance] getRescource_download_url]

#endif /* SystemMacro_h */
