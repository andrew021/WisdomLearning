//
//  ZSMessageGroupMemberModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSMessageGroupMemberModel : NSObject
//用户Id
@property (nonatomic,strong)NSString * USER_ID;
//昵称
@property (nonatomic,strong)NSString * USER_SHORTNAME;
//头像
@property (nonatomic,strong)NSString * USER_PIC;
//个性签名
@property (nonatomic,strong)NSString * USER_SIGN;
//成员类别 [群主会放在第一个 1-群主 0-成员]
@property (nonatomic,strong)NSString * GM_TYPE;
//群ID
@property (nonatomic,strong)NSString * GP_ID;
//用户在群中的ID
@property (nonatomic,strong)NSString * GM_ID;
//群名片
@property (nonatomic,strong)NSString * GM_CARD;
@end
