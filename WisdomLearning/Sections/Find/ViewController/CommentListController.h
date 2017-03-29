//
//  CommentListController.h
//  WisdomLearning
//
//  Created by Shane on 16/10/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseStudyViewController ;

@interface CommentListController : UIViewController

@property (nonatomic,assign)CGFloat commentViewHeight;
@property (nonatomic,assign)CGFloat tableViewHeight;

@property (nonatomic, assign) BOOL bDirectComment;
@property (nonatomic, assign) CGFloat offset;


@property (nonatomic, copy) NSString *resourceType;  //couse,circle,program
@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, assign) BOOL bBounce;

@property (nonatomic, strong) CourseStudyViewController *courseStduyCotroller;

@end
