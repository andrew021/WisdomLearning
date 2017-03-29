//
//  MyOrderViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderCell.h"
#import "CourseStudyViewController.h"
#import "DistanceTrainingViewController.h"
#import "FaceTeachingViewController.h"
#import "MyCurrencyViewController.h"
#import "OrderConfirmCOntroller.h"
#import "RechargeViewController.h"
#import "OrderDetailViewController.h"

@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, assign) long currentPage,totalPages;
@property(nonatomic, assign) BOOL showEmptyView;
@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的订单 ";
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tableView];
    
    [self getData];
    [self createRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark ----  获取数据
- (void)getData
{
    self.currentPage = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//@"1063",//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",//每页记录数
                          };
    [self.request requestMyOrderformListWithdic:dic block:^(MyOrderformListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            self.totalPages = model.totalPages;
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
    if (self.currentPage > self.totalPages) {
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",//每页记录数
                          };
    [self.request requestMyOrderformListWithdic:dic block:^(MyOrderformListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            self.currentPage ++;
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak MyOrderViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreData];
    }];
}


#pragma mark ---- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"myOrderCell"];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myOrderCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.list = self.dataArray[indexPath.row];
    MyOrderformList * list = self.dataArray[indexPath.row];
    cell.clickBtn.tag = indexPath.row;
    if (list.status == 1) {
        cell.clickBtn.enabled = YES;
        [cell.clickBtn addTarget:self action:@selector(clivk:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.clickBtn.enabled = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderformList *list = self.dataArray[indexPath.row];
    OrderDetailViewController *destVc = [[OrderDetailViewController alloc] init];
    destVc.detailUrl = list.detailUrl;
    [self.navigationController pushViewController:destVc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderformList * list = self.dataArray[indexPath.row];
    CGFloat height = [GetHeight getHeightWithContent:list.name width:SCREEN_WIDTH - 20.0 font:15.0f];
    return 85.0 + height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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

-(void)clivk:(UIButton *)sender
{
//    //继续支付
//    return;
    
    MyOrderformList * list = self.dataArray[sender.tag];
    NSDictionary *dict = @{@"orderNo":list.orderNo};
    NSInteger payPath = -1;
    UIViewController *destVC = nil;
    if ([list.payPath isEqualToString:@"ali"]) {
        payPath = 0;
    }else if ([list.payPath isEqualToString:@"wx"]){
        payPath = 1;
    }else if ([list.payPath isEqualToString:@"union"]){
        payPath = 2;
    }
    if ([list.bussType isEqualToString:@"course"]) {
        CourseStudyViewController *vc = [CourseStudyViewController new];
        vc.courseId = list.courseId;
        vc.title = list.name;
        vc.classId = list.clazzId;
        destVC = vc;
    } else if ([list.bussType isEqualToString:@"sign"]) {
        if (list) {
            DistanceTrainingViewController *vc = [DistanceTrainingViewController new];
            vc.classId = list.clazzId;
            destVC = vc;
        } else {
            FaceTeachingViewController *vc = [FaceTeachingViewController new];
            vc.classId = list.clazzId;
            destVC = vc;
        }
    } else if ([list.bussType isEqualToString:@"put"]) {
        MyCurrencyViewController *vc = [MyCurrencyViewController new];
        destVC = vc;
    }
    
    if (destVC != nil && payPath != -1) {
        [[ZSPay instance] payCourseWithPayType:list.payPath andFromAward:NO andDataDicitonary:dict andViewController:self successBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:USERCOINCHANGE object:nil];
            [self.navigationController pushViewController:destVC animated:YES];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
