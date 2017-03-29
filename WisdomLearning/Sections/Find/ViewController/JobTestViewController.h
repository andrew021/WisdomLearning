//
//  JobTestViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
// 远程培训班之作业测试

#import <UIKit/UIKit.h>
#import "CourseStudyViewController.h"

@interface JobTestViewController : UIViewController

@property (nonatomic, copy) NSString *objectId;//对象ID
@property (nonatomic, copy) NSString *type;//区分是班级的还是项目。班级：class，项目:program
@property(nonatomic, strong)UITableView *tableView;


@property (nonatomic, strong) CourseStudyViewController *courseStduyCotroller;


@end
