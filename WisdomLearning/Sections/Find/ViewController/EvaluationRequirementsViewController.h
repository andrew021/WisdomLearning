//
//  EvaluationRequirementsViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
// 远程培训班之考评要求

#import <UIKit/UIKit.h>

@interface EvaluationRequirementsViewController : UIViewController

@property (nonatomic, copy) NSString * clazzId;
@property(nonatomic, strong)UITableView *tableView;

@end
