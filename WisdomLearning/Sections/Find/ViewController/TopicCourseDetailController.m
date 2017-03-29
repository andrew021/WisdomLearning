//
//  TopicCourseDetailController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TopicCourseDetailController.h"
#import "TopicCourseHeaderView.h"
#import "HMSegmentedControl.h"
#import "CourseIntroController.h"
#import "SignupListViewController.h"
#import "HomeworkDemandController.h"


@interface TopicCourseDetailController()<UIScrollViewDelegate>{
    
}

@property (nonatomic, strong) TopicCourseHeaderView *headerView;
@property (nonatomic, strong) CourseIntroController *courseController;
@property (nonatomic, strong) HomeworkDemandController *homeworkController;
@property (nonatomic, strong) SignupListViewController *signupListController;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, strong) UIScrollView *theScrollView;
@property (nonatomic, copy) NSArray *pages;
//@property (nonatomic, strong) OfflineCourseDetail *detail;

@end

@implementation TopicCourseDetailController

-(void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.classId == nil) {
        self.classId = @"";
    }
    
    NSDictionary *dict = @{@"courseId":_courseId, @"clazzId":_classId, @"userId":gUserID};
    [self.request requestOffLineCourseDetailWithDict:dict block:^(ZSOfflineCourseDetailModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            _headerView.detailModel = model.data;
            _signupListController.classId = _classId;
            _signupListController.courseId = model.data.courseId;
            
            _courseController.htmlStr = model.data.descr;
            _homeworkController.htmlStr = model.data.homeworkDesc;
        }else{
            [self showHint:model.message];
        }
        
    }];
    
    [self.view addSubview:self.theScrollView];
    
    self.theScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.headerView)+  SCREEN_HEIGHT-64);
    [self.theScrollView addSubview:self.headerView];
    
    [self.theScrollView addSubview:self.segmentView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark -- lazy method
-(TopicCourseHeaderView *)headerView{
    if (!_headerView) {
        _headerView = (TopicCourseHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"TopicCourseHeaderView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0.0, SCREEN_WIDTH, 300);
        
    }
    return _headerView;
}

-(UIView *)segmentView{
    if (!_segmentView) {
//        _segmentView = [self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.thePlayView) + 10.0 , SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 ) andTitles:_tabTitles andTitleFontSize:13.0f andImages:nil andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
        
         _segmentView=[self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.headerView) , SCREEN_WIDTH,SCREEN_HEIGHT - 64.0) andTitles:@[ @"课程简介", @"签到记录",  @"作业要求"] andTitleFontSize:13 andImages:nil andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
    }
    return _segmentView;
}


-(NSArray *)pages{
    if (!_pages) {
        _courseController = [[CourseIntroController alloc] init];
        _signupListController = [[SignupListViewController alloc] init];
        _homeworkController = [[HomeworkDemandController alloc] init];
        _pages = @[_courseController, _signupListController, _homeworkController];
    }
    return _pages;
}

-(UIScrollView *)theScrollView{
    if (!_theScrollView ) {
        _theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _theScrollView.delegate = self;
        _theScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _theScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _theScrollView.showsVerticalScrollIndicator = NO;
        _theScrollView.bounces = NO;
    }
    return _theScrollView;
}

#pragma mark --UIScorllViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat yyy = scrollView.contentOffset.y;
    if (yyy == 300) {
        _courseController.bBounce = YES;
        _signupListController.bBounce = YES;
        _homeworkController.bBounce = YES;
    }else{
        _courseController.bBounce = NO;
        _signupListController.bBounce = NO;
        _homeworkController.bBounce = NO;
    }
}

@end
