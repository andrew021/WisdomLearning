//
//  CourseWebViewController.h
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseStudyViewController;

@interface CourseWebViewController : UIViewController

@property(nonatomic,copy)NSString *urlStr;

@property(nonatomic,copy)NSString *htmlStr;

@property(nonatomic, assign) BOOL bBounce;

@property(nonatomic, copy) NSString *courseId;

@property(nonatomic, copy) NSString *classId;

@property(nonatomic, copy) NSString *chapterId;

@property(nonatomic, assign) BOOL learnFlag;

@property(nonatomic, assign) BOOL isFromCourseHtml;

@property (nonatomic, strong) CourseStudyViewController *courseStduyCotroller;

@end
