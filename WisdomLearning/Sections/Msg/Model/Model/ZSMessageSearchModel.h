//
//  ZSMessageSearchModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSMessageFriendListModel.h"
#import "ZSMessageGroupModel.h"

@interface ZSMessageSearchModel : NSObject

@property (nonatomic, strong) NSArray<ZSMessageFriendListModel*>* FRIEND_LIST;
@property (nonatomic, strong) NSArray<ZSMessageGroupModel*>* GROUP_LIST;
////好友或群组ID
//@property (nonatomic,strong)NSString * USER_ID;
////好友昵称或群组名称
//@property (nonatomic,strong)NSString * USER_SHORTNAME;
////头像
//@property (nonatomic,strong)NSString * USER_PIC;
////个性签名
//@property (nonatomic,strong)NSString * USER_SIGN;
////类别
//@property (nonatomic,strong)NSString * TYPE;

@end
