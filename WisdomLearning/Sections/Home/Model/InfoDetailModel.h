//
//  InfoDetailModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoDetailModel : NSObject

@property (nonatomic,copy)NSString * title; //标题
@property (nonatomic,copy)NSString * createDate; //发布时间
@property (nonatomic,assign)long viewNum; //浏览量
@property (nonatomic,copy)NSString * subject; //资讯富文本
@property (nonatomic,copy)NSString * comFrom; //出处
@property (nonatomic,copy)NSString * img; //配图
@property (nonatomic,copy)NSString * shareUrl; //分享地址

@end

@interface MyCreditModel : NSObject

@property (nonatomic,copy)NSString * ID; //记录ID
@property (nonatomic,copy)NSString * name; //名称
@property (nonatomic,copy)NSString * createTime; //创建时间
@property (nonatomic,assign)long changeValue; //学分变动数额
@property (nonatomic,assign) NSInteger type;
@end
