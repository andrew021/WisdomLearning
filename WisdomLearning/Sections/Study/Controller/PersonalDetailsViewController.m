//
//  PersonalDetailsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "PersonalDetailsViewController.h"
#import "HomeHeaderView.h"
#import "NewThingViewController.h"
#import "ThematicContentViewController.h"
#import "JobTestViewController.h"
#import "NearbyStudentsViewController.h"
#import "CommentListController.h"
#import "ChatViewController.h"
#import "SystemMessageViewController.h"
#import "ChangeClassViewController.h"

extern NSString *freshfunc;
extern NSString *tenantCode;

@interface PersonalDetailsViewController ()<UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate,HomeHeaderViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HomeHeaderView * headView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray *viewPages;
@property (nonatomic, strong) TopicsDetails *model;
@property (nonatomic, strong) ChangeClassViewController *v6;
@property (nonatomic, strong) CommentListController *v1;
@end

@implementation PersonalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offsetTop:) name:@"SCROLLVIEWTOP" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)offsetTop:(NSNotification *)noti
{
    self.scrollView.contentOffset = CGPointMake(0, 435.0);
}

#pragma mark --- 创建导航栏按钮
- (void)setupNav{
    UIBarButtonItem * newsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news"] style:UIBarButtonItemStylePlain target:self action:@selector(newsAction:)];
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    if (self.model.shareUrl.length == 0) {
        [self.navigationItem setRightBarButtonItem:newsItem];
    } else {
        [self.navigationItem setRightBarButtonItems:@[shareItem,newsItem]];
    }
}

#pragma mark --- 创建scrollView
- (void)setupScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
}

#pragma mark--顶部View
- (void)cretateView{
    self.headView = (HomeHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"HomeHeaderView" owner:nil options:nil] lastObject];
    self.headView.frame = CGRectMake(0, 0.0, SCREEN_WIDTH, 425.0);
    self.headView.delegate = self;
    self.headView.model = self.model;
    [self.scrollView addSubview:self.headView];
}

#pragma mark--- 创建ViewControllers
-(void)createPagesView
{
    NSArray *titles;
    NSArray *images;
    if ([freshfunc isEqualToString:@"off"]) {
        titles = @[@"评论", @"培训内容",@"附近同学",@"班级"];
        images = @[@"common", @"subject_learn", @"Similar_find", @"study_change"];
    } else {
        titles = @[@"评论", @"新鲜事", @"培训内容",@"附近同学",@"班级"];
        images = @[@"common", @"new_thing", @"subject_learn", @"Similar_find", @"study_change"];
    }
    
    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.headView) + 10.0 , SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 ) andTitles:titles andTitleFontSize:13.0f andImages:images andPageControllers:self.viewPages andSegmentColor:[UIColor whiteColor]];
    [self.scrollView addSubview:pagesView];
    
    Offset *set = [Offset sharedInstance];
    set.offset = 2.0;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.headView) + SCREEN_HEIGHT + 10.0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString * string = [NSString stringWithFormat:@"%f",self.scrollView.contentOffset.y];
    _v6.offset = self.scrollView.contentOffset.y;
    _v1.offset = self.scrollView.contentOffset.y;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:string,@"OFFSET", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLLVIEW" object:nil userInfo:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IMMOBILIZATION" object:nil userInfo:dic];
    Offset *set = [Offset sharedInstance];
    set.offset = self.scrollView.contentOffset.y;
}

#pragma mark---  containerView
-(NSArray *)viewPages{
    if (!_viewPages) {
        _v1 = [CommentListController new];
        _v1.commentViewHeight = 80.0;
        _v1.tableViewHeight = 84.0;
        _v1.resourceType = @"program";
        _v1.objectId = self.model.Id;
        
        NewThingViewController *v2 = [NewThingViewController new];
        v2.objectType = @"program";
        v2.objectId = self.projectId;
        
        ThematicContentViewController *v3 = [ThematicContentViewController new];
        v3.userId = gUserID;//@"1634";
        v3.objectType = @"program";
        v3.classId =  self.classId;
        v3.objectId = self.model.Id;
        
        NearbyStudentsViewController *v5 = [NearbyStudentsViewController new];
        v5.typeID = @"programId";
        v5.type = @"like";
        v5.ID = self.model.Id;
        
        _v6 = [ChangeClassViewController new];
        _v6.userId = gUserID;
        _v6.programId = self.model.Id;
        
        if ([freshfunc isEqualToString:@"off"]) {
            _viewPages = @[ _v1, v3, v5, _v6 ];
        } else {
            _viewPages = @[ _v1, v2, v3, v5, _v6 ];
        }
    }
    return _viewPages; 
}

#pragma mark--顶部View 按钮代理
-(void)homeHeaderViewDelegateClickBtns:(UIButton *)sender
{
    if(sender.tag == 1){
        //群聊
        if([gUsername isEqualToString:@"hy_px_demo"]){
            return [self showHint:@"访客账号不能聊天!"];
        }
        
        if (_model.groupMember) {
            ChatViewController *vc = [[ChatViewController alloc]initWithConversationChatter:self.model.imgroupId conversationType:EMConversationTypeGroupChat];
            vc.ID = self.model.imgroupId;
            vc.title = self.model.name;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self showHint:@"您不是该群成员!"];
        }
    } else{
        
        [self showHudInView:self.view hint:@"签到中..."];
        NSDictionary *dic = @{
                              @"userId":gUserID,
                              @"programId":self.model.Id,
                              };
        [self.request toSignUpOfflineClassWithDict:dic block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            if (model.isSuccess) {
                [self showHint:model.message];
                [sender setTitle:@"已签" forState:UIControlStateNormal];
                sender.layer.borderColor = KMainTextGray.CGColor;
                [sender setTitleColor:KMainTextGray forState:UIControlStateNormal];
                sender.enabled = NO;
            } else {
                [self showHint:model.message];
            }
        }];
    }
}

#pragma mark --- 导航栏按钮点击方法
-(void)newsAction:(id)sender{
    //消息
    SystemMessageViewController * vc = [[SystemMessageViewController alloc]init];
    vc.tableViewHeight = 64.0;
    vc.title = @"专题系统消息";
    vc.objectId = self.model.Id;
    vc.type = @"3";
    [self.navigationController pushViewController:vc animated:YES];
}

//分享
-(void)shareAction:(id)sender{
    NSString *url = self.model.shareUrl;
    [ZSShare platShareView:self.view WithShareContent:@"智慧学习" WithShareUrlImg:@"logo" WithShareUrl:url WithShareTitle:self.model.name];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 获取数据
- (void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"tenantCode":tenantCode,
                          @"userId":gUserID,//用户ID不传就是浏览
                          @"projectId":self.projectId,//项目ID
//                          @"clazzId":self.classId,
                          @"type":@"program",//circle：学习圈，program：专题
                          };
    [self.request requestTopicsDetailsWithDic:dic block:^(TopicsDetailsModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if (model.isSuccess) {
            self.model = model.data;
        }
        self.navigationItem.title = self.model.name;
        [self setupScrollView];
        [self cretateView];
        [self createPagesView];
        [self setupNav];
    }];
}


@end
