//
//  MyCurrencyViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyCurrencyViewController.h"
#import "CreditHeadCell.h"
#import "RechargeViewController.h"
#import "MyCurrencyCell.h"
#import "StudyModel.h"

@interface MyCurrencyViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic,strong) UserStudyinfo * infoModel;
@end

@implementation MyCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的学币";
    self.navigationController.navigationBar.translucent = NO;
    [self setTableView];
    [self setupBarButton];
    
    _dataArr = [[NSMutableArray alloc]init];

    [self createRefresh];
    [self fetchData];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice) name:USERCOINCHANGE object:nil];
    
   
}


//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
//    
//}

-(void)notice
{
   [self fetchData];
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak MyCurrencyViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
//    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf fetchMoreData];
//    }];
}

#pragma mark---请求数据
- (void)fetchData
{
    
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary * dic =@{@"userId":gUserID};
//
//    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.zhisou.studyload", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t dispatchGroup = dispatch_group_create();
//    for (int i = 0; i < 2; i++) {
//        dispatch_group_async(dispatchGroup, dispatchQueue, ^() {
//            dispatch_group_enter(dispatchGroup);
//            if (i == 0) {
//                    [self.request requestMyCurrencyWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
//                        [self hideHud];
//                        self.showEmptyView = YES;
//                        [self.dataArr removeAllObjects];
//                        if(model.isSuccess){
//                            [self.dataArr addObjectsFromArray:model.pageData];
//                        }
//                        else{
//                            [self showHint:model.message];
//                        }
//                        
//                    }];
//
//            } else {
//                [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
//                    if (model.isSuccess) {
//                        self.infoModel = model.data;
//                        dispatch_group_leave(dispatchGroup);
//                    } else {
//                        [self showHint:model.message];
//                    }
//                }];
//            }
//        });
//    }
//    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
//        [self hideHud];
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView reloadData];
//    });
    
    
   // kPageNum = 1;
  //  NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
//    NSDictionary * dic = @{@"userId":gUserID};
//    [self showHudInView:self.view hint:@"加载中..."];
    
    [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
            if (model.isSuccess) {
                        self.infoModel = model.data;
                [self.request requestMyCurrencyWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
                    [self hideHud];
                    [self showHint:model.message];
                    self.showEmptyView = YES;
                    [self.dataArr removeAllObjects];
                    if(model.isSuccess){
                        [self.dataArr addObjectsFromArray:model.pageData];
                    }
                    else{
                        [self showHint:model.message];
                    }
                    [self.tableView.pullToRefreshView stopAnimating];
                    [self.tableView reloadData];
                }];

                              
                } else {
            [self showHint:model.message];
            }
        }];
    
//    [self.request requestMyCurrencyWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
//        [self hideHud];
//        self.showEmptyView = YES;
//        [self.dataArr removeAllObjects];
//        if(model.isSuccess){
//            [self.dataArr addObjectsFromArray:model.pageData];
//        }
//        else{
//            [self showHint:model.message];
//        }
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView reloadData];
//    }];
//    [self.request requestLearnCircleListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
//        [self hideHud];
//        self.showEmptyView = YES;
//        [self.dataArr removeAllObjects];
//        if(model.isSuccess){
//            
//            [self.dataArr addObjectsFromArray:model.pageData];
//            if (self.dataArr.count < kPageSize) {
//                [self.tableView setShowsInfiniteScrolling:NO];
//            }
//            else {
//                [self.tableView setShowsInfiniteScrolling:YES];
//            }
//            NSLog(@"+++ %lu",(unsigned long)_dataArr.count);
//        }
//        else{
//            [self showHint:model.message];
//            [self.tableView setShowsInfiniteScrolling:NO];
//        }
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView reloadData];
//    }];
    
}

//#pragma mark--- 上拉加载更多
//- (void)fetchMoreData
//{
//    kPageNum++;
//    [self showHudInView:self.view hint:@"加载中..."];
//    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
//    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"sortBy":_searchKey};
//    
//    [self.request requestLearnCircleListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
//        [self hideHud];
//        
//        if(model.isSuccess){
//            [self.dataArr addObjectsFromArray:model.pageData];
//            [self.tableView reloadData];
//            
//        }
//        else{
//            [self showHint:model.message];
//            
//        }
//        [self.tableView.infiniteScrollingView stopAnimating];
//        
//    }];
//}
//

#pragma mark--- 创建导航栏右边按钮
-(void)setupBarButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"充值" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
    btn.layer.borderWidth = 1.0f;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 45, 23);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}

-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 120;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
  //  _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
}



- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return 1+_dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{     if(indexPath.row ==0){
   
        static NSString* cellIdentifier = @"CreditHeadCellIdentity";
        CreditHeadCell* cell = (CreditHeadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreditHeadCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headImageView.image = [UIImage imageNamed:@"main_learnCoin"];
    cell.creditLabel.text = [NSString stringWithFormat:@"学币:%.f",self.infoModel.learnCurrency];
        return cell;
    }
    else{
            static NSString* cellIdentifier = @"MyCurrencyCellIdentity";
           MyCurrencyCell* cell = (MyCurrencyCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCurrencyCell" owner:nil options:nil] lastObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _dataArr[indexPath.row-1];
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0){
        return 120;
    }
    return 68;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadClick
{
    RechargeViewController * vc = [[RechargeViewController alloc]init];
    vc.preVC = self;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
