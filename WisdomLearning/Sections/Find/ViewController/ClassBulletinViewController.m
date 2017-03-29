//
//  ClassBulletinViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassBulletinViewController.h"
#import "ClassBulletinCell.h"
#import "DynDetailsViewController.h"

@interface ClassBulletinViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) long totalPages,curPage;
@end

@implementation ClassBulletinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"通知消息";

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

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark---创建刷新
- (void)createRefresh
{
    __weak ClassBulletinViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf getMoreData];
    }];
}

-(void)getData
{
    self.curPage = 1;
    [self.dataArray removeAllObjects];
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dict = @{
                           @"clazzId":self.clazzId,
                           @"curPage":[NSString stringWithFormat:@"%ld",self.curPage],
                           @"perPage":@"10",
                           @"userId":gUserID,
                           @"isNew":@"0",
                           };
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestClassNoticeList:dict block:^(ClassNoticeListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self.dataArray addObjectsFromArray:model.pageData];
            [self showHint:model.message];
            self.totalPages = model.totalPages;
            if (self.curPage < self.totalPages) {
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

-(void)getMoreData
{
    if (self.curPage > self.totalPages) {
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    NSDictionary *dict = @{
                           @"clazzId":self.clazzId,
                           @"curPage":[NSString stringWithFormat:@"%ld",self.curPage],
                           @"perPage":@"10",
                           @"userId":gUserID,
                           @"isNew":@"0",
                           };
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestClassNoticeList:dict block:^(ClassNoticeListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            self.curPage = self.curPage + 1;
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ClassBulletinCell" bundle:nil] forCellReuseIdentifier:@"classBulletinCell"];
    }
    return _tableView;
}

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
    ClassBulletinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classBulletinCell" forIndexPath:indexPath];
    ClassNoticeList * list = self.dataArray[indexPath.row];
    cell.titleLabel.text = list.title;
    cell.contentLabel.text = list.content;
    if (list.joined) {
        cell.lookButton.layer.borderColor = KMainTextGray.CGColor;
        [cell.lookButton setTitleColor:KMainTextGray forState:UIControlStateNormal];
        [cell.lookButton setTitle:@"已查看" forState:UIControlStateNormal];
    } else {
        [cell.lookButton setTitle:@"请查看" forState:UIControlStateNormal];
        cell.lookButton.layer.borderColor = kMainThemeColor.CGColor;
        [cell.lookButton setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lookButton.tag = indexPath.row;
    [cell.lookButton addTarget:self action:@selector(lookButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
    ClassNoticeList * list = self.dataArray[indexPath.row];
    CGFloat height = [GetHeight getHeightWithContent:list.content width:SCREEN_WIDTH - 80.0 font:13.0f];
    return 60.0 + height;
}

-(void)lookButtonClick:(UIButton *)sender
{
    ClassNoticeList * list = self.dataArray[sender.tag];
    DynDetailsViewController *vc =[DynDetailsViewController new];
    vc.ID = list.noticeId;
   // vc.isAdd = NO;
  //  CGFloat height = [GetHeight getHeightWithContent:list.title width:SCREEN_WIDTH-30 font:15];
    //
  //  vc.height = 45+height;
    vc.isCreateImg = NO;
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
