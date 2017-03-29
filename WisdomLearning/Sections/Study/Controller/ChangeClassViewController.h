//
//  ChangeClassViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeClassViewController : UIViewController

@property (nonatomic, copy) NSString *userId;//用户ID，不传就是浏览的专题的班级
@property (nonatomic, copy) NSString *programId;//userId
@property (nonatomic, assign) CGFloat offset;

@end
