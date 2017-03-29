//
//  MySpecialViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  我的专题

#import <UIKit/UIKit.h>
#import "SpecialBaseViewController.h"

typedef NS_ENUM(NSInteger, SpecialStateType) {
    SpecialStateTypeToDo = 1,//1进行中
    SpecialStateTypeNotDo,//2未开始
    SpecialStateTypeDone,//3已结束
};

@interface MySpecialViewController : UIViewController

@property (nonatomic, assign) SpecialStateType type;


+ (instancetype)initWithType:(SpecialStateType)type;

@end
