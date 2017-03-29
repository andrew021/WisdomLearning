//
//  ZSProgramCourseListModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"

@class ZSProgramInfo ;

@interface ZSProgramCourseListModel : ZSModel

@property(nonatomic, strong) ZSProgramInfo *data;

@end


@interface ZSProgramCourseInfo : NSObject

//id	内容id
//name	内容名称
//contentType	内容类型，course,fang,other,是course的跳转到课程学习界面
//contentOrder	内容序号
//score	学分

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *contentType;
@property(nonatomic, copy) NSString *contentOrder;
@property(nonatomic, copy) NSString *score;

@end

@interface ZSProgramInfo : NSObject

//programId	专题ID
//programName	专题名称
//programPrice	专题价格
//programPriceDesc	专题价格显示字段，带单位，价格大于0就显示
//orignalPrice	专题原价(如果原价等于价格APP上只显示一个价格不显示打折价格)

@property(nonatomic, copy) NSString *programId;
@property(nonatomic, copy) NSString *programName;
@property(nonatomic, copy) NSString *programPrice;
@property(nonatomic, copy) NSString *programPriceDesc;
@property(nonatomic, copy) NSString *orignalPrice;
@property(nonatomic, copy) NSArray<ZSProgramInfo *> *mustContentList;
@property(nonatomic, copy) NSArray<ZSProgramInfo *> *selectContentList;

@end
