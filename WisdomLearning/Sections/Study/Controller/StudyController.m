//
//  StudyController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//学习首页

#import "StudyController.h"
#import "StudyHeadCell.h"
#import "StudyRemindCell.h"
#import "ButtonWithIcon.h"
#import "EducationalHeadCell.h"
#import "LearnCircleViewController.h"
#import "SpecialBaseViewController.h"
#import "MySpecialViewController.h"
#import "MyCurriculumViewController.h"
#import "CurriculumViewController.h"
#import "MyApplicationViewController.h"
#import "MyCreditViewController.h"
#import "FindCircleController.h"
#import "UIViewController+LoadLoginView.h"
#import "MyCertificateViewController.h"
#import "UIButton+EMWebCache.h"
#import "MyCreditViewController.h"
#import "SystemMessageViewController.h"
#import "CourseStudyViewController.h"
#import "WebViewViewController.h"
#import "JobTestViewController.h"
#import "IndividualHomepageController.h"
#import "StudySignedCell.h"
#import "ZSSegmentImageText.h"
#import "MyCurrencyViewController.h"
#import "DynDetailsViewController.h"
#import "StudyRemindExtCell.h"
#import "MyInformationViewController.h"
#import "PersonalDetailsViewController.h"
#import "DistanceTrainingViewController.h"
#import "FaceTeachingViewController.h"
#import "PageControllerView.h"
#import "DoingCurriculumCell.h"
#import "SpecialListCell.h"
#import "SpecailListCell.h"
#import "SpecialDetailViewController.h"
#import "BmListViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>

extern NSString *studymessage;
extern NSString *studynews;
extern NSInteger possaveinterval;

@interface StudyController ()<UITableViewDataSource,UITableViewDelegate,ClickStudyHeadCellBtn,AMapLocationManagerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) StudyCenter *centerModel;
@property (nonatomic, strong) UserStudyinfo *infoModel;
@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) StudyHeadCell *studyHeadCell;
@property (nonatomic, strong) NSArray *viewsPage;
@property (nonatomic, assign) NSInteger index, selectIndex;;
@property (nonatomic, strong) NSMutableArray *myCoursesList, *myProgramList, *mybmList, *dataArray;

@end

@implementation StudyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    _appArr = @[].mutableCopy;
    
    [self indirectLoginViewWithLoginSucessBlock:^{
        [self getData];
//        [self setupLocation];
        NSArray *arr = [centerfunc componentsSeparatedByString:@","];
        self.index = [[arr firstObject] integerValue];
        [self.tableView reloadData];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:YES];
    } andLogoutBlock:^{
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:NO];
        self.selectIndex = 0;
    }];
    
    if([[Config Instance] isLogin]){
        [self getData];
        NSArray *arr = [centerfunc componentsSeparatedByString:@","];
        self.index = [[arr firstObject] integerValue];
        self.selectIndex = 0;
//        [self setupLocation];
    }
    
    [self createRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshClick) name:USERCOINCHANGE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLightApp) name:@"getLightAppData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyPersonIcon:) name:CHANGEPERSONICONSUCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelect:) name:@"CENTERCHANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutLocation) name:@"logoutLocation" object:nil];
}

//-(void)getLightApp{
//    
//    [self fetchData];
//    
//}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49.0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)modifyPersonIcon:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    [_studyHeadCell.headerBtn setImage:dict[@"newImage"] forState:UIControlStateNormal];
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak StudyController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
}


//#pragma mark---请求数据
//- (void)fetchData
//{
//    
//    NSDictionary * dic = @{@"userId":gUserID};
//    
//    [self.request requestMyLightAppListWithDic:dic block:^(ZSLightAppModel *model, NSError *error) {
//        
//        [self.appArr removeAllObjects];
//        
//        
//        if(model.isSuccess){
//            [self.appArr addObjectsFromArray:model.pageData];
//        }
//        else{
//            [self showHint:model.message];
//        }
//        [self.tableView reloadData];
//        
//    }];
//}

////  网络类型
-(NETWORK_TYPE)getNetworkTypeFromStatusBar {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    return nettype;
}
#pragma mark ---- 获取数据
- (void)getData
{
    NETWORK_TYPE netType =  [self getNetworkTypeFromStatusBar];
    NSString *type = @"";
    if (netType == NETWORK_TYPE_WIFI) {
        type = @"wifi";
    }else if (netType == NETWORK_TYPE_3G){
        type = @"3g";
    }else if (netType == NETWORK_TYPE_4G){
        type = @"4g";
    }else if (netType == NETWORK_TYPE_5G){
        type = @"5g";
    }else if (netType == NETWORK_TYPE_2G){
        type = @"2g";
    }
    [self showHudInView:self.view hint:@"加载中..."];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.zhisou.studyload", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (int i = 0; i < 5; i++) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^() {
            dispatch_group_enter(dispatchGroup);
            if (i == 0) {
                NSDictionary *dict = @{@"userId":gUserID, @"version":appVersion(), @"osId":@"ios", @"net_type" : type};
                [self.request requestStudyCenterWithDict:dict block:^(StudyCenterModel *model, NSError *error) {
                    if (model.isSuccess) {
                        self.centerModel = model.data;
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            } else if (i == 1){
                [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
                    if (model.isSuccess) {
                        self.infoModel = model.data;
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            } else if (i == 2) {
                NSDictionary *dict = @{@"userId":gUserID, @"listType":@"1", @"curPage":@"1"};
                [self.request requestMyCourseListWithDict:dict block:^(ZSMyCourseListModel *model, NSError *error) {
                    [self.myCoursesList removeAllObjects];
                    if (model.isSuccess) {
                        [self.myCoursesList addObjectsFromArray:model.pageData];
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            } else if (i == 3) {
                NSDictionary *dic = @{
                                      @"userId":gUserID,//@"1634",//用户ID
                                      @"type":@"1",//1进行中 2未开始 3已结束
                                      @"curPage":@"1",//页码
                                      };
                [self.request requestUserClassListWithDic:dic block:^(UserClassListModel *model, NSError *error) {
                    [self.myProgramList removeAllObjects];
                    if (model.isSuccess) {
                        [self.myProgramList addObjectsFromArray:model.pageData];
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            } else {
                NSDictionary * dic = @{@"userId":gUserID};
                [self.request requestBmCenterList:dic block:^(ZSLearnCircleModel *model, NSError *error) {
                    [self.mybmList removeAllObjects];
                    if (model.isSuccess) {
                        [self.mybmList addObjectsFromArray:model.pageData];
                    }
                    dispatch_group_leave(dispatchGroup);
                }];
            }
        });
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
        [self hideHud];
        [self.dataArray removeAllObjects];
        if (self.index == 1) {
            [self.dataArray addObjectsFromArray:self.myCoursesList];
        } else if (self.index == 3) {
            [self.dataArray addObjectsFromArray:self.myProgramList];
        } else {
            [self.dataArray addObjectsFromArray:self.mybmList];
        }
        
        [self.tableView removeFromSuperview];
        [self.view addSubview:self.tableView];
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    });
}

-(NSMutableArray *)myCoursesList
{
    if (!_myCoursesList) {
        _myCoursesList = [NSMutableArray array];
    }
    return _myCoursesList;
}

- (NSMutableArray *)myProgramList
{
    if (!_myProgramList) {
        _myProgramList = [NSMutableArray array];
    }
    return _myProgramList;
}

-(NSMutableArray *)mybmList
{
    if (!_mybmList) {
        _mybmList = [NSMutableArray array];
    }
    return _mybmList;
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark tableView的dataSource和代理方法
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        if ([studymessage isEqualToString:@"on"]) {
            if (self.centerModel.studyMessageList.count == 0) {
                return CGFLOAT_MIN;
            }
            return 30.0f;
        } else {
            return CGFLOAT_MIN;
        }
    }
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        if ([studymessage isEqualToString:@"on"]) {
            if (self.centerModel.studyMessageList.count == 0) {
                return CGFLOAT_MIN;
            }
            return 10.0f;
        } else {
            return CGFLOAT_MIN;
        }
    } else if (section == 1) {
        return 40.0f;
    } else if (section == 0) {
        return 75.0f;
    } else {
        if ([studynews isEqualToString:@"on"]) {
            if (self.centerModel.newsList.count == 0) {
                return CGFLOAT_MIN;
            }
            return 10.0f;
        } else {
            return CGFLOAT_MIN;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return self.centerModel.studyMessageList.count;
    } else if (section == 3) {
        return self.centerModel.newsList.count;
    } else if (section == 1) {
        return self.dataArray.count;
    } else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        return 185.0f;
    } else  if(indexPath.section == 1){
        if (self.index == 1) {
            return 130.0f;
        } else if (self.index == 3) {
            return 110.0f;
        } else {
            return 100.0f;
        }
    } else if(indexPath.section == 3){
        if ([studynews isEqualToString:@"on"]) {
            if (self.centerModel.newsList.count != 0) {
                return 50.0f;
            }
        }
        return CGFLOAT_MIN;
    } else {
        if ([studymessage isEqualToString:@"on"]) {
            if (self.centerModel.studyMessageList.count != 0) {
                return 60.0f;
            }
        }
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.section == 0){
        static NSString* cellIdentifier = @"StudyHeadCellIdentity";
        StudyHeadCell* cell = (StudyHeadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudyHeadCell" owner:nil options:nil] lastObject];
        }
        cell.delegate = self;
        cell.nameLabel.text = self.infoModel.nickName;
        [cell.headerBtn sd_setImageWithURL:[self.infoModel.userIcon stringToUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
        [cell.scoreBtn setTitle:[NSString stringWithFormat:@"%@ %g", resunit,self.infoModel.learningScore] forState:UIControlStateNormal];
        [cell.scoreBtn setImage:[UIImage imageNamed:@"just_score"] forState:UIControlStateNormal];
        [cell.cerBtn setTitle:[NSString stringWithFormat:@"证书 %ld",self.infoModel.certificateNum] forState:UIControlStateNormal];
        [cell.cerBtn setImage:[UIImage imageNamed:@"just_cer"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _studyHeadCell = cell;
        if (self.centerModel.hasSign) {
            [cell.signedBtn setTitle:@"已签到" forState:UIControlStateNormal];
            cell.signedBtn.layer.borderColor = KMainTextBlack.CGColor;
            [cell.signedBtn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
            cell.signedBtn.backgroundColor = [UIColor clearColor];
            cell.signedBtn.enabled = NO;
        } else {
            cell.signedBtn.enabled = YES;
            [cell.signedBtn setTitle:@"签到" forState:UIControlStateNormal];
            cell.signedBtn.layer.borderColor = [UIColor colorFromHexString:@"ff6e6e"].CGColor;
            [cell.signedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.signedBtn.backgroundColor = [UIColor colorFromHexString:@"ff6e6e"];
        }
        return cell;
    } else if(indexPath.section == 1){
        if (self.index == 1) {
            static NSString *identifier = @"DoingCurriculumCell";
            DoingCurriculumCell *cell = (DoingCurriculumCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DoingCurriculumCell" owner:nil options:nil] lastObject];
            }
            cell.type = 1;
            cell.myCourse = self.dataArray[indexPath.row];
            return cell;
        } else if (self.index == 3) {
            static NSString *identifier = @"specialListCell";
            SpecialListCell *cell = (SpecialListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialListCell" owner:nil options:nil] lastObject];
            }
            cell.list = self.dataArray[indexPath.row];
            return cell;
        } else {
            static NSString* cellIdentifier = @"SpecailListCellIdentity";
            SpecailListCell* cell = (SpecailListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecailListCell" owner:nil options:nil] lastObject];
            }
            cell.model = self.dataArray[indexPath.row];
            return cell;
        }
    } else if(indexPath.section == 3){
        static NSString* cellIdentifier = @" EducationalCellIdentity";
        EducationalHeadCell* cell = (EducationalHeadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationalHeadCell" owner:nil options:nil] lastObject];
        }
        HotNotice *hot = self.centerModel.newsList[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"• %@",hot.title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString* cellIdentifier = @"StudyRemindExtCell";
        StudyRemindExtCell* cell = (StudyRemindExtCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"StudyRemindExtCell" owner:nil options:nil] lastObject];
        }
        StudyMessageList *list = self.centerModel.studyMessageList[indexPath.row];
        cell.lookButton.tag = indexPath.row;
        [cell.lookButton addTarget:self action:@selector(lookStudyClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.remindContent = list.content;
        return cell;
    }
}

-(NSArray *)viewsPage
{
    if (!_viewsPage) {
        NSArray *appArr = [centerfunc componentsSeparatedByString:@","];
        NSMutableArray *app = [NSMutableArray array];
        for (NSInteger i = 0; i < appArr.count; i ++) {
            UIViewController *v = [UIViewController new];
            [app addObject:v];
        }
        _viewsPage = [NSArray arrayWithArray:app];
    }
    return _viewsPage;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        if (self.centerModel.studyMessageList.count != 0) {
            UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
            view.backgroundColor = [UIColor whiteColor];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 3.0, 1.0, 24.0)];
            lineView.backgroundColor = kMainThemeColor;
            [view addSubview:lineView];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10.0, 0, SCREEN_WIDTH - 100.0, 30.0)];
            label.text = @"学习提醒";
            [view addSubview:label];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_WIDTH - 50.0, 0, 30.0, 30.0);
            [btn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
            [view  addSubview:btn];
            return view;
        }
        return nil;
    }
    return nil;
}

#pragma mark ----
- (void)changeSelect:(NSNotification *)note
{
    NSInteger index = [note.userInfo[@"selectedSegmentIndex"] integerValue];
    NSArray *arr = [centerfunc componentsSeparatedByString:@","];
    NSMutableArray *titleArr = [NSMutableArray array];
    NSArray *homeArray = [Tool getAppHomeFunctionModule];
    for(int i= 0;i<arr.count + 1;i ++){
        if (i == arr.count) {
            [titleArr addObject:@"报名中心"];
        } else {
            NSString * str = arr[i];
            if([str isEqualToString:@"1"]){
                [titleArr addObject:homeArray[0]];
            } else if([str isEqualToString:@"2"]){
                [titleArr addObject:homeArray[1]];
            } else  if([str isEqualToString:@"3"]){
                [titleArr addObject:homeArray[2]];
            }  else  if([str isEqualToString:@"4"]){
                [titleArr addObject:homeArray[3]];
            }
        }
    }
    
    if ([titleArr[index] isEqualToString:@"报名中心"]) {
        self.index = 6;
    } else {
        self.index = [arr[index] integerValue];
    }
    
    UITableViewRowAnimation animation;
    if (index > self.selectIndex) {
        animation = UITableViewRowAnimationLeft;
    } else {
        animation = UITableViewRowAnimationRight;
    }
    self.selectIndex = index;
    
    [self.dataArray removeAllObjects];
    if (self.index == 1) {
        [self.dataArray addObjectsFromArray:self.myCoursesList];
    } else if (self.index == 3) {
        [self.dataArray addObjectsFromArray:self.myProgramList];
    } else {
        [self.dataArray addObjectsFromArray:self.mybmList];
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView  reloadSections:indexSet withRowAnimation:animation];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        NSMutableArray *titleArr = [NSMutableArray array];
        NSMutableArray * imageArr = [NSMutableArray array];
        NSArray *arr = [centerfunc componentsSeparatedByString:@","];
        NSArray *homeArray = [Tool getAppHomeFunctionModule];
        for(int i= 0;i<arr.count + 1;i ++){
            if (i == arr.count) {
                [imageArr addObject:@"app_circle"];//报名中心
                [titleArr addObject:@"报名中心"];
            } else {
                NSString * str = arr[i];
                if([str isEqualToString:@"1"]){
                    [imageArr addObject:@"app_learn"];//课程学习
                    [titleArr addObject:homeArray[0]];
                } else if([str isEqualToString:@"2"]){
                    [imageArr addObject:[Tool getLogoNewsImageName]];//资讯
                    [titleArr addObject:homeArray[1]];
                } else  if([str isEqualToString:@"3"]){
                    [imageArr addObject:@"app_special"];
                    [titleArr addObject:homeArray[2]];//专题
                }  else  if([str isEqualToString:@"4"]){
                    [imageArr addObject:@"app_circle"];//学习圈
                    [titleArr addObject:homeArray[3]];
                }
            }
        }
        
        PageControllerView *page = nil;
        if (self.viewsPage.count != 0) {
            page = [[PageControllerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75.0 ) andTitles:titleArr andTitleFontSize:13.0f andImages:imageArr andPageControllers:self.viewsPage andSegmentColor:[UIColor whiteColor]];
            page.segment.selectedSegmentIndex = self.selectIndex;
        }
        
        return page;
    } else if (section == 1) {
        UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0)];
        topView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
        [sender setTitle:@"更多" forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        [sender setTitleColor:KMainTextGray forState:UIControlStateHighlighted];
        sender.backgroundColor = [UIColor whiteColor];
        [sender addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:sender];
        
        return topView;
    }
    return nil;
}

-(void)clickMore
{
    switch (self.index) {
        case 1:{  //课表
            MyCurriculumViewController *vc = [[MyCurriculumViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 2:{//我的资讯
            MyInformationViewController *vc = [MyInformationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 3:{ //我的专题
            SpecialBaseViewController *vc = [[SpecialBaseViewController alloc]initWithPages:@[[MySpecialViewController initWithType:SpecialStateTypeToDo], [MySpecialViewController initWithType:SpecialStateTypeNotDo], [MySpecialViewController initWithType:SpecialStateTypeDone]]];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4:{//学习圈
            FindCircleController* view = (FindCircleController*)[[UIStoryboard storyboardWithName:@"LearnCircle" bundle:nil] instantiateViewControllerWithIdentifier:@"FindCircle"];
            view.isSlideVC = YES;
            view.title = @"我的圈子";
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        } break;
        case 6:{//报名中心
            BmListViewController *vc = [BmListViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 3) {
        HotNotice *hot = self.centerModel.newsList[indexPath.row];
        DynDetailsViewController *vc =[DynDetailsViewController new];
        vc.ID = hot.Id;
        vc.infoModel = [self getModelWithModel:hot];
        vc.isCreateImg = NO;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        if (self.index == 1) {
            CourseStudyViewController *destVc = [CourseStudyViewController new];
            ZSMyCourseInfo *myCourse = _dataArray[indexPath.row];
            destVc.courseId = myCourse.courseId;
            destVc.title = myCourse.courseName;
            destVc.courseCoverString = myCourse.courseIcon;
            [self.navigationController pushViewController:destVc animated:YES];
        } else if (self.index == 3) {
            UserClassList *list = self.dataArray[indexPath.row];
            if (list.type == 1) {
                DistanceTrainingViewController *destVc = [DistanceTrainingViewController new];
                destVc.classId = list.classId;
                [self.navigationController pushViewController:destVc animated:YES];
            } else {
                FaceTeachingViewController *destVc = [FaceTeachingViewController new];
                destVc.classId = list.classId;
                destVc.title = list.className;
                [self.navigationController pushViewController:destVc animated:YES];
            }
        } else {
            //报名中心
            ZSLearnCircleListModel *model = self.dataArray[indexPath.row];
            SpecialDetailViewController *vc = [SpecialDetailViewController new];
            vc.projectId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(DiscoveryInformation*)getModelWithModel:(HotNotice*)model
{
    DiscoveryInformation * infoModel = [[DiscoveryInformation alloc]init];
    infoModel.createDate = model.createDate;
    infoModel.infoId = model.Id;
    infoModel.title = model.title;
    infoModel.viewNum = model.viewNum;
    
    return infoModel;
    
//    @property (nonatomic, copy) NSString *comFrom;//资讯出处
//    @property (nonatomic, copy) NSString *createDate;//发布时间
//    @property (nonatomic, copy) NSString *createUser;//作者
//    @property (nonatomic, copy) NSString *infoId;//资讯ID
//    @property (nonatomic, copy) NSString *img;//课学习圈缩略图 url
//    @property (nonatomic, assign) BOOL joined;// 是否加入
//    @property (nonatomic, copy) NSString *subject;//资讯简述
//    @property (nonatomic, copy) NSString *title;//资讯标题
//    @property (nonatomic, assign) long viewNum;//浏览量
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[Config Instance] isLogin]) {
        [app.LeftSlideVC setPanEnabled:YES];
    } else {
        [app.LeftSlideVC setPanEnabled:NO];
    }
    
    SideslipSingle *side = [SideslipSingle sharedInstance];
    if (side.isSideslip) {
        [app.LeftSlideVC openLeftView];
        side.isSideslip = NO;
    }
    
    [app.homeNav setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:NO];
}

// 个人信息 我的应用 系统消息 学分 学币 积分
-(void)clickStudyHeadCellBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 1:{//个人信息
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (tempAppDelegate.LeftSlideVC.closed) {
                [tempAppDelegate.LeftSlideVC openLeftView];
            } else {
                [tempAppDelegate.LeftSlideVC closeLeftView];
            }
        } break;
        case 2:{//我的应用
            MyApplicationViewController *vc = [MyApplicationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 3:{//系统消息
            SystemMessageViewController * vc = [[SystemMessageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.tableViewHeight = 64.0;
            vc.title = @"系统消息";
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4:{//学分
            MyCreditViewController   * vc = [MyCreditViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 5:{//证书
            MyCertificateViewController *vc = [MyCertificateViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 6:{ //我的个人主页
            IndividualHomepageController *destVc = [[IndividualHomepageController alloc] init];
            destVc.userID = gUserID;
            [self.navigationController pushViewController:destVc animated:YES];
        } break;
        case 7:{
            NSDictionary *dic = @{@"userId":gUserID,};
            [self.request toSignUpOfflineClassWithDict:dic block:^(ZSModel *model, NSError *error) {
                [self hideHud];
                if (model.isSuccess) {
                    [self showHint:model.message];
                    [btn setTitle:@"已签到" forState:UIControlStateNormal];
                    btn.layer.borderColor = KMainTextBlack.CGColor;
                    [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
                    btn.backgroundColor = [UIColor clearColor];
                    btn.enabled = NO;
                } else {
                    [self showHint:model.message];
                }
            }];
        } break;
        default:
          break;
    }
}

#pragma mark --- 查看学习提醒
-(void)lookStudyClick:(UIButton *)sender
{
    StudyMessageList *list = self.centerModel.studyMessageList[sender.tag];
    if (list.type == 1 || list.type == 2 || list.type == 7) {
        //1：班级评论，2：班级公告， 7：用户选班 点击进入 个人班级详细页面
        if ([list.clazzType isEqualToString:@"1"]) {
            FaceTeachingViewController *faceVC = [FaceTeachingViewController new];
            faceVC.classId = list.objectId;
            [self.navigationController pushViewController:faceVC animated:YES];
        } else {
            DistanceTrainingViewController *vc = [DistanceTrainingViewController new];
            vc.classId = list.objectId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (list.type == 3) {//3：项目发布，点进入 个人专题详细页面
        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
        vc.projectId = list.objectId;
        vc.classId = list.clazzId;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (list.type == 4 || list.type == 6) {//4：课程发布，6：用户选课，点击进入个人课程学习页面
        CourseStudyViewController *vc = [CourseStudyViewController new];
        vc.courseId = list.objectId;
        vc.classId = list.clazzId;
        vc.title = @"课程学习";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (list.type == 5) {//消息发布， 点击进入新闻详细页面
        DynDetailsViewController *vc = [DynDetailsViewController new];
        vc.ID = list.objectId;
        vc.isCreateImg = NO;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//8：测验 ，进入班级测验列表 9：作业，进入班级测验列表
//        JobTestViewController *vc = [JobTestViewController new];
//        vc.objectId = list.objectId;
//        vc.type = @"class";
//        if (list.type == 8) {
//            vc.navigationItem.title = @"测验列表";
//        } else {
//            vc.navigationItem.title = @"作业列表";
//        }
//        [self.navigationController pushViewController:vc animated:YES];
        WebViewViewController *vc = [WebViewViewController new];
        if (list.type == 8) {
            vc.urlStr = list.testUrl;
            vc.title = @"测验";
        } else {
            vc.urlStr = list.homeworkUrl;
            vc.title = @"作业";
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark --- 刷新按钮
- (void)refreshClick
{
    [self getData];
}

#pragma mark ---- setupLocation
//获取位置
- (void)setupLocation
{
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:possaveinterval target:self selector:@selector(postLocation) userInfo:nil repeats:YES];
}
#pragma mark ---- AMapLocationManagerDelegate
//定位失败 调用
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"___________%@",error.domain);
}
//#pragma mark ---- 定时开启定位
- (void)postLocation
{
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        //得到经纬度
        NSDictionary * dict = @{
                                @"userId":gUserID,
                                @"latitude":[NSString stringWithFormat:@"%f",location.coordinate.latitude],//纬度
                                @"longitude":[NSString stringWithFormat:@"%f",location.coordinate.longitude],//经度
                                };
        [self.request requestSavePositionDict:dict block:^(ZSModel *model, NSError *error) {
            if (model.isSuccess) {
            }
        }];
    }];
}

-(void)logoutLocation
{
    [_timer invalidate];
    _timer = nil;
}

@end
