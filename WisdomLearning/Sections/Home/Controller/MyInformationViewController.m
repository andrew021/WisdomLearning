//
//  MyInformationViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyInformationViewController.h"
#import "InformatCell.h"
#import "DynDetailsViewController.h"
#import "PublishViewController.h"
#import "BidViewController.h"

@interface MyInformationViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource,ComDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) long currentPage;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation MyInformationViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的资讯";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tableView];
    
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [publishBtn setImage:[UIImage imageNamed:@"per_put"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    [self getData];
    [self createRefresh];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak MyInformationViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreData];
    }];
}

#pragma mark --- 获取数据
- (void)getData
{
    self.currentPage = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",
                          };
    [self.request requestMyNewsListWithdic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.currentPage < model.totalPages) {
                self.currentPage ++;
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}
#pragma mark ---- 更多数据 
- (void)getMoreData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",
                          };
    [self.request requestMyNewsListWithdic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.currentPage < model.totalPages) {
                self.currentPage ++;
            }
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark --- 进入发布界面
-(void)publishBtn
{
    BidViewController *vc = [[BidViewController alloc]init];
    vc.delegate = self;
    vc.isAdd = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 发布资讯后重新请求数据
-(void)interactData:(id)sender tag:(int)tag data:(id)data
{
    [self getData];
}


#pragma mark ---- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"InformatCell" bundle:nil] forCellReuseIdentifier:@"informatCell"];
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"informatCell" forIndexPath:indexPath];
    cell.infoModel = self.dataArray[indexPath.row];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DiscoveryInformation *info = self.dataArray[indexPath.row];
    DynDetailsViewController *vc =[DynDetailsViewController new];
  //  vc.isAdd = NO;
 //   CGFloat height = [GetHeight getHeightWithContent:info.title width:SCREEN_WIDTH-30 font:15];
//    if(info.img.length>0){
//        vc.height = 180;
//        vc.isCreateImg = YES;
//    }
//    else{
   //     vc.height = 45+height;
        vc.isCreateImg = NO;
    vc.type = 1;
//    }
    vc.ID = info.infoId;
    vc.infoModel =info;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 暂无数据
- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView{
    UIImage* img = [ThemeInsteadTool imageWithImageName:@"Dia_NoContent"];
    return img;
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -70.0f;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 30.0f;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView{
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.showEmptyView;
}

@end
