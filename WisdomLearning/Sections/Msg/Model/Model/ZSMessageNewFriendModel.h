//
//  ZSMessageNewFriendModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSMessageNewFriendModel : NSObject
//用户ID
@property (nonatomic,strong)NSString * USER_ID;
//昵称
@property (nonatomic,strong)NSString * USER_SHORTNAME;
//头像
@property (nonatomic,strong)NSString * USER_PIC;
//附加消息
@property (nonatomic,strong)NSString * APL_CONTENT;
//申请类别
@property (nonatomic,strong)NSString * APL_TYPE;
//状态
@property (nonatomic,assign)NSInteger APL_STATUS;
//申请Id
@property (nonatomic,strong)NSString * APL_ID;
@end
