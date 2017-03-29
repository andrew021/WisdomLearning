//
//  ZSRequest+LearnCircle.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSLearnCircleModel.h"
#import "InfoModel.h"
@interface ZSRequest (LearnCircle)

#pragma mark ****  学习圈列表接口 ***
-(void)requestLearnCircleListWith:(NSDictionary *)circle_Dic withBlock:(void (^)(ZSLearnCircleModel *model,NSError *error))block;

#pragma mark ****  同学录列表接口 ***
-(void)requestClassMateListWith:(NSDictionary *)circle_Dic withBlock:(void (^)(ZSClassMateModel *model,NSError *error))block;

#pragma mark ****  咨询详细接口 ***
-(void)requestInfoDetailWithDic:(NSDictionary *)dic
                          block:(void (^)(InfoModel *model, NSError* error))block;

#pragma mark ****  搜索关键字接口 ***
-(void)requestSearchKeyWithDic:(NSDictionary *)dic
                          block:(void (^)(ZSSearchKeyModel *model, NSError* error))block;

#pragma mark **** 添加搜索关键字接口 ***
-(void)requestAddSearchKey:(NSDictionary*)dic
                     block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 我的学分接口 ***
-(void)requestMyCreditWithDic:(NSDictionary*)dic
                     block:(void (^)(ZSMyCreditModel* model, NSError* error))block;

#pragma mark **** 测验结果接口 ***
-(void)requestWorkTestResultWithDic:(NSDictionary*)dic
                        block:(void (^)(ZSWorkTestResultModel* model, NSError* error))block;

#pragma mark **** 测验接口 ***
-(void)requestWorkTestWithDic:(NSDictionary*)dic
                              block:(void (^)(ZSWorkTestPaperModel* model, NSError* error))block;

#pragma mark **** 发布资讯 ***
-(void)requestAddInfoWithDic:(NSDictionary*)dic
                         block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 我的学币接口 ***
-(void)requestMyCurrencyWithDic:(NSDictionary*)dic
                        block:(void (^)(ZSMyCreditModel* model, NSError* error))block;

#pragma mark **** 新鲜事接口 ***
-(void)requestNewThingWithDic:(NSDictionary*)dic
                          block:(void (^)(ZSNewThingrModel* model, NSError* error))block;


#pragma mark **** 系统配置 ***
-(void)requesSystemSetWithDict:(NSDictionary *)dict Block:(void (^)(ZSSystemSetModel* model, NSError* error))block;

#pragma mark **** 系统消息 ***
-(void)requesSystemMsgWithDict:(NSDictionary *)dict Block:(void (^)(ZSSystemMsgModel* model, NSError* error))block;

@end
