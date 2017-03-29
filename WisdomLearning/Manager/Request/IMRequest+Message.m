//
//  IMRequest+Message.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IMRequest+Message.h"

@implementation IMRequest (Message)
#pragma mark **** 处理好友关系 ***
-(void)requestDisposeFriend:(NSString *)friend_id
                      state:(NSString *)state
                      block:(void (^)(ZSModel* model, NSError* error))block
{
    //ZSRequestModel* requestModel = [ZSRequestModel new];
     IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/disposeFriend.do";
    if (friend_id) {
        [requestModel.requestParams setObject:friend_id forKey:@"APL_ID"];
    }
    if (state) {
        [requestModel.requestParams setObject:state forKey:@"APL_STATUS"];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
    
}

#pragma mark **** 新朋友 ***
-(void)requestNewFriendsPageNo:(NSString*)pageNo
                      pageSize:(NSString*)pageSize
                         block:(void (^)(ZSMessageModel* model, NSError* error))block;
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/newFriends.do";
    
    if (pageNo) {
        [requestModel.requestParams setObject:pageNo forKey:@"pageNo"];
    }
    if (pageSize) {
        [requestModel.requestParams setObject:pageSize forKey:@"pageSize"];
    }
    
    requestModel.modelClass = [ZSMessageModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageModel class]]) {
                block((ZSMessageModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
}

#pragma mark **** 好友列表 ***
-(void)requestFriendListPro_id:(NSString*)pro_id
                         dm_id:(NSString*)dm_id
                         block:(void (^)(ZSMessageFriendModel* model, NSError* error))block
{
     IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/queryList.do";
    if (pro_id) {
        [requestModel.requestParams setObject:pro_id forKey:@"PRJ_ID"];
    }
    if (dm_id) {
        [requestModel.requestParams setObject:dm_id forKey:@"DM_ID"];
    }
    
    requestModel.modelClass = [ZSMessageFriendModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageFriendModel class]]) {
                block((ZSMessageFriendModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
}

#pragma mark **** 搜索联系人或群组 ***
-(void)requestSearchLinkManOrGroupList:(NSString*)key_word
                                 block:(void (^)(ZSMessageSearchListModel * model, NSError* error))block
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/searchList.do";
    
    if (key_word) {
        [requestModel.requestParams setObject:key_word forKey:@"KEY_WORDS"];
    }
    requestModel.modelClass = [ZSMessageSearchListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageSearchListModel class]]) {
                block((ZSMessageSearchListModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
}

#pragma mark **** 删除群成员 ***
-(void)requestDeleteGroupMember:(NSString*)gm_id
                           type:(NSString*)type
                          block:(void (^)(ZSModel* model, NSError* error))block
{
     IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imGroup/deleteMember.do";
    if (gm_id) {
        [requestModel.requestParams setObject:gm_id forKey:@"GM_ID"];
    }
    if (type) {
        [requestModel.requestParams setObject:type forKey:@"TYPE"];
    }
    
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
    
}

#pragma mark **** 修改群名片 ***
-(void)requestEditGroupCard:(NSString*)gm_id
                 group_card:(NSString*)gm_card
                      block:(void (^)(ZSModel* model, NSError* error))block;
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imGroup/editCard.do";
    if (gm_id) {
        [requestModel.requestParams setObject:gm_id forKey:@"GM_ID"];
    }
    if (gm_card) {
        [requestModel.requestParams setObject:gm_card forKey:@"GM_CARD"];
    }
    
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
    
}

#pragma mark **** 群成员 ***
-(void)requestGroupMember:(NSString*)group_id
                    block:(void (^)(ZSMessageGroupMemberListModel* model, NSError* error))block
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imGroup/members.do";
    
    if (group_id) {
        [requestModel.requestParams setObject:group_id forKey:@"GP_ID"];
    }
    requestModel.modelClass = [ZSMessageGroupMemberListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageGroupMemberListModel class]]) {
                block((ZSMessageGroupMemberListModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
    
}

#pragma mark **** 群组列表 ***
-(void)requestGroupListBlock:(void (^)(ZSMessageGroupListModel * model, NSError* error))block;
{
     IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imGroup/queryList.do";
    
    requestModel.modelClass = [ZSMessageGroupListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageGroupListModel class]]) {
                block((ZSMessageGroupListModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
    
}

#pragma mark **** 群设置 ***
-(void)requestGroupSet:(NSString*)group_id
                 block:(void (^)(ZSMessageGroupSetModel * model, NSError* error))block
{
     IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imGroup/settings.do";
    
    if (group_id) {
        [requestModel.requestParams setObject:group_id forKey:@"GP_ID"];
    }
    requestModel.modelClass = [ZSMessageGroupSetModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSMessageGroupSetModel class]]) {
                block((ZSMessageGroupSetModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
}

#pragma mark **** 申请/删除好友或屏蔽某人 ***
-(void)requestDealFriend:(NSString*)user_id
                  status:(NSString*)status
                   block:(void (^)(ZSModel* model, NSError* error))block
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/applyFriend.do";
    if (user_id) {
        [requestModel.requestParams setObject:user_id forKey:@"USER_ID"];
    }
    if (status) {
        [requestModel.requestParams setObject:status forKey:@"STATUS"];
    }
    
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
    
}

#pragma mark **** 是否屏蔽和是否是好友 ***
-(void)requestWhetherShielding:(NSString *)user_id
                         gp_id:(NSString *)gp_id
                         block:(void (^)(ZSIsFriendOrShieldModel* model, NSError* error))block
{
    IMRequestModel* requestModel = [IMRequestModel new];
    requestModel.requestName = @"im/imFriends/whetherShielding.do";
    
    if (user_id) {
        [requestModel.requestParams setObject:user_id forKey:@"USER_ID"];
    }
    if (gp_id) {
        [requestModel.requestParams setObject:gp_id forKey:@"GP_ID"];
    }
    requestModel.modelClass = [ZSIsFriendOrShieldModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            if ([model isKindOfClass:[ZSIsFriendOrShieldModel class]]) {
                block((ZSIsFriendOrShieldModel*)model, error);
            }
            else {
                block(nil, error);
            }
        }    }];
}

@end
