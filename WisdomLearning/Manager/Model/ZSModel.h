//
//  ZSModel.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据结构的父类
 *  子类数据结构需自定义datas和其他所需字段
 */

#define kSuccessCode @"1"

@interface ZSModel : NSObject

@property (nonatomic, copy) NSString *success; //错误码
@property (nonatomic, copy) NSString *message; //消息描述

@property (nonatomic, assign) BOOL isSuccess; // 状态值

@end
