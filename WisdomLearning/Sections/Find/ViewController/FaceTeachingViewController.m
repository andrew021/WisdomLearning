//
//  FaceTeachingViewController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "FaceTeachingViewController.h"
#import "ClassroomView.h"
#import "AssigningCourseController.h"
#import "QuestionnaireController.h"
#import "ClassmatesController.h"
#import "PersonalDetailsViewController.h"
#import "NearbyStudentsViewController.h"
#import "ChatViewController.h"
#import "PageControllerView.h"
#import "DynDetailsViewController.h"
#import "WebViewViewController.h"

extern NSString *tenantCode;

@interface FaceTeachingViewController ()<UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource,ClassroomViewDelegate,ToClassroomViewDelegate,ClickHMSegmentedContol>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ClassroomView *classroomView;
@property (nonatomic, copy) NSArray *pages;
@property (nonatomic,strong) OnLineClassDetail * classDetail;
@property (nonatomic, strong) UIButton *joinChatButton;
@property (nonatomic, strong) AssigningCourseController *v1;
@property (nonatomic,strong) NearbyStudentsViewController *v2;


@end

@implementation FaceTeachingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.classroomView];
    
    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, ViewMaxY(self.classroomView) + 10.0 , SCREEN_WIDTH,SCREEN_HEIGHT - 64.0) andTitles:@[ @"课程安排", @"同学录"] andTitleFontSize:13 andImages:@[@"arrange",@"classmates"] andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
    [self.scrollView addSubview:pagesView];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,  ViewHeight(self.classroomView) + 10 + SCREEN_HEIGHT);
    
    if (_scrollView.contentOffset.y == 0){
        _v1.tableView.scrollEnabled = NO;
        _v2.tableView.scrollEnabled = NO;
    }
    
   [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dict = @{@"userId":[[Config Instance] getUserid], @"clazzId":_classId, @"tenantCode":tenantCode};
    [self.request requestOffLineClassDetailWithDict:dict block:^(OnLineClassDetailModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if (model.isSuccess) {
            _classroomView.detail = model.data;
            _classDetail = model.data;
            if (model.data.hotNotice.count==0) {
                _classroomView.noticeView.hidden = YES;
            }
        }
        [self setNav];
    }];
}

-(void)setNav
{
    if (self.classDetail.shareUrl.length != 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    }
}
//分享
-(void)shareAction:(id)sender{
    NSString *url = _classDetail.shareUrl;
    [ZSShare platShareView:self.view WithShareContent:@"智慧学习" WithShareUrlImg:@"logo" WithShareUrl:url WithShareTitle:_classDetail.className];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.y > ViewMaxY(self.classroomView)) {
        _v1.tableView.scrollEnabled = YES;
        _v2.tableView.scrollEnabled = YES;
    } else {
        _v1.tableView.scrollEnabled = NO;
        _v2.tableView.scrollEnabled = NO;
    }
}

////点击HMSegmentedControl
//-(void)clickHMSegmentedContolIndex:(NSInteger)index
//{
//    if(index==1){
//       
//    }
//    else{
//      
//    }
//}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --lazy method
-(NSArray *)pages{
    if (!_pages) {
        _v1 = [[AssigningCourseController alloc] init];
        _v1.classId = _classId;
//        QuestionnaireController *v2 = [[QuestionnaireController alloc] init];
     _v2 = [[NearbyStudentsViewController alloc] init];
        _v2.typeID = @"clazzId";
        _v2.type = @"like";
        _v2.ID = _classId;
        _v2.isCreateBtn = NO;
        _v2.delegate = self;
        _pages = @[_v1, _v2];
        
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
        if (self.classDetail.noticeTitle.length != 0) {
            _classroomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 364.0);
        } else {
            _classroomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 340.0);
        }
        _classroomView.delegate = self;
    }
    return _classroomView;
}
-(void)ClassroomViewWithNoticeTitle:(NSString *)title url:(NSString *)url
{
    WebViewViewController *vc = [WebViewViewController new];
    vc.urlStr = url;
    vc.navigationItem.title = @"班级公告";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 签到---

- (void)ClassroomViewWithClickBtns:(UIButton *)sender
{
    if (sender.tag == 1) {
        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
        vc.projectId = _classDetail.programId;
        vc.classId = _classDetail.classId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if([gUsername isEqualToString:@"hy_px_demo"]){
            return [self showHint:@"访客账号不能聊天!"];
        }
        
        if(_classDetail.groupMember){
            ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:_classDetail.imgroupId conversationType:EMConversationTypeGroupChat];
            chatController.ID = _classDetail.imgroupId;
            chatController.title = _classDetail.className;
            chatController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        else{
            [self showHint:@"您不是该群成员!"];
            
        }
    }
}

-(void)ToClassroomViewWithClickBtns:(UIButton *)sender
{
    PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
    vc.projectId = self.classDetail.programId;
    [self.navigationController pushViewController:vc animated:YES];
    
//    ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:@"groupId" conversationType:EMConversationTypeChat];
//    chatController.ID = @"groupId";
//    chatController.title = _model.clazzName;
//    chatController.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatController animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
