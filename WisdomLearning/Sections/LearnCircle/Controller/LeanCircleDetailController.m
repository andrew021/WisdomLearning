//
//  LeanCircleDetailController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//学习圈详细

#import "LeanCircleDetailController.h"
#import "LearnCircleDetailHeadView.h"
#import "ImageView.h"
#import "NewThingViewController.h"
#import "CommentListController.h"
#import "HMSegmentedControl.h"
#import "ChatViewController.h"
#import "UIViewController+PagesControl.h"
#import "NearbyStudentsViewController.h"
#import "ThematicContentViewController.h"
#import "SystemMessageViewController.h"
#import "Study.h"
#import "CourseLearnViewController.h"


@interface LeanCircleDetailController ()<UIScrollViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate,ImageViewDelegate,LearnCircleDetailDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong)  LearnCircleDetailHeadView * headView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl1;
@property (nonatomic, strong) UIPageViewController *pages;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, strong) UIViewController *p_displayingViewController;
@property (nonatomic, strong) UIViewController * v3;
@property (nonatomic, strong) NewThingViewController * newthVC;
@property (nonatomic, strong) CommentListController * commentVC;
@property (nonatomic, strong) UIViewController * v5;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ImageView * imageViews;
@property (nonatomic, strong) NSArray *viewPages;
@property (nonatomic, strong) NearbyStudentsViewController * nearVC;
@property (nonatomic, strong) TopicsDetails * model;
@end

@implementation LeanCircleDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
     [self fetchData];
    [self setupScrollView];
     [self cretateView];
    [self createPagesView];
    self.currentPageIndex = 0;
    self.viewControllerArray = [NSMutableArray new];
    //[self setupSegmented];
    //[self setupContainerView];
    [self setupNav];
  
   
  //  self.title = @"学习圈详细";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak LeanCircleDetailController* weakSelf = self;
    [self.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
}

-(void)fetchData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary * dic = @{@"userId":gUserID,@"projectId":_proId,@"type":@"circle"};
    [self.request requestTopicsDetailsWithDic:dic block:^(TopicsDetailsModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            _model = model.data;
            _headView.model = _model;
            _newthVC.objectId = _model.Id;
        }
        else{
            [self showHint:model.message];
        }
    }];
}


#pragma mark --- 创建导航栏按钮
- (void)setupNav{
      UIBarButtonItem * newsItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news"] style:UIBarButtonItemStylePlain target:self action:@selector(newsAction:)];
 //searchItem.imageInsets = UIEdgeInsetsMake(0, 12, 0, -12);
     UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    [self.navigationItem setRightBarButtonItems:@[shareItem,newsItem]];
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
    
    self.headView = (LearnCircleDetailHeadView *)[[[NSBundle mainBundle] loadNibNamed:@"LearnCircleDetailHeadView" owner:nil options:nil] lastObject];
    self.headView.frame = CGRectMake(0, 0.0, SCREEN_WIDTH, 370.0);
    self.headView.delegate = self;
    [self.scrollView addSubview:self.headView];
    

}



#pragma mark--- 创建ViewControllers
-(void)createPagesView
{

    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, 380 , SCREEN_WIDTH,SCREEN_HEIGHT - 64.0 ) andTitles:@[@"评论", @"新鲜事", @"课程学习", @"红人",@"同类发现"] andTitleFontSize:14 andImages:@[@"common",@"new_thing",@"subject_learn",@"hot_man",@"Similar_find"] andPageControllers:self.viewPages andSegmentColor:[UIColor whiteColor]];
    [self.scrollView addSubview:pagesView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.headView)+10+SCREEN_HEIGHT);

}

#pragma mark---  containerView
-(NSArray *)viewPages{
    if (!_viewPages) {
        CourseLearnViewController * v3 = [[CourseLearnViewController alloc] init];
        v3.userId = gUserID;
        v3.objectId = _proId;
        v3.type = @"circle";
        
        
        _newthVC = [[NewThingViewController alloc] init];
        _newthVC.objectId = _model.Id;
        _newthVC.objectType = @"circle";
        
        _commentVC = [[CommentListController alloc] init];
        _commentVC.resourceType = @"circle";
        _commentVC.objectId = _proId;
        _commentVC.commentViewHeight = 80;
        _commentVC.tableViewHeight = 84;
        
      
        
        _nearVC = [[NearbyStudentsViewController alloc] init];
         _nearVC.typeID = @"circleId";
         _nearVC.type = @"hot";
        _nearVC.ID = _proId;
        NearbyStudentsViewController * vc = [[NearbyStudentsViewController alloc]init];
        vc.typeID = @"circleId";
        vc.type = @"like";
        vc.ID = _proId;
        _viewPages = @[ _commentVC, _newthVC, v3, _nearVC,vc];
        
    }
    return _viewPages;
}


#pragma mark--顶部View 按钮代理
-(void)clickBtns:(UIButton *)sender
{
    if(sender.tag == 1){
        if([gUsername isEqualToString:@"hy_px_demo"]){
            return [self showHint:@"访客账号不能聊天!"];
        }
        
        if(_model.groupMember){
            ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:_model.imgroupId conversationType:EMConversationTypeGroupChat];
            chatController.ID = _model.imgroupId;
            chatController.title = _model.name;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        else{
            [self showHint:@"您不是该群成员!"];

        }

        
      
    }
    else{
   
        [self showHudInView:self.view hint:@"提交中..."];
        NSDictionary * dic = @{@"userId":gUserID,@"circleId":_proId};
        
        [self.request toSignUpOfflineClassWithDict:dic block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            if(model.isSuccess){
                [self showHint:model.message];
                self.headView.signBtn.enabled = NO;
                [self.headView.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
                self.headView.signBtn.layer.borderColor = KMainLine.CGColor;
            }
            else{
                [self showHint:model.message];
            }
        }];
     
        
    }
}

#pragma mark --- 导航栏按钮点击方法
//消息
-(void)newsAction:(id)sender{
    NSLog(@"消息");
    SystemMessageViewController * vc = [[SystemMessageViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.tableViewHeight = 64;
    vc.title = @"学习圈消息";
    [self.navigationController pushViewController:vc animated:YES];
}

//分享
-(void)shareAction:(id)sender{
//    NSLog(@"分享");
//    NSString *url = @"http://www.baidu.com";
//    [ZSShare platShareView:self.view WithShareContent:@"好东西" WithShareUrlImg:@"study_back" WithShareUrl:url WithShareTitle:@"这个是h5页面"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow:(NSNotification *) notify
{
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    if (keyboardRect.size.height >250) {
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            _scrollView.contentOffset = CGPointMake(0, ViewHeight(self.headView)+10);
        
        }];
            
    }
}




@end
