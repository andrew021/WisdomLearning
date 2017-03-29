//
//  ZSLearnCircleModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"
#import "ZSLearnCircleListModel.h"

//学习圈列表
@interface ZSLearnCircleModel : ZSModel

@property (nonatomic, strong) NSArray<ZSLearnCircleListModel*>* pageData;
@property (nonatomic, assign) NSInteger curPage;//当前页数
@property (nonatomic, assign) NSInteger totalPages;//总页数

@end

//同学录列表
@interface ZSClassMateModel : ZSModel

@property (nonatomic, strong) NSArray<CLassMateListModel*>* pageData;
@property (nonatomic, assign) NSInteger curPage;//当前页数
@property (nonatomic, assign) NSInteger totalPages;//总页数

@end

//搜索关键字
@interface ZSSearchKeyModel : ZSModel

@property (nonatomic, strong) SearchKeyWordModel* data;

@end

//测验结果
@interface ZSWorkTestResultModel : ZSModel

@property (nonatomic, strong) WorkTestResultModel * data;

@end

//测验试卷
@interface ZSWorkTestPaperModel : ZSModel

@property (nonatomic, strong) WorkTestQuestionModel * data;

@end

//新鲜事
@interface ZSNewThingrModel : ZSModel

@property (nonatomic, strong) NSArray<NewThingModel*> * pageData;
@property (nonatomic, assign) NSInteger curPage;//当前页数
@property (nonatomic, assign) NSInteger totalPages;//总页数

@end

//新鲜事
@interface ZSSystemSetModel : ZSModel

@property (nonatomic, strong)NSArray<SystemSetModel*> * data;


@end

//新鲜事
@interface ZSSystemMsgModel : ZSModel

@property (nonatomic, strong)NSArray<SystemMsgModel*> * pageData;
@property (nonatomic, assign) NSInteger curPage;//当前页数
@property (nonatomic, assign) NSInteger totalPages;//总页数

@end

//智能排序
@interface ZSIntelligentOrderModel : ZSModel

@property (nonatomic, strong)NSArray<IntelligentOrderModel*> * data;


@end

//智能筛选
@interface ZSFilterFieldModel : ZSModel

@property (nonatomic, strong)NSArray<FilterFieldModel*> * data;


@end
