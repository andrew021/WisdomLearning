//
//  CourseStudyViewController.h
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardView ;

@interface CourseStudyViewController : UIViewController

@property(nonatomic, copy) NSString *courseId;

@property(nonatomic, copy) NSString *classId;

@property(nonatomic, assign) BOOL isPurchaseSucess;

@property(nonatomic, copy) NSString *courseCoverString;

@property(nonatomic, assign) BOOL bShowCommentView;

@property (nonatomic, strong) KeyboardView *keyboardView;

@end
