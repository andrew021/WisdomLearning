//
//  MySpecialViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MySpecialViewController.h"
#import "SpecialListCell.h"
#import "FaceTeachingViewController.h"
#import "DistanceTrainingViewController.h"

@interface MySpecialViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) long currentIndex;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation MySpecialViewController

+(instancetype)initWithType:(SpecialStateType)type
{
    MySpecialViewController *vc = [MySpecialViewController new];
    vc.type = type;
    switch (type) {
        case SpecialStateTypeToDo:
        {
            vc.title = @"进行中";
        }
            break;
        case SpecialStateTypeNotDo:
        {
            vc.title = @"未开始";
        }
            break;
        case SpecialStateTypeDone:
        {
            vc.title = @"已结业";
        }
            break;
        default:
            break;
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self getData];
    [self createRefresh];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 50.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SpecialListCell" bundle:nil] forCellReuseIdentifier:@"specialListCell"];
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specialListCell" forIndexPath:indexPath];
    cell.list = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark --- 获取数据
- (void)getData
{
    self.currentIndex = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
    NSDictionary *dic = @{
                          @"userId":gUserID,//@"1634",//用户ID
                          @"type":type,//1进行中 2未开始 3已结束
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentIndex],//页码
                          @"perPage":@"10",//每页记录数
                          };
    [self.request requestUserClassListWithDic:dic block:^(UserClassListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.currentIndex < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
                self.currentIndex ++;
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
    __weak MySpecialViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *type = [NSString stringWithFormat:@"%ld",self.type];
    NSDictionary *dic = @{
                          @"userId":gUserID,
                          @"type":type,
                          @"curPage":[NSString stringWithFormat:@"%ld",self.currentIndex],
                          @"perPage":@"10",
                          };
    [self.request requestUserClassListWithDic:dic block:^(UserClassListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.currentIndex < model.totalPages) {
                self.currentIndex ++;
            }
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


@end
