 //
//  FindsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "FindsViewController.h"
#import "CollectionReusableView.h"
#import "LongCollectionViewCell.h"
#import "LongImageCollectionViewCell.h"
#import "TextCollectionViewCell.h"
#import "SDCycleScrollView.h"
#import "ButtonWithIcon.h"
#import "TrainingSeminarViewController.h"
#import "SpecialDetailViewController.h"
#import "LoginController.h"
#import "ChooseCourseController.h"
#import "CourseStudyViewController.h"
#import "FindCircleController.h"
#import "SearchViewController.h"
#import "JZSearchBar.h"
#import "LeanCircleDetailController.h"
#import "LoginController.h"
#import "CertifiViewController.h"
#import "CertificateDetailViewController.h"
#import "DynamicsViewController.h"
#import "DynDetailsViewController.h"
//#import <AMapLocationKit/AMapLocationKit.h>
#import "ZSSegmentImageText.h"
#import "SDScanViewController.h"
#import "UIViewController+LoadLoginView.h"
#import "PersonalDetailsViewController.h"
#import "WebLoginViewController.h"
#import "SpecialDetailViewController.h"

extern NSString *gHost;
extern NSString *gIMHost;
extern NSString *imguploadurl;
extern NSString *outscanewm;
extern NSString *innerscanewm;
extern NSString *studymessage;
extern NSString *studynews;
extern NSString *orderform;
extern NSString *lmsurl;
extern NSString *homeworkSavePath;

@interface FindsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate, ZSSegmentImageTextDelegate,UISearchBarDelegate,UITextFieldDelegate,SDScanViewDelegate>//,AMapLocationManagerDelegate>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) LoginController * loginCtrl;
@property (nonatomic, strong) JZSearchBar* searchBar;
//@property (nonatomic, strong)AMapLocationManager *locationManager;
@property (nonatomic, strong) HomePage *page;
//@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic) SDScanViewController *scanView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *personalInfoButton;
@end

@implementation FindsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.navigationItem.title = [[[Tool getAppMenuName] componentsSeparatedByString:@","] firstObject];
    
//    [self loadLoginViewWithLoginSucessBlock:^{
//        self.navigationController.navigationBarHidden = NO;
//       // self.navigationController.toolbarHidden = NO;
//        [self createRefresh];
////        [self setupLocation];//创建定位
//        [self getHomePageData];
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app.LeftSlideVC setPanEnabled:YES];
//
//    } andLogoutBlock:^{
//        self.navigationController.navigationBarHidden = YES;
//       // self.navigationController.toolbarHidden = YES;
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app.LeftSlideVC setPanEnabled:NO];
//    }];
//
//    if ([[Config Instance] isLogin]) {
//        [self createRefresh];
////        [self setupLocation];//创建定位
//        [self getHomePageData];
//    }
    
    [self homepageLogoutWithBlock:^{
        self.navigationController.navigationBarHidden = YES;
        // self.navigationController.toolbarHidden = YES;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:NO];
        [_personalInfoButton removeFromSuperview];
    }];
    
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:NO];
    [self createRefresh];
    [self getHomePageData];
}

//搜索
-(void)searchAction{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchAll;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
    if ([Config Instance].isLogin) {
        [self.navigationView addSubview:_personalInfoButton];
        
        [app.LeftSlideVC setPanEnabled:YES];
        
    }else{
        [_personalInfoButton removeFromSuperview];
    }
    
   
    
    SideslipSingle *side = [SideslipSingle sharedInstance];
    if (side.isSideslip) {
        [app.LeftSlideVC openLeftView];
        side.isSideslip = NO;
    }

}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:NO];
}

-(void)scanAction
{
    _scanView = [[SDScanViewController alloc] init];
    _scanView.theScanDelegate = self;
    [self.navigationController pushViewController:_scanView animated:YES];
}


-(NSMutableArray *)titleArray
{
    
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

-(UIView *) navigationView
{
    if (!_navigationView) {
        _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64.0)];
        _navigationView.backgroundColor = kMainThemeColor;
        
        _personalInfoButton = [[UIButton alloc]initWithFrame:CGRectMake(10.0, 30.0, 30.0, 30.0)];
        [_personalInfoButton setImage:[UIImage imageNamed:@"personal_hearImage"] forState:UIControlStateNormal];
        [_personalInfoButton setImage:[UIImage imageNamed:@"personal_hearImage"] forState:UIControlStateHighlighted];
        [_personalInfoButton addTarget:self action:@selector(personalClick) forControlEvents:UIControlEventTouchUpInside];
        if ([Config Instance].isLogin) {
            [_navigationView addSubview:_personalInfoButton];
        }
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - 30.0, 34.0, 60.0, 20.0)];
        titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
        titleLabel.text = self.navigationItem.title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_navigationView addSubview:titleLabel];
        
        UIButton *searchSender = [[UIButton alloc]initWithFrame:CGRectMake(_navigationView.width - 80.0, 30.0, 30.0, 30.0)];
        [searchSender setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        [searchSender setImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
        [searchSender addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:searchSender];
        
        UIButton *scanSender = [[UIButton alloc]initWithFrame:CGRectMake(_navigationView.width - 40.0, 30.0, 30.0, 30.0)];
        [scanSender setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        [scanSender setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateHighlighted];
        [scanSender addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:scanSender];
    }
    return _navigationView;
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak FindsViewController* weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf getHomePageData];
    }];
}

- (void)getHomePageData
{
    [self.titleArray removeAllObjects];
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestHomePageUserId:gUserID block:^(HomePageModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            self.page = model.data;
            NSArray *arr = [indexfunc componentsSeparatedByString:@","];
            [_titleArray addObject:@""];
            NSArray *homeArray = [Tool getAppHomeFunctionModule];
            for (NSInteger i = 0; i < arr.count; i ++ ) {
                NSInteger index = [arr[i] integerValue];
                [_titleArray addObject:homeArray[index - 1]];
            }
            [self.navigationView removeFromSuperview];
            [self.collectionView removeFromSuperview];
            
            [self.view addSubview:self.navigationView];
            [self.view addSubview:self.collectionView];
//            _titleArray = [NSMutableArray arrayWithObjects:@"",@"猜你喜欢", @"推荐课程", @"推荐学习圈", @"推荐专题", @"推荐证书", @"教育动态", nil];
            [self.collectionView reloadData];
        } else {
            
            [self showHint:model.message];
        }
         [self.collectionView.pullToRefreshView stopAnimating];
    }];
}

//-(void)getLightApp{
//    
//    [self fetchData];
//    
//}

#pragma mark---请求数据


#pragma mark --- 创建搜索
- (void)initSearchVC
{
    self.searchBar = [JZSearchBar searchBar];
    self.searchBar.delegate = self;
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *settingDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][identifier];
    
    BOOL isSearchAll = settingDict[@"isSearchAll"];
    if(isSearchAll){
        self.searchBar.placeholder = @"搜课程,资讯,专题";
    }
    else{
        self.searchBar.placeholder = @"搜课程,资讯,学习圈,证书,专题";
    }
   
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.frame = CGRectMake(10, 0, SCREEN_WIDTH - 70, 30);
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark --- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchAll;
    [self.navigationController pushViewController:VC animated:YES];
    return NO;
}

#pragma mark ---
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    SearchViewController * VC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    return NO;
}



-(void)personalClick
{
    //个人信息
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    } else {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }

}

//- (void)loginSuccess{
//
//    [self getHomePageData];
//    [self setupLocation];//创建定位
//}
//
//-(void)loginOut{
//    
//}

//-(void)toLogin{
//    if (!_loginCtrl) {
//        _loginCtrl  = [[LoginController alloc]init];
//    }
//    
//    _loginCtrl = [[LoginController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loginCtrl];
//    [self presentViewController:nav animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---   创建collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64.0, SCREEN_WIDTH, SCREEN_HEIGHT - 113.0) collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = 1.0;
        flowLayout.minimumInteritemSpacing = 1.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LongCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"longCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"LongImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"longImageCollectionViewCell"];
        [_collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        [_collectionView registerNib:[UINib nibWithNibName:@"TextCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"textCollectionViewCell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableFooterView"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _collectionView;
}

#pragma mark ---  UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    if (section == 0) {
        return 1;
    } else {
        NSInteger index = [arr[section - 1] integerValue];
        if (index == 4 || index == 2) {
            if (index == 2) {
                return self.page.tjNewsList.count;
            }
            return 0;
        } else {
            if (index == 1) {
                return self.page.tjCourseList.count;
            } else if (index == 3) {
                return self.page.tjProgramList.count;
            } else {
                return 0;
            }

        }
    }
    
//    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
//    if (section == 3 || section == 6) {
//        return [identifier isEqualToString:@"com.witfore.xxapp.wxjy"] ? (section == 3 ? 0 : 3) : 3;
//    } else if (section == 0) {
//        return 1;
//    } else {
//        return [identifier isEqualToString:@"com.witfore.xxapp.wxjy"] ? (section == 5 ? 0 : 4) : 4;
//    }
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        NSMutableArray * imageArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.page.bannerList.count; i++) {
            BannerList * list = self.page.bannerList[i];
            [imageArray addObject:[list.imageUrl stringToUrl]];
        }
        SDCycleScrollView *bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -1.0, SCREEN_WIDTH, 126.0) delegate:self placeholderImage:kPlaceDefautImage];
        bannerView.imageURLStringsGroup = imageArray;
        bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.currentPageDotColor = kMainThemeColor;
        bannerView.pageDotColor = [UIColor grayColor];
        [cell addSubview:bannerView];
        
        NSMutableArray * titleArr = [[NSMutableArray alloc]init];
        NSMutableArray * imageArr = [[NSMutableArray alloc]init];
        NSArray *arr = [indexfunc componentsSeparatedByString:@","];
        NSArray *homeArray = [Tool getAppHomeFunctionModule];
        for(int i= 0;i<arr.count;i++){
            NSString * str = arr[i];
            if([str isEqualToString:@"1"]){
                [imageArr addObject:@"app_learn"];//课程学习
                [titleArr addObject:homeArray[0]];
            } else if([str isEqualToString:@"2"]){
                [imageArr addObject:[Tool getLogoNewsImageName]];
                [titleArr addObject:homeArray[1]];
            } else  if([str isEqualToString:@"3"]){
                [imageArr addObject:@"app_special"];
                [titleArr addObject:homeArray[2]];//专题
            }  else  if([str isEqualToString:@"4"]){
                [imageArr addObject:@"find_circle"];//学习圈1
                [titleArr addObject:homeArray[3]];
            } else  if([str isEqualToString:@"5"]) {
                [imageArr addObject:@"find_cer"];//证书
                [titleArr addObject:homeArray[4]];
            }
        }
        
        ZSSegmentImageText *segment = [[ZSSegmentImageText alloc] initWithFrame:CGRectMake(0, ViewMaxY(bannerView) + 10.0, SCREEN_WIDTH, 80.0) andImages:imageArr andImageWidth:35.0 andImgHeight:35.0 andTitles:titleArr andTitleSize:14];
        segment.theDelegate = self;
        [cell addSubview:segment];
        return cell;
    } else {
        NSArray *arr = [indexfunc componentsSeparatedByString:@","];
        NSInteger index = [arr[indexPath.section - 1] integerValue];
        if (index == 2 || index == 4) {
            TextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            if (index == 2) {
                TjNewsList * list = self.page.tjNewsList[indexPath.item];
                [cell.avatarImage sd_setImageWithURL:[list.newsIcon stringToUrl] placeholderImage:kPlaceDefautImage];
                cell.titleLabel.text = list.newsTitle;
                cell.textLabel.text = list.newsPubDateTime;
            } else {
                
            }
            return cell;
        } else {
            if (index == 3) {
                LongImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"longImageCollectionViewCell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor whiteColor];
                TjProgramList *list = self.page.tjProgramList[indexPath.item];
                [cell.headerImage sd_setImageWithURL:[list.programIcon stringToUrl] placeholderImage:kPlaceDefautImage];
                cell.titleLabel.text = list.programName;
                return cell;
            } else {
                LongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"longCollectionViewCell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor whiteColor];
                if (index == 1) {
                    TjCourseList * list = self.page.tjCourseList[indexPath.item];
                    [cell.headerImage sd_setImageWithURL:[list.courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
                    cell.titleLabel.text = list.courseName;
                } else {
                    
                }
                return cell;
            }
            
//            LongCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"longCollectionViewCell" forIndexPath:indexPath];
//            cell.backgroundColor = [UIColor whiteColor];
//            if (index == 1) {
//                TjCourseList * list = self.page.tjCourseList[indexPath.item];
//                [cell.headerImage sd_setImageWithURL:[list.courseIcon stringToUrl] placeholderImage:kPlaceDefautImage];
//                cell.titleLabel.text = list.courseName;
//            } else if (index == 3) {
//                TjProgramList *list = self.page.tjProgramList[indexPath.item];
//                [cell.headerImage sd_setImageWithURL:[list.programIcon stringToUrl] placeholderImage:kPlaceDefautImage];
//                cell.titleLabel.text = list.programName;
//            } else {
//                
//            }
//            return cell;
        }
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        reusableView.titleLabel.text = _titleArray[indexPath.section];
        reusableView.moreBtn.tag = indexPath.section;
        [reusableView.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return reusableView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableFooterView" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return reusableView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGSizeMake(SCREEN_WIDTH, 0) : CGSizeMake(SCREEN_WIDTH, 30.0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 10.0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 230.0);
    } else {
        NSInteger index = [arr[indexPath.section - 1] integerValue];
        CGFloat width = (SCREEN_WIDTH - 2)/3.0;
        if (index == 4 || index == 2) {
            return CGSizeMake(SCREEN_WIDTH, 85.0);
        } else {
            return index == 3 ? CGSizeMake((SCREEN_WIDTH - 1)/2.0, 150.0) : CGSizeMake(width, (width * 4.0)/3.0);
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    NSInteger index = [arr[indexPath.section - 1] integerValue];
    
    switch (index) {
        case 1: {//课程
            TjCourseList *list = self.page.tjCourseList[indexPath.item];
            CourseStudyViewController *vc = [CourseStudyViewController new];
            vc.courseId = list.courseId;
            vc.title = list.courseName;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 2: {//教育动态
            TjNewsList *list = self.page.tjNewsList[indexPath.item];
            DynDetailsViewController *vc =[DynDetailsViewController new];
            vc.ID = list.newsId;
            vc.isCreateImg = NO;
            vc.type = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 3: {//专题
            TjProgramList * list = self.page.tjProgramList[indexPath.item];
            SpecialDetailViewController *vc = [SpecialDetailViewController new];
            vc.projectId = list.programId;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4: {//学习圈
//            LeanCircleDetailController * detail = [[LeanCircleDetailController alloc]init];
//            detail.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:detail animated:YES];
        } break;
        case 5: {//证书
//            CertificateDetailViewController *vc = [CertificateDetailViewController new];
//            vc.cerId = list.objectId;
//            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
    
//    NSLog(@"%ld____%ld",indexPath.section,indexPath.item);
//    switch (indexPath.section) {
//        case 1:{//猜你喜欢
//            LikeList * list = self.page.likeList[indexPath.item];
//            switch (list.objectType) {
//                case 1: {
//                    StudyCourseController *vc = [StudyCourseController new];
//                    vc.courseId = list.objectId;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } break;
//                case 2: {
//                    DynDetailsViewController *vc =[DynDetailsViewController new];
//                    vc.ID = list.objectId;
//                  //  vc.isAdd = NO;
////                    CGFloat height = [GetHeight getHeightWithContent:list.title width:SCREEN_WIDTH-30 font:15];
//                 //   vc.height = 45+height;
//                    vc.isCreateImg = NO;
//                    vc.type = 1;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } break;
//                case 3: {
//                    SpecialDetailViewController *vc = [SpecialDetailViewController new];
//                    vc.projectId = list.objectId;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } break;
//                case 4: {
//                    LeanCircleDetailController * detail = [[LeanCircleDetailController alloc]init];
//                    detail.hidesBottomBarWhenPushed = YES;
//                    detail.proId = list.objectId;
//                    [self.navigationController pushViewController:detail animated:YES];
//                } break;
//                case 5: {
//                    CertificateDetailViewController *vc = [CertificateDetailViewController new];
//                    vc.cerId = list.objectId;
//                    [self.navigationController pushViewController:vc animated:YES];
//                } break;
//                default:
//                    break;
//            }
//            
//        }break;
//        case 2:{//推荐课程
//            TjCourseList *list = self.page.tjCourseList[indexPath.item];
//            StudyCourseController *vc = [StudyCourseController new];
//            vc.courseId = list.courseId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }break;
//        case 3:{//推荐学习圈
////            LeanCircleDetailController * detail = [[LeanCircleDetailController alloc]init];
////            detail.hidesBottomBarWhenPushed = YES;
////            [self.navigationController pushViewController:detail animated:YES];
//        }break;
//        case 4:{//推荐专题
//            TjProgramList * list = self.page.tjProgramList[indexPath.item];
//            SpecialDetailViewController *vc = [SpecialDetailViewController new];
//            vc.projectId = list.programId;
//            [self.navigationController pushViewController:vc animated:YES];
//        }break;
//        case 5:{//推荐证书
////            CertificateDetailViewController *vc = [CertificateDetailViewController new];
////            vc.cerId = list.objectId;
////            [self.navigationController pushViewController:vc animated:YES];
//        }break;
//        case 6:{//教育动态
//            TjNewsList *list = self.page.tjNewsList[indexPath.item];
//            DynDetailsViewController *vc =[DynDetailsViewController new];
//            vc.ID = list.newsId;
//        //    vc.isAdd = NO;
////            CGFloat height = [GetHeight getHeightWithContent:list.newsTitle width:SCREEN_WIDTH-30 font:15];
//            //
////            vc.height = 45+height;
//            vc.isCreateImg = NO;
//            vc.type = 1;
//            [self.navigationController pushViewController:vc animated:YES];
//            }break;
//            
//        default:
//            break;
//    }
}

#pragma mark ---  点击更多按钮
- (void) moreBtnClick:(UIButton *)sender
{
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    NSInteger index = [arr[sender.tag - 1] integerValue];
    switch (index) {
        case 1: {//课程
            ChooseCourseController *destVc = [[ChooseCourseController alloc] init];
            [self.navigationController pushViewController:destVc animated:YES];
        } break;
        case 2: {//教育动态
            DynamicsViewController *vc = [DynamicsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 3: {//专题
            TrainingSeminarViewController *vc = [TrainingSeminarViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4: {//学习圈
            FindCircleController* view = (FindCircleController*)[[UIStoryboard storyboardWithName:@"LearnCircle" bundle:nil] instantiateViewControllerWithIdentifier:@"FindCircle"];
            view.hidesBottomBarWhenPushed = YES;
            view.isSlideVC = YES;
            [self.navigationController pushViewController:view animated:YES];
        } break;
        case 5: {//证书
            CertifiViewController *vc = [CertifiViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }
}
/** 点击滑动视图图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerList *list = self.page.bannerList[index];
    if (list.programId.length == 0) {
        DynDetailsViewController *vc =[DynDetailsViewController new];
        vc.ID = list.articleId;
        vc.isCreateImg = NO;
        vc.type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (list.joined) {
            PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
            vc.projectId = list.programId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            SpecialDetailViewController *vc = [SpecialDetailViewController new];
            vc.projectId = list.programId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
//#pragma mark ---  buton 高亮时背景加深
//- (UIImage*)imageWithColor:(UIColor*)color
//{
//    CGRect rect = CGRectMake(0.0, 0, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndPDFContext();
//    return image;
//}
#pragma mark ---    点击四个按钮的方法
-(void)clickImageText:(NSInteger)index
{
    NSArray * arr = [indexfunc componentsSeparatedByString:@","];
    NSString * str = arr[index];
    if([str isEqualToString:@"1"]){
        ChooseCourseController *destVc = [[ChooseCourseController alloc] init];
        [self.navigationController pushViewController:destVc animated:YES];
    } else if([str isEqualToString:@"2"]){
        
        DynamicsViewController *vc = [DynamicsViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else  if([str isEqualToString:@"3"]){
        TrainingSeminarViewController *vc = [TrainingSeminarViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else  if([str isEqualToString:@"4"]){
        FindCircleController* view = (FindCircleController*)[[UIStoryboard storyboardWithName:@"LearnCircle" bundle:nil] instantiateViewControllerWithIdentifier:@"FindCircle"];
        view.isSlideVC = YES;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
    else{
        CertifiViewController *vc = [CertifiViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --SDScanViewDelegate
-(void)scannedString:(NSString *)result{
//    NSRange range = [result rangeOfString:@":"];
    NSRange range1 = [result rangeOfString:@"bm:"];
    NSRange range2 = [result rangeOfString:@"applogin:"];
    if (range1.location != NSNotFound || range2.location != NSNotFound) {
        [_scanView.session stopRunning];
        NSRange range = [result rangeOfString:@":"];
        NSString *type = [result substringToIndex:range.location];
        NSString *sub = [result substringFromIndex:range.location+1];
        NSString *code = [[sub substringToIndex:sub.length - 1] substringFromIndex:1];
        if ([type isEqualToString:@"bm"]) {  //报名
            NSDictionary * dict = @{
                                    @"userId":gUserID,
                                    @"phaseId":code,
                                    };
            [self.request requestDetermineWhetherToParticipate:dict block:^(ProjectMetricModel *model, NSError *error) {
                if (model.isSuccess) {
                    [self showHint:model.message];
                    ProjectMetric *project = model.data;
                    if (project.isReg) {  //如果已经报名了，则跳到个人详情页面
                        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
                        vc.projectId = code;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{  //没有报名，则跳到项目详情页面
                        SpecialDetailViewController *vc = [SpecialDetailViewController new];
                        vc.projectId = code;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                } else {
                    [self showHint:model.message];
                }
            }];
        } else if ([type isEqualToString:@"applogin"]) { //登录
            WebLoginViewController *destVc = [[WebLoginViewController alloc] init];
            destVc.ranCode = code;
            [self.navigationController pushViewController:destVc animated:YES];
        }
        
    }else{
        [_scanView.session startRunning];
    }
}

//#pragma mark ---- setupLocation
////获取位置
//- (void)setupLocation
//{
//    self.locationManager = [[AMapLocationManager alloc]init];
//    self.locationManager.delegate = self;
//    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:possaveinterval target:self selector:@selector(postLocation) userInfo:nil repeats:YES];
//}
//#pragma mark ---- AMapLocationManagerDelegate
////定位失败 调用
//- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"___________%@",error.domain);
//}
////#pragma mark ---- 定时开启定位
//- (void)postLocation
//{
//    [self.locationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//        //得到经纬度
//        NSDictionary * dict = @{
//                                @"userId":gUserID,
//                                @"latitude":[NSString stringWithFormat:@"%f",location.coordinate.latitude],//纬度
//                                @"longitude":[NSString stringWithFormat:@"%f",location.coordinate.longitude],//经度
//                                };
//        [self.request requestSavePositionDict:dict block:^(ZSModel *model, NSError *error) {
//            if (model.isSuccess) {
//            }
//        }];
//    }];
//}
//
//-(void)logoutLocation
//{
//    [_timer invalidate];
//    _timer = nil;
//}


@end
