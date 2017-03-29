//
//  TopicCourseChooseController.h
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicCourseChooseController : UIViewController

@property (nonatomic, copy) NSString *clazzId;//班级id
@property (nonatomic, copy) NSString *projectId;//项目ID
@property (nonatomic, assign) NSInteger classType;//班级
@property (nonatomic, copy) NSString *courseIcon;
@property (nonatomic, copy) NSString *className;
@end
