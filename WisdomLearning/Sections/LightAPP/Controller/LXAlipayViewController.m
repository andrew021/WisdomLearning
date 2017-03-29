//
//  LXAlipayViewController.m
//  DemoSummary
// //仿支付宝。
//  Created by chuanglong02 on 16/9/20.
//  Copyright © 2016年 chuanglong02. All rights reserved.
//


#import "LXAlipayViewController.h"
#import "AddLightAppController.h"
#import "GridView.h"
#import "GridButton.h"
#import "ChooseCourseController.h"
#import "TrainingSeminarViewController.h"
#import "FindCircleController.h"
#import "CertifiViewController.h"
#import "DynamicsViewController.h"
#import "UIViewController+LoadLoginView.h"


@interface LXAlipayViewController ()<UIScrollViewDelegate,GridViewDelegate,FetchDataLightApp>

@property(nonatomic,strong)GridView *gridView;
@property(nonatomic,strong)UIScrollView *myScrollview;
@property (strong,nonatomic) NSMutableArray * titleArr; // 标题
@property (strong,nonatomic) NSMutableArray * image; // 图片
@property (strong,nonatomic) NSMutableArray * num;//ID
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation LXAlipayViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"轻应用";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollview];
    _dataArr = [[NSMutableArray alloc]init];
    
    self.titleArr = [[NSMutableArray alloc] init];
    self.image = [[NSMutableArray alloc] init];
     self.num = [[NSMutableArray alloc] init];
  
   
    
    [self indirectLoginViewWithLoginSucessBlock:^{
        self.navigationController.navigationBarHidden = NO;
         [self fetchData];
    } andLogoutBlock:^{
        self.navigationController.navigationBarHidden = YES;
        //[self createPagesView];
       // [self fetchData];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:NO];
    }];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFetchData) name:@"getData" object:nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"personal_hearImage"] style:UIBarButtonItemStylePlain target:self action:@selector(personalClick)];
}

-(void)personalClick
{
    //个人信息
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    } else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


-(void)getFetchData{
    if ([[Config Instance] isLogin]) {
        [self fetchData];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[Config Instance] isLogin]) {
        [app.LeftSlideVC setPanEnabled:YES];
    } else {
        [app.LeftSlideVC setPanEnabled:NO];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
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




#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak LXAlipayViewController* weakSelf = self;
    [self.myScrollview addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
}


#pragma mark---请求数据
- (void)fetchData
{
    NSString * str = nil;
    if(gUserID.length == 0){
       str = @"0";
    }
    else{
        str = gUserID;
    }
    NSDictionary * dic = @{@"userId":gUserID};
//    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestMyLightAppListWithDic:dic block:^(ZSLightAppModel *model, NSError *error) {
//        [self hideHud];
        [self.dataArr removeAllObjects];
        [self.image removeAllObjects];
        [self.titleArr removeAllObjects];
        [self.num removeAllObjects];
       
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArr addObjectsFromArray:model.pageData];

            for(int i= 0;i<self.dataArr.count;i++){
                LightAppModel * model = _dataArr[i];
                [self.titleArr addObject:model.name];
              [self.num addObject:model.Id];
           
            
                switch (model.type) {
                    case 1:
                 
                        [self.image addObject:@"app_learn"];
                        break;
                    case 2:
                        [self.image addObject:@"app_info"];
                       
                        break;
                    case 3:
                        [self.image addObject:@"app_special"];
                       
                        break;
                    case 4:
                        [self.image addObject:@"app_circle"];
                        
                        break;
                    case 5:
                        [self.image addObject:@"app_cer"];
                        break;
                        
                    default:
                        break;
            }
       
          
        }
            [self.titleArr addObject:@"添加更多"];
            [self.image addObject:@"app_more"];
            [self.num addObject:@"1005"];
            [self.gridView removeFromSuperview];
            self.gridView =[[GridView alloc]initWithFrame:CGRectMake(0, -64, KScreenW, 200) showGridTitleArray:self.titleArr showImageGridArray:self.image showGridIDArray:self.num];
            self.gridView.backgroundColor = [UIColor whiteColor];
            self.gridView.gridViewDelegate = self;
            [self.myScrollview addSubview:_gridView];
       
            [self.gridView updateNewFrame];
        }
        else{
            [self showHint:model.message];
        }
    
      
    }];
    
    
    
}


-(void)updateHeight:(CGFloat)height
{
    self.gridView.height = height;
    self.myScrollview.contentSize = CGSizeMake(KScreenW, height);
}

-(void)clickGridView:(GridButton *)item
{
 
    
    switch (item.gridId) {
        case 1: //选课
        {
            ChooseCourseController *destVc = [[ChooseCourseController alloc] init];
            [self.navigationController pushViewController:destVc animated:YES];
            
        } break;
        case 3: //培训专题
        {
            TrainingSeminarViewController *vc = [TrainingSeminarViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 4: //学习圈
        {
            FindCircleController* view = (FindCircleController*)[[UIStoryboard storyboardWithName:@"LearnCircle" bundle:nil] instantiateViewControllerWithIdentifier:@"FindCircle"];
            view.isSlideVC = YES;
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        } break;
        case 5: //证书
        {
            CertifiViewController *vc = [CertifiViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 2: //证书
        {
            DynamicsViewController *vc = [DynamicsViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        case 1005: //更多
        {
            AddLightAppController * vc = [[AddLightAppController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
        default:
            break;
    }


}

-(void)deletateButtonTag:(NSInteger)tag
{
 

    
    NSString * str = [NSString stringWithFormat:@"%ld",(long)tag];
    [self showHudInView:self.view hint:@"正在删除..."];
    NSDictionary * dic = @{@"userId":gUserID,@"appId":str,@"type":@"2"};
    
    [self.request requestAddOrReduceLightAppWithDic:dic block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getLightAppData" object:self];
            [self fetchData];
           
        }
        else{
            [self showHint:model.message];
        }
    }];
    



}

- (UIScrollView *)myScrollview {
	if(_myScrollview == nil) {
		_myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        _myScrollview.contentSize = CGSizeMake(KScreenW, KScreenH*2);
        _myScrollview.contentOffset = CGPointMake(0, -64);
        _myScrollview.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        _myScrollview.showsHorizontalScrollIndicator = NO;
        _myScrollview.showsVerticalScrollIndicator = YES;
        _myScrollview.bounces = NO;
        _myScrollview.backgroundColor =[UIColor clearColor];
    }
	return _myScrollview;
}

-(void)fetchDataGetLightApp
{
    [self fetchData];
}

@end
