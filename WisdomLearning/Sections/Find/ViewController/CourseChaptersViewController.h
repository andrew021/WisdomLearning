//
//  CourseChaptersViewController.h
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CourseChaptersViewControllerDelegate <NSObject>

-(void)clickTheIndex:(NSInteger)index;

@end

@class CourseStudyViewController ;

@interface CourseChaptersViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<ZSChaptersInfo *> *chapters;

@property (nonatomic, copy) NSString *choseChapterId;

@property (nonatomic, weak) id<CourseChaptersViewControllerDelegate> theDelegate;

@property (nonatomic, assign) BOOL bBounce;

@property (nonatomic, strong) CourseStudyViewController *courseStduyCotroller;

@property (nonatomic, strong) UIScrollView *theHostScrollView;

@property (nonatomic, strong) UITableView *theTableView;



@end
