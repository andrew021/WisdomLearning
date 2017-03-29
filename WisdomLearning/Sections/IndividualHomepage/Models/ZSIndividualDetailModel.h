//
//  ZSIndividalDetailModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"

@class ZSFreshInfo;
@class ZSVistorsInfo;
@class ZSIndividualDetail;


@interface ZSIndividualDetailModel : ZSModel

@property(nonatomic, strong) ZSIndividualDetail *data;

@end

@interface ZSIndividualDetail : NSObject
//PersonHomeDataVO

@property (nonatomic, copy) NSString *  friendNum;// 好友数量
@property (nonatomic, copy) NSString *  userId;// 用户id
@property (nonatomic, copy) NSString *  userNick;// 用户昵称
@property (nonatomic, copy) NSString *  userAvater;// 用户头像
@property (nonatomic, copy) NSString *  homeImage;  //配图
@property (nonatomic, copy) NSString * signDesc;
@property (nonatomic, copy) NSArray<ZSFreshInfo *> *freshList;
@property (nonatomic, copy) NSArray<ZSVistorsInfo *> *visterList;

@end


@interface ZSFreshInfo : NSObject
//FreshVO

@property (nonatomic, copy) NSString * id;//新鲜事id
@property (nonatomic, copy) NSString * userId;//新鲜事来自的用户id
@property (nonatomic, copy) NSString * userName;//新鲜事用户昵称
@property (nonatomic, copy) NSString * userIcon;// 用户头像
@property (nonatomic, copy) NSString * content; // 新鲜事内容
@property (nonatomic, copy) NSString * createTime;//新鲜事创建时间
@property (nonatomic, copy) NSString * imgStr;//新鲜事配图，多个之间用逗号分隔

@end



@interface ZSVistorsInfo : NSObject
// UserVO

@property (nonatomic, copy) NSString *  id; //id
@property (nonatomic, copy) NSString *  name;// 名称
@property (nonatomic, copy) NSString * avater;// 头像

@end
