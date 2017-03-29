//
//  ZSMessageModel.h
//  BigMovie
//
//  Created by DiorSama on 16/5/9.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ZSModel.h"
#import "ZSMessageNewFriendModel.h"
#import "ZSMessageFriendListModel.h"
#import "ZSMessageSearchModel.h"
#import "ZSMessageGroupMemberModel.h"
#import "ZSMessageGroupModel.h"
#import "ZSMessageGroupSettingModel.h"
#import "ZSIsFriendModel.h"

@interface ZSMessageModel : ZSModel

#pragma mark **** 新朋友列表 ***
@property (nonatomic, strong) NSArray<ZSMessageNewFriendModel*>* data;

@end

@interface ZSMessageFriendModel : ZSModel

#pragma mark **** 好友列表 ***
@property (nonatomic, strong) NSArray<ZSMessageFriendListModel*>* data;

@end

@interface ZSMessageSearchListModel : ZSModel

#pragma mark **** 搜索好友或群组 ***

@property (nonatomic, strong)  ZSMessageSearchModel *data;


@end

@interface ZSMessageGroupMemberListModel : ZSModel

#pragma mark **** 群成员***
@property (nonatomic, strong) NSArray<ZSMessageGroupMemberModel*>* data;

@end

@interface ZSMessageGroupListModel : ZSModel

#pragma mark **** 群组列表 ***
@property (nonatomic, strong) NSArray<ZSMessageGroupModel*>* data;

@end


@interface ZSMessageGroupSetModel : ZSModel

#pragma mark **** 群组设置 ***

@property (nonatomic, strong)ZSMessageGroupSettingModel * data;

@end

@interface ZSIsFriendOrShieldModel : ZSModel

#pragma mark **** 群组设置 ***

@property (nonatomic, strong)ZSIsFriendModel * data;

@end
