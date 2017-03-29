//
//  DynamicsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/26.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SearchInfoController.h"
#import "DynHeaderView.h"
#import "DynCell.h"
#import "DynDetailsViewController.h"
#import "ZSDropDownMenu.h"
#import "ZSCategoryListModel.h"
#import <YYKit/YYKit.h>

@interface SearchInfoController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    NSArray<ZSCategoryInfo *> *categories;
}
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign)CGFloat tableViewHeight;
@property (nonatomic, assign)CGFloat tableViewBottom;
@property (nonatomic, strong) NSMutableArray *screenArray, *dataArray;
@property (nonatomic, strong) KLCPopup *menuPopup;
@property (nonatomic, strong) DynHeaderView *headerView;
@property (nonatomic, strong) ZSDropDownMenu *menuView;
@property (nonatomic, copy) NSString *categoryIds, *sortBy;
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation SearchInfoController

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
    self.navigationItem.title = @"发现资讯";
//    if(_key == nil){
//        _key = @"";
//    }
    [self searchFetchData];
    [self createRefresh];
    
 
    [self.view addSubview:self.tableView];
   
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
    __weak SearchInfoController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf searchFetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

-(void)searchFetchData{
    
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
 if(_key !=nil &&_key.length>0){
     
   
    NSDictionary * dic = @{@"name":_key ,@"userId":gUserID,@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize]};
    [self showHudInView:self.view hint:@"加载中..."];
   [self.request requestDiscoveryInformationWithDic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArray removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            _curPage = model.curPage;
            _totalPage = model.totalPages;
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
                self.curPage ++;
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
        }
        else{
            [self showHint:model.message];
            [self.tableView setShowsInfiniteScrolling:NO];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
 }
}



#pragma mark ---- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
       
          _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-_height) style:UITableViewStylePlain];
               _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"DynCell" bundle:nil] forCellReuseIdentifier:@"dynCell"];
         self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
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
    DynCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynCell" forIndexPath:indexPath];
    
    DiscoveryInformation *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
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
    DiscoveryInformation *model = [self.dataArray objectAtIndex:indexPath.row];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DynDetailsViewController *vc =[DynDetailsViewController new];
//    vc.ID = model.infoId;
//    vc.isAdd = NO;
//  
//    vc.height = 60;
//    vc.isCreateImg = NO;
//    
//    [self.navigationController pushViewController:vc animated:YES];
//    
    if(_delegate){
        [self.delegate interactData:model tag:2 data:model.infoId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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



#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    if(_key !=nil &&_key.length>0){
     
    if(_curPage>_totalPage){
        [self.tableView.infiniteScrollingView stopAnimating];
        return [self  showHint:@"已经是最后一页了"];
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)_curPage];
    NSDictionary * dic = @{@"name":_key ,@"userId":gUserID,@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize]};
   [self.request requestDiscoveryInformationWithDic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
          
            self.curPage ++;
            
            [self.tableView reloadData];
        } else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
    }
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
