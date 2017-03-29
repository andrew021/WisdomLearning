//
//  ZSRequest+Categories.h
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSCategoryListModel.h"
#import "ZSLearnCircleModel.h"

@interface ZSRequest (Categories)

- (void)requestCategoriesListNumberWithBlock:(void (^)(ZSCategoryListModel *model, NSError *error))block;

/**
 *  学习系统-资讯分类
 *
 *  @param block        返回Block
 */
-(void)requestNewsCategoryBlock:(void (^)(ZSCategoryListModel *model, NSError* error))block;

/**
 *  智能排序
 *
 *  @param block 返回Block
 */
-(void)requestIntelligentOrderWithType:(NSString*)type WithBlock:(void (^)(ZSIntelligentOrderModel *model, NSError* error))block;

/**
 *  智能筛选
 *
 *  @param type  type
 *  @param block 返回Block
 */
-(void)requestFilterFieldWithType:(NSString*)type WithBlock:(void (^)(ZSFilterFieldModel *model, NSError* error))block;

@end
