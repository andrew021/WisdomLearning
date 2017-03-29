//
//  ZSMessageFriendListModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSMessageFriendListModel : NSObject
//用户ID
@property (nonatomic,strong)NSString * USER_ID;
//昵称
@property (nonatomic,strong)NSString * USER_SHORTNAME;
//头像
@property (nonatomic,strong)NSString * USER_PIC;
//个性签名
@property (nonatomic,strong)NSString * USER_SIGN;
@end
