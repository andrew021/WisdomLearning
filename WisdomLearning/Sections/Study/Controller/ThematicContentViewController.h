//
//  ThematicContentViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  专题内容

#import <UIKit/UIKit.h>

@interface ThematicContentViewController : UIViewController

@property (nonatomic, copy) NSString * userId;//用户ID
@property (nonatomic, copy) NSString * objectId;//对象ID
@property (nonatomic, copy) NSString * classId;
@property (nonatomic, copy)  NSString * objectType;//班级：class，个人专题：program，学习圈：circle

@end
