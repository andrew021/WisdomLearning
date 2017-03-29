//
//  MyApplicationViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyApplicationViewController.h"
#import "MyApplicationCell.h"
#import "TrainingSeminarViewController.h"
#import "ChooseCourseController.h"

@interface MyApplicationViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) long currentPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation MyApplicationViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的应用";
    
    [self.view addSubview:self.tableView];
    
    [self getData];
    [self createRefresh];
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
    __weak MyApplicationViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
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

#pragma mark --- 获取数据
- (void)getData
{
    self.currentPage = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//@"3295",//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",
                          };
    [self.request requestMyTenantListWithDic:dic block:^(MyTenantListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.currentPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
                self.currentPage ++;
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

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,//用户ID
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentPage],//页码，从1开始，默认1
                          @"perPage":@"10",//每页记录数
                          };
    [self.request requestMyTenantListWithDic:dic block:^(MyTenantListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
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

#pragma mark --- setup TableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MyApplicationCell" bundle:nil] forCellReuseIdentifier:@"myApplicationCell"];
        
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
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
    MyApplicationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myApplicationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.list = self.dataArray[indexPath.row];
    cell.courseBtn.tag = indexPath.row;
    [cell.courseBtn addTarget:self action:@selector(courseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.trainBtn.tag = indexPath.row;
    [cell.trainBtn addTarget:self action:@selector(trainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)courseBtnClick:(UIButton *)sender
{
    MyTenantList * model = self.dataArray[sender.tag];
    ChooseCourseController *destVc = [ChooseCourseController new];
    destVc.tenantId = model.Id;
    [self.navigationController pushViewController:destVc animated:YES];
}
-(void)trainBtnClick:(UIButton *)sender
{
     MyTenantList * model = self.dataArray[sender.tag];
    TrainingSeminarViewController *vc = [TrainingSeminarViewController new];
     vc.tenantId = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
