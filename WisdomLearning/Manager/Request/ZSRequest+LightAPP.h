//
//  ZSRequest+LightAPP.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSLightAppModel.h"
@interface ZSRequest (LightAPP)

#pragma mark **** 轻应用全部列表接口 ***
-(void)requestAllLightAppListWithDic:(NSDictionary*)dic
                          block:(void (^)(ZSLightAppModel* model, NSError* error))block;

#pragma mark **** 添加或删除轻应用接口 ***
-(void)requestAddOrReduceLightAppWithDic:(NSDictionary*)dic
                               block:(void (^)(ZSModel* model, NSError* error))block;

#pragma mark **** 我的轻应用全部列表接口 ***
-(void)requestMyLightAppListWithDic:(NSDictionary*)dic
                               block:(void (^)(ZSLightAppModel* model, NSError* error))block;


@end
