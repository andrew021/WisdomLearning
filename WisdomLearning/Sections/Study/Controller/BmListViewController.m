//
//  BmListViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 17/1/6.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "BmListViewController.h"
#import "SpecailListCell.h"
#import "SpecialDetailViewController.h"

@interface BmListViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger curPage,totalPages;
@end

@implementation BmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"报名中心";
    
    [self.view addSubview:self.tableView];
    [self getData];  
    [self createRefresh];
}

#pragma mark --- 
- (void)getData
{
    self.curPage = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary * dic = @{
                           @"userId":gUserID,
                           @"curPage":[NSString stringWithFormat:@"%ld",(long)self.curPage],
                           };
    [self.request requestBmCenterList:dic block:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
        [self.dataArray removeAllObjects];
        if (model.isSuccess) {
            [self.dataArray addObjectsFromArray:model.pageData];
            self.totalPages = model.totalPages;
            if (self.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
                self.curPage = self.curPage + 1;
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

- (void)fetchMoreData
{
    if (self.curPage > self.totalPages) {
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,
                          @"curPage":[NSString stringWithFormat:@"%ld",(long)self.curPage],
                          };
    
    [self.request requestBmCenterList:dic block:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            self.curPage = self.curPage + 1;
            [self.tableView reloadData];
        } else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];

}


-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak BmListViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SpecailListCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZSLearnCircleListModel *model = self.dataArray[indexPath.row];
    SpecialDetailViewController *vc = [SpecialDetailViewController new];
    vc.projectId = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
