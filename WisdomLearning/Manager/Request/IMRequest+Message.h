//
//  IMRequest+Message.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IMRequest.h"
#import "ZSMessageModel.h"
#import "ZSMessageNewFriendModel.h"
@interface IMRequest (Message)
#pragma mark **** 处理好友关系 ***
/**
 *  处理好友关系
 *
 *  @param friend_id 对方id
 *  @param state     状态
 *  @param block     block
 */
-(void)requestDisposeFriend:(NSString *)friend_id
                      state:(NSString *)state
                      block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 新朋友 ***
/**
 *  新朋友列表
 *
 *  @param pageNo   页码
 *  @param pageSize 页长
 *  @param block    block
 */
-(void)requestNewFriendsPageNo:(NSString*)pageNo
                      pageSize:(NSString*)pageSize
                         block:(void (^)(ZSMessageModel* model, NSError* error))block;

#pragma mark **** 好友列表 ***
/**
 *  好友列表
 *
 *  @param pro_id 项目id
 *  @param dm_id  需求id
 *  @param block  block
 */
-(void)requestFriendListPro_id:(NSString*)pro_id
                         dm_id:(NSString*)dm_id
                         block:(void (^)(ZSMessageFriendModel* model, NSError* error))block;

#pragma mark **** 搜索联系人或群组 ***
/**
 *  搜索联系人或群组
 *
 *  @param key_word 关键字
 *  @param block    block
 */
-(void)requestSearchLinkManOrGroupList:(NSString*)key_word
                                 block:(void (^)(ZSMessageSearchListModel * model, NSError* error))block;

#pragma mark **** 删除群成员 ***
/**
 *  删除群成员
 *
 *  @param gm_id 用户群成员ID
 *  @param type  类型 [1-群主删除 0-自己退群];
 *  @param block    block
 */
-(void)requestDeleteGroupMember:(NSString*)gm_id
                           type:(NSString*)type
                          block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 修改群名片 ***
/**
 *  修改群名片
 *
 *  @param gm_id   用户群成员ID
 *  @param gm_card 群名片
 *  @param block      block
 */
-(void)requestEditGroupCard:(NSString*)gm_id
                 group_card:(NSString*)gm_card
                      block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 群成员 ***
/**
 *  群成员
 *
 *  @param group_id 群组id
 *  @param block    block
 */
-(void)requestGroupMember:(NSString*)group_id
                    block:(void (^)(ZSMessageGroupMemberListModel* model, NSError* error))block;

#pragma mark **** 群组列表 ***
-(void)requestGroupListBlock:(void (^)(ZSMessageGroupListModel * model, NSError* error))block;

#pragma mark **** 群设置 ***
/**
 *  群设置
 *
 *  @param group_id 群组id
 *  @param block    block
 */
-(void)requestGroupSet:(NSString*)group_id
                 block:(void (^)(ZSMessageGroupSetModel * model, NSError* error))block;

#pragma mark **** 申请/删除好友或屏蔽某人 ***
/**
 *  申请/删除好友或屏蔽某人
 *
 *  @param user_id 对方Id
 *  @param status  状态 [0-发起好友申请 1-屏蔽 2-解除屏蔽 3-删除好友];
 *  @param block   block
 */
-(void)requestDealFriend:(NSString*)user_id
                  status:(NSString*)status
                   block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 是否屏蔽和是否是好友 ***
/**
 *  是否屏蔽和是否是好友
 *
 *  @param user_id 对方Id
 *  @param block   block
 */
-(void)requestWhetherShielding:(NSString *)user_id
                         gp_id:(NSString *)gp_id
                         block:(void (^)(ZSIsFriendOrShieldModel* model, NSError* error))block;

@end
