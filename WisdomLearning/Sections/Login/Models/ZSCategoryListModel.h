//
//  ZSCategoryListModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"


@class ZSCategoryInfo;
@interface ZSCategoryListModel : ZSModel

@property(nonatomic, copy) NSArray <ZSCategoryInfo *>*data;

@end


@interface ZSCategoryInfo : NSObject<NSCoding>

//private Long id;               //分类id
//private String name;           //分类名称
//private int busCount;          //分类下面的项目，课程等业务数据数量
//private long childCount;        //之类数量
//private List<CategoryVO> subs;   //总学习时间（单位秒）

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *busCount;
@property(nonatomic, copy) NSString *childCount;
@property(nonatomic, retain) NSMutableArray<ZSCategoryInfo*>* subs;

@end