//
//  DistanceTrainingViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "DistanceTrainingViewController.h"
#import "ClassroomView.h"
#import "EvaluationRequirementsViewController.h"
#import "CourseLearnViewController.h"
#import "JobTestViewController.h"
#import "ClassmatesController.h"
#import "PersonalDetailsViewController.h"
#import "NearbyStudentsViewController.h"
#import "ChatViewController.h"
#import "PageControllerView.h"
#import "DynDetailsViewController.h"
#import "WebViewViewController.h"

extern NSString *tenantCode;

@interface DistanceTrainingViewController ()<UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource,ClassroomViewDelegate,ToClassroomViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ClassroomView *classroomView;
@property (nonatomic, strong) UIButton *joinChatButton;
@property (nonatomic, copy) NSArray *pages;
@property (nonatomic, strong) OnLineClassDetail *detail;
@property (nonatomic,strong) EvaluationRequirementsViewController *v1;
@property (nonatomic,strong) CourseLearnViewController *v2;
@property (nonatomic,strong) JobTestViewController *v3;
@property (nonatomic,strong) NearbyStudentsViewController *v4;
@end

@implementation DistanceTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.scrollView];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma MARK ---  获取数据
- (void)getData
{
    if (tenantCode == nil) {
        tenantCode = @"";
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"tenantCode":tenantCode,
                          @"userId":gUserID,
                          @"clazzId":self.classId,
                          };
    
    [self.request requestOnLineClassDetailWithUserDic:dic block:^(OnLineClassDetailModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if (model.isSuccess) {
            self.detail = model.data;
            self.navigationItem.title = self.detail.className;
            [self.scrollView addSubview:self.classroomView];
            [self setupPages];
        } 
        [self setNav];
    }];
}

-(void)setNav
{
    if (self.detail.shareUrl.length != 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    }
}
//分享
-(void)shareAction:(id)sender{
    NSString *url = self.detail.shareUrl;
    [ZSShare platShareView:self.view WithShareContent:@"智慧学习" WithShareUrlImg:@"logo" WithShareUrl:url WithShareTitle:self.detail.className];
}

- (void) setupPages
{
    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.classroomView) + 10.0 , SCREEN_WIDTH,SCREEN_HEIGHT - 64.0) andTitles:@[ @"考评标准", @"课程学习", @"作业测试",@"同学录"] andTitleFontSize:13.0f andImages:@[@"find_arrange",@"find_study",@"study_jobTest",@"classmates"] andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
    [self.scrollView addSubview:pagesView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.classroomView)+SCREEN_HEIGHT + 10.0);
    if (_scrollView.contentOffset.y == 0){
        _v1.tableView.scrollEnabled = NO;
        _v2.tableView.scrollEnabled = NO;
        _v3.tableView.scrollEnabled = NO;
        _v4.tableView.scrollEnabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.y > ViewMaxY(self.classroomView)) {
        _v1.tableView.scrollEnabled = YES;
        _v2.tableView.scrollEnabled = YES;
        _v3.tableView.scrollEnabled = YES;
        _v4.tableView.scrollEnabled = YES;
    } else {
        _v1.tableView.scrollEnabled = NO;
        _v2.tableView.scrollEnabled = NO;
        _v3.tableView.scrollEnabled = NO;
        _v4.tableView.scrollEnabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)pages{
    if (!_pages) {
        _v1 = [EvaluationRequirementsViewController new];
        _v1.clazzId = self.detail.classId;
        
        _v2 = [CourseLearnViewController new];
        _v2.userId = gUserID;//@"1634";
        _v2.objectId = self.detail.classId;
        _v2.type = @"class";
        
        _v3 = [JobTestViewController new];
        _v3.objectId = self.detail.classId;
        _v3.type = @"class";

        _v4 = [NearbyStudentsViewController new];
        _v4.delegate = self;
        _v4.typeID = @"clazzId";
        _v4.type = @"like";
        _v4.ID = self.detail.classId;
        _v4.isCreateBtn = NO;
        
        _pages = @[_v1, _v2, _v3, _v4];
        
    }
    return _pages;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _scrollView;
}

-(ClassroomView *)classroomView{
    if (!_classroomView) {
        _classroomView = (ClassroomView *)[[[NSBundle mainBundle] loadNibNamed:@"ClassroomView" owner:nil options:nil] lastObject];
        if (self.detail.noticeTitle.length != 0) {
            _classroomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 364.0);
        } else {
            _classroomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 340.0);
        }
        _classroomView.delegate = self;
        _classroomView.detail = self.detail;
    }
    return _classroomView;
}
- (void)ClassroomViewWithClickBtns:(UIButton *)sender
{
    if (sender.tag == 1) {
        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
        vc.projectId = self.detail.programId;
        vc.classId = self.detail.classId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender.tag == 2) {
        
        if([gUsername isEqualToString:@"hy_px_demo"]){
            return [self showHint:@"访客账号不能聊天!"];
        }
        if(_detail.groupMember){
            ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:_detail.imgroupId conversationType:EMConversationTypeGroupChat];
            chatController.ID = _detail.imgroupId;
            chatController.title = _detail.className;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        else{
            [self showHint:@"您不是该群成员!"];
        }
    }
}
-(void)ClassroomViewWithNoticeTitle:(NSString *)title url:(NSString *)url
{
    WebViewViewController *vc = [WebViewViewController new];
    vc.urlStr = url;
    vc.navigationItem.title = @"班级公告";
    [self.navigationController pushViewController:vc animated:YES];
}


@end
