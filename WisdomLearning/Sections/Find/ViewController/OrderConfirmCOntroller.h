//
//  OrderConfirmCOntroller.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSUnifiedOrder ;
@class StudyCourseController ;
@class CourseStudyViewController;

@interface OrderConfirmCOntroller : UIViewController

@property (nonatomic, assign) BOOL isFromSign;   //是否来自专题报名页面

@property (nonatomic, copy) NSString *courseIcon;  //课程icon
@property (nonatomic, copy) NSString *courseName;  //课程name
@property (nonatomic, assign) double coursePrice;  //课程价格
@property (nonatomic, copy) NSString *clazzId;  //班级id
@property (nonatomic, assign) NSInteger clazzType;  //班级id
@property (nonatomic, copy) NSString *courseId;  //课程id
@property (nonatomic, copy) NSString *orderDesc;


@property (nonatomic, strong) CourseStudyViewController *preVc;


@end
