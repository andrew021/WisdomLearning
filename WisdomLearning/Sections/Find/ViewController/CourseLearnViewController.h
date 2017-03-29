//
//  CourseLearnViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  远程培训班之课程学习

#import <UIKit/UIKit.h>

@interface CourseLearnViewController : UIViewController

@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *objectId;//对象ID
@property (nonatomic, copy) NSString *type;//班级：class，个人专题：program，学习圈：circle
@property(nonatomic, strong)UITableView *tableView;

@end
