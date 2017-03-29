//
//  CourseStudyViewController.m
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "CourseStudyViewController.h"
#import "VideoPlayView.h"
#import "WMPlayer.h"
#import "OrderConfirmCOntroller.h"
#import "AwardView.h"
#import "MakeCommentView.h"
#import "CourseWebViewController.h"
#import "CommentListController.h"
#import "KeyboardView.h"
#import "CourseChaptersViewController.h"
#import "UIViewController+PagesControl.h"
#import "CourseWebViewTestController.h"
#import "JobTestViewController.h"


const CGFloat headerViewHeight = 80;
const CGFloat playerViewHeight = 220;
const CGFloat commentViewHeight = 50;
const CGFloat keyboardViewHeight = 40;

extern NSInteger studysaveinterval;

@interface CourseStudyViewController ()<UIScrollViewDelegate, WMPlayerDelegate, AwardViewDelegate, MakeCommentViewDelegate, CourseChaptersViewControllerDelegate, UIScrollViewDelegate>{

}

@property (nonatomic, strong) UIScrollView *theScrollView;
@property (nonatomic, strong) VideoPlayView *headerView;

@property (nonatomic, strong) NSMutableArray<ZSChaptersInfo *> *chapters;

@property (nonatomic, strong) ZSOnlineCourseDetail *courseDetail;
@property (nonatomic, assign) BOOL learnedFlag;  //是否已经学习
@property (nonatomic, strong) ZSChaptersInfo *nowChapter;
@property (nonatomic, strong) WMPlayer *myPlayer;

@property (nonatomic, strong) KLCPopup *awardPopup;
@property (nonatomic, assign) BOOL isChooseCourseSucess;

@property (nonatomic, strong) MakeCommentView *commentView;

@property (nonatomic, strong) CommentListController *commentController;
@property (nonatomic, strong) CourseWebViewController *descController;
@property (nonatomic, strong) JobTestViewController *testController;
@property (nonatomic, strong) CourseChaptersViewController *chaptersController;

@property (nonatomic, strong) UILabel *htmlLabel;

@property (nonatomic, strong) NSTimer *saveCourseTimer;
@property (nonatomic, strong) NSTimer *courseProgressTimer;

@property (nonatomic, copy) NSArray *tabTitles;

@property (nonatomic, strong) UIView *segmentView;

@property (nonatomic, strong) NSArray *pages;


@end

@implementation CourseStudyViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.title = @"课程学习 ";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    self.navigationController.navigationBar.translucent = NO;
//    [self setupNav];
    
    [self.view addSubview:self.theScrollView];
    [self.theScrollView addSubview:self.headerView];
   
    self.theScrollView .contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.headerView)+10+  SCREEN_HEIGHT-playerViewHeight-64);
    
    [self.view addSubview:self.commentView];
    [self.view addSubview:self.keyboardView];
    
    [self fetchData];
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:YES];
   
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self killTimer];
    NSArray *viewControllers = self.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        //当前视图控制器在栈中，故为push操作
        NSLog(@"push");
        [_myPlayer pause];
    }else if (gUserID.length == 0 && viewControllers.count == 3){
        [_myPlayer pause];
    }else{
        //当前视图控制器不在栈中，故为pop操作
        NSLog(@"pop");
        if (_learnedFlag == YES && _myPlayer.currentTime != 0 && [_nowChapter.resType isEqualToString:@"html"] == NO) {  //只有在选课的情况下才保存
            [self saveCourseInfo:_myPlayer.currentTime];
        }
        
        [self releasePlayers];
        //        [self.videoController dismiss];
    }
}

- (void)setupNav{
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    [self.navigationItem setRightBarButtonItem:shareItem];
}


#pragma mark --lazy method--
-(UIScrollView *)theScrollView{
    if (!_theScrollView ) {
        _theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, playerViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-playerViewHeight)];
        _theScrollView.delegate = self;
        _theScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _theScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _theScrollView.showsVerticalScrollIndicator = NO;
        _theScrollView.bounces = NO;
    }
    return _theScrollView;
}

-(VideoPlayView *)headerView{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerViewHeight);
        [_headerView.purchaseButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.chooseCourseButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.isPurchaseSucess = _isPurchaseSucess;
        _headerView.isChooseCourseSucess = _isChooseCourseSucess;
    }
    return _headerView;
}

-(WMPlayer *)myPlayer{
    if (!_myPlayer) {
        _myPlayer = [[WMPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, playerViewHeight)];
        _myPlayer.originFrame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        _myPlayer.hostView = self.view;
        _myPlayer.delegate = self;
        _myPlayer.hostViewController = self;
        _myPlayer.closeBtn.hidden = NO;
    }
    return _myPlayer;
}

-(UILabel *)htmlLabel{
    if (!_htmlLabel) {
        _htmlLabel = [[UILabel alloc] init];
        _htmlLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
        _htmlLabel.textColor = kMainThemeColor;
        _htmlLabel.text = @"该课件为html课件";
        _htmlLabel.textAlignment = NSTextAlignmentCenter;
        _htmlLabel.font = [UIFont systemFontOfSize:18];
    }
    return _htmlLabel;
}


-(MakeCommentView *)commentView{
    if (!_commentView) {
        _commentView = [[MakeCommentView alloc] init];
        _commentView.frame = CGRectMake(0, SCREEN_HEIGHT-commentViewHeight-64, SCREEN_WIDTH, commentViewHeight);
        _commentView.theDelegate = self;
        __weak __typeof__(self) wSelf = self;
        _commentView.clickTfBlock = ^(){
            [wSelf goToComment];
        };
    }
    return _commentView;
}

-(KeyboardView *)keyboardView{
    if (!_keyboardView) {
        _keyboardView = [[KeyboardView alloc] init];
        _keyboardView.frame = CGRectMake(0, SCREEN_HEIGHT-commentViewHeight-64, SCREEN_WIDTH, commentViewHeight);
//        _commentView.theDelegate = self;
//        __weak __typeof__(self) wSelf = self;
//        _commentView.clickTfBlock = ^(){
//            [wSelf goToComment];
//        };
    }
    return _keyboardView;
}

-(UIView *)segmentView{
    if (!_segmentView) {
        _segmentView = [self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.headerView) + 10.0 , SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 ) andTitles:_tabTitles andTitleFontSize:13.0f andImages:nil andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
    }
    return _segmentView;
}

-(NSArray *)pages{
    if (!_pages) {
        _chaptersController = [[CourseChaptersViewController alloc] init];
        _chaptersController.theDelegate = self;
        _chaptersController.courseStduyCotroller = self;
        _chaptersController.theHostScrollView = self.theScrollView;
        
        _descController = [[CourseWebViewController alloc] init];
        _descController.courseStduyCotroller = self;
        
        _commentController = [[CommentListController alloc] init];
        _commentController.resourceType = @"course";
        _commentController.objectId = _courseId;
        _commentController.courseStduyCotroller = self;
        
        _testController = [JobTestViewController new];
        _testController.objectId = self.courseDetail.courseId;
//        _testController.objectId = @"1278284";
        _testController.type = @"course";
        _testController.courseStduyCotroller = self;
        
        if (self.courseDetail.hasTest == YES) {
            _pages = @[_chaptersController, _descController, _commentController, _testController];
        }else{
            _pages = @[_chaptersController, _descController, _commentController];
        }
        

    }
    return _pages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)fetchData{
    NSString *userId = @"0";
    if (gUserID.length != 0 && gUserID != nil) {
        userId = gUserID;
    }
    
    if (_classId.length == 0 || _classId == nil) {
        _classId = @"0";
    }
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dict = @{@"courseId":_courseId, @"userId":userId, @"clazzId":_classId};
    [self.request requestOnlineCourseDetail:dict withBlock:^(ZSOnlineCourseDetailModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            _courseDetail = model.data;
            if (_courseDetail.shareUrl != nil && _courseDetail.shareUrl.length != 0) {
                [self setupNav];
            }
            
            if (_courseDetail.hasTest == YES) {
                _tabTitles = @[@"章节列表", @"课程简介", @"在线交流 ",@"作业测试"];
            }else{
                _tabTitles = @[@"章节列表", @"课程简介", @"在线交流 "];
            }
            
            [self.theScrollView addSubview:self.segmentView];
            
            self.headerView.courseDetail = _courseDetail;
            _learnedFlag = _courseDetail.learnFlag;
            _chapters = model.data.chapters.mutableCopy;
            
            _chaptersController.chapters = _chapters;
            _descController.htmlStr = _courseDetail.courseDesc;
            
            _commentView.needReward = _courseDetail.needReward;
            if (_courseDetail.latestLearnChapter != nil) {
                [self playTheLatestChapterBytheId:_courseDetail.latestLearnChapter.chapterId];
                self.headerView.branchNameLabel.text = [@"之" add:_courseDetail.latestLearnChapter.chapterName];
                
            }else{  //
                if (_chapters.count != 0) {  //如果没有最近学习章节，定位到列表第一个
                    self.headerView.branchNameLabel.text = [@"之" add: _chapters[0].chapterName];
                    _nowChapter = _chapters[0];
                    _chaptersController.choseChapterId = _nowChapter.chapterId;
                    [self playChapter:_nowChapter toTime:_nowChapter.breakPoint stop:YES];
                }
            }
        }else{
            [self showHint:model.message];
        }
    }];
    
}


#pragma mark --CourseChaptersViewControllerDelegate--
-(void)clickTheIndex:(NSInteger)index{
    [self saveCourseInfo:_myPlayer.currentTime];
    
    [self startTimer];
    _nowChapter = _chapters[index];
    self.headerView.branchNameLabel.text = [@"之" add: _nowChapter.chapterName];
    if (_nowChapter.isFinished) {
//        [self updateChapter:0.f];
        _courseProgressTimer.fireDate = [NSDate distantFuture];
        
        [self saveCourseInfo:0.f];
        [self playChapter:_nowChapter toTime:0 stop:NO];
    }else{
        [self playChapter:_nowChapter toTime:_nowChapter.breakPoint stop:NO];
    }
}

#pragma mark --AwardViewDelegate
-(void)awardWithPayWay:(NSString *)payWay andMoneyNum:(NSString *)moneyNum{
    Hint(moneyNum, @"请输入打赏金额");
    
    [_awardPopup dismiss:YES];
    
    NSDictionary *dict = @{@"userId":gUserID, @"courseStr":_courseId, @"clazzId":_classId, @"rewardmoney":@"1", @"useCoin":@"0"};
    [[ZSPay instance]  payCourseWithPayType:payWay andFromAward:YES andDataDicitonary:dict andViewController:self successBlock:nil];
}

#pragma mark --MakeCommentViewDelegate
-(void)wishToAward{
    AwardView *awardView = (AwardView *)[[[NSBundle mainBundle] loadNibNamed:@"AwardView" owner:nil options:nil] lastObject];
    awardView.theDelegate = self;
    _awardPopup = [KLCPopup popupWithContentView:awardView];
    [_awardPopup show];
    
}

-(void)wishToComment{
    [self goToComment];
}

-(void)goToComment{
    __weak typeof(self) wSelf = self;
    [self.hmSegment setSelectedSegmentIndex:2 animated:YES];
    NSInteger index = self.hmSegment.selectedSegmentIndex;
    [self.pageController setViewControllers:@[ [self.pages objectAtIndex:self.hmSegment.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        wSelf.currentPageIndex = index;
    }];
    
//    _segmentView.currentPageIndex = 2;
}


#pragma mark -- 分享--
-(void)shareAction:(UIButton *)sender{
    [ZSShare platShareView:self.view WithShareContent:@"智慧学习" WithShareUrlImg:@"logo" WithShareUrl:_courseDetail.shareUrl WithShareTitle:_courseDetail.courseName];
}

//  点击四个按钮的方法
-(void)clickButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 2:{  //购买
            if (gUserID.length == 0) {
                [self directLoginWithSucessBlock:^{
                }];
            }else{
                OrderConfirmCOntroller *destVc = [[OrderConfirmCOntroller alloc] init];
                destVc.courseName = _courseDetail.courseName;
                destVc.coursePrice = _courseDetail.coursePrice;
                destVc.courseIcon = _courseDetail.courseIcon;
                destVc.courseId = _courseDetail.courseId;
                destVc.preVc = self;
                [self.navigationController pushViewController:destVc animated:YES];
            }
            
        }break;
        case 5:{  //更多
            
        }break;
        case 6:{  //去选课
            //            clazzId=3187698&courseId=3158176&s=d&t=d&userId=3187705
            if (gUserID.length == 0) {
                [self directLoginWithSucessBlock:^{
                }];
            }else{
                NSDictionary *dict= @{@"clazzId":@"0",@"courseId":_courseDetail.courseId, @"userId":gUserID };
                [self.request toChooseCourseWithDict:dict withBlock:^(ZSModel *model, NSError *error) {
                    if (model.isSuccess) {
                        [self showHint:model.message];
                        _learnedFlag = YES;
                        _isChooseCourseSucess = YES;
                        self.headerView.isChooseCourseSucess = YES;
                    }else{
                        [self showHint:model.message];
                    }
                }];
            }
            
        }break;
        default:
            break;
    }
}


#pragma mark --play video
-(void)playTheLatestChapterBytheId:(NSString *)theChapterId{
    NSInteger index = 0;
    for (ZSChaptersInfo *chapter in _chapters) {
        NSString *chapterId = chapter.chapterId;
        if ([chapterId isEqualToString:theChapterId]) {
            _nowChapter = chapter;
            _chaptersController.choseChapterId = _nowChapter.chapterId;
            if ([_nowChapter.resType isEqualToString:@"html"] == NO) {
                [self playChapter:chapter toTime:chapter.breakPoint stop:YES];
            }
            
            break ;
        }
        ++index;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
//        _theScrollView.contentOffset = CGPointMake(0, headerViewHeight+10);
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//        [_chaptersController.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

-(void)playChapter:(ZSChaptersInfo *)chapter toTime:(NSString *)time stop:(BOOL)stop{
    double t = [time doubleValue];
    [self releasePlayers];
    if ([chapter.resType isEqualToString:@"video"] || [chapter.resType isEqualToString:@"pptvideo"]) {
        
        [self.view addSubview:self.myPlayer];
        _myPlayer.playType = chapter.resType;
        if ([chapter.resType isEqualToString:@"pptvideo"]) {
            _myPlayer.URLString = chapter.pptVideoUrl;
            _myPlayer.pptImgList = chapter.pptImgList;
            _myPlayer.pptVideoIndex = [chapter.pptVideoIndex componentsSeparatedByString:@","];
        }else{
            _myPlayer.URLString = chapter.resourceUrl;
        }
        
        if (t == 0) {
            [_myPlayer play];
        }else{
            _myPlayer.seekTime = t;
            if (stop == NO) {
                [_myPlayer play];
            }else{
                
            }
        }
    }else if ([chapter.resType isEqualToString:@"html"]){
        if (self.htmlLabel.superview != nil) {
            [self.htmlLabel removeFromSuperview];
        }
        [self.view addSubview:self.htmlLabel];
        CourseWebViewController *destVc = [[CourseWebViewController alloc] init];
        destVc.urlStr = chapter.htmlUrl;
        destVc.title = chapter.chapterName;
        destVc.isFromCourseHtml = YES;
        destVc.courseId = _courseId;
        destVc.chapterId = _nowChapter.chapterId;
        destVc.classId = _classId;
        destVc.learnFlag = _learnedFlag;
        
        [self.navigationController pushViewController:destVc animated:YES];
    }
}

-(void)setIsPurchaseSucess:(BOOL)isPurchaseSucess{
    _isPurchaseSucess = isPurchaseSucess;
    self.headerView.isPurchaseSucess = isPurchaseSucess;
}

#pragma mark --UIScorllViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat yyy = scrollView.contentOffset.y;
    if (yyy >= headerViewHeight+10) {
        _chaptersController.bBounce = YES;
//        _testController.bBounce = YES;
        _commentController.bBounce = YES;
        _descController.bBounce = YES;
    }else{
        if (_chaptersController.bBounce == YES) {
            _chaptersController.bBounce = NO;
        }
        _chaptersController.bBounce = NO;
//        _testController.bBounce = NO;
        _commentController.bBounce = NO;
        _descController.bBounce = NO;
    }
}


///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"clickedCloseButton");
    [self releasePlayers];
    [self.navigationController popViewControllerAnimated:YES];
    
}
///播放暂停
-(void)wmplayer:(WMPlayer *)wmplayer clickedPlayOrPauseButton:(UIButton *)playOrPauseBtn{
    if (playOrPauseBtn.selected == NO) {
        [self startTimer];
        if (_nowChapter.isFinished) {
            _courseProgressTimer.fireDate = [NSDate distantFuture];
            [self saveCourseInfo:0.f];
        }
    }else{
        self.saveCourseTimer.fireDate = [NSDate distantFuture]; //暂停定时器
    }
    NSLog(@"clickedPlayOrPauseButton");
}

///单击播放器
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}
///双击播放器
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
    if (_nowChapter.isFinished == YES) {
        _courseProgressTimer.fireDate = [NSDate distantFuture];
    }else{
        [self startTimer];
    }
    
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
    [self saveCourseInfo:_myPlayer.totalTime];
    
    [self updateChapter:_myPlayer.totalTime];
    
    _nowChapter.isFinished = YES;
    
    _saveCourseTimer.fireDate = [NSDate distantFuture]; //暂停定时器
    _courseProgressTimer.fireDate = [NSDate distantFuture];
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange{
    if (_myPlayer==nil||_myPlayer.superview==nil){
        return;
    }
}

#pragma mark ---定时器---
-(void)startTimer{
    if (!_saveCourseTimer) {
        _saveCourseTimer = [NSTimer scheduledTimerWithTimeInterval:studysaveinterval target:self selector:@selector(timerSaveCourseAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_saveCourseTimer forMode: UITrackingRunLoopMode];
    }else{
        _saveCourseTimer.fireDate = [NSDate distantPast]; //恢复定时器
    }
    
    if (!_courseProgressTimer) {
        _courseProgressTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timerCourseProgressAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_courseProgressTimer forMode: UITrackingRunLoopMode];
    }else{
        _courseProgressTimer.fireDate = [NSDate distantPast]; //恢复定时器
    }
    
    return ;
}

-(void)killTimer{
    if (_saveCourseTimer) {
        [_saveCourseTimer invalidate];
        _saveCourseTimer = nil ;
    }
    
    if (_courseProgressTimer) {
        [_courseProgressTimer invalidate];
        _courseProgressTimer = nil;
    }
    return ;
}

-(void)timerSaveCourseAction{
    if (_learnedFlag == NO || _myPlayer.playOrPauseBtn.selected==YES) {  //只有在选课的情况下才保存
        return ;
    }
    float breakPoint = 0;
    breakPoint = _myPlayer.currentTime;
    if (breakPoint == 0) {
        return ;
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"%f", breakPoint]);
    
    [self saveCourseInfo:breakPoint];
    
}

-(void)timerCourseProgressAction{
    if (_myPlayer.currentTime != 0) {
        [self updateChapter:_myPlayer.currentTime];
    }
  
}

-(void)updateChapter:(float)breakPoint{
    if (_learnedFlag == YES && _myPlayer.totalTime != 0) {
        CGFloat learnCoverRate = (breakPoint/_myPlayer.totalTime)*100;
        if (learnCoverRate > 100) {
            learnCoverRate = 100;
        }
        _nowChapter.learnCoverRate = [NSString stringWithFormat:@"%.f", learnCoverRate];
        _nowChapter.breakPoint = [NSString stringWithFormat:@"%f", breakPoint];
        _chaptersController.chapters = _chapters;
    }
}

-(void)saveCourseInfo:(float)breakPoint{
    if (_learnedFlag == YES && _myPlayer.totalTime != 0) {
        NSDictionary *dict = @{@"courseId":_courseId, @"userId":gUserID, @"clazzId":_classId, @"chapterId":_nowChapter.chapterId, @"breakPoint":[NSString stringWithFormat:@"%f", breakPoint], @"timerInterval":@"10", @"videoLen":[NSString stringWithFormat:@"%.3f", _myPlayer.totalTime]};
        [self.request saveCousrseInfoWithData:dict withBlock:^(ZSModel *model, NSError *error) {
            if (model.isSuccess) {
                
            }else{
                [self showHint:model.message];
            }
        }];

    }
}

- (void)releasePlayers
{
    if (_myPlayer) {
        [_myPlayer dismiss];
        _myPlayer = nil;
    }
}


-(void)setBShowCommentView:(BOOL)bShowCommentView{
    _bShowCommentView = bShowCommentView;
    _commentView.hidden = !_bShowCommentView;
    _commentView.userInteractionEnabled = _bShowCommentView;
    
    _keyboardView.hidden = !_commentView.hidden;
    _keyboardView.userInteractionEnabled = !bShowCommentView;
}



@end
