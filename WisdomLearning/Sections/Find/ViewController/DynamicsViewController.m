//
//  DynamicsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/26.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "DynamicsViewController.h"
#import "DynHeaderView.h"
#import "DynCell.h"
#import "DynDetailsViewController.h"
#import "ZSMultiselectMenuView.h"
#import "ZSCategoryListModel.h"
#import <YYKit/YYKit.h>

@interface DynamicsViewController ()<UITableViewDataSource, UITableViewDelegate,DynHeaderViewDelegate,ZSMultiselectMenuViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
{
    NSArray<ZSCategoryInfo *> *categories;
}
@property (nonatomic, strong) NSMutableArray <ZSCategoryInfo *> *selectCategories;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign)CGFloat tableViewHeight;
@property (nonatomic, assign)CGFloat tableViewBottom;
@property (nonatomic, strong) NSMutableArray *screenArray, *dataArray;
@property (nonatomic, strong) KLCPopup *menuPopup;
@property (nonatomic, strong) DynHeaderView *headerView;
@property (nonatomic, strong) ZSMultiselectMenuView *menuView;
@property (nonatomic, copy) NSString *categoryIds, *sortBy;
@property (nonatomic, assign) long curPage,total;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation DynamicsViewController

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
     NSArray *homeArray = [Tool getAppHomeFunctionModule];
    self.navigationItem.title = homeArray[1];
    self.sortBy = @"";
    self.categoryIds = @"";
    self.curPage = 1;

    _screenArray = [NSMutableArray arrayWithObjects:@"全部资讯", @"浏览量", @"时间", nil];
    categories = [[Config Instance] getNewCategories];
    self.selectCategories = [NSMutableArray array];
    ZSCategoryInfo *info = [ZSCategoryInfo new];
    info.id = @"";
    info.name = @"全部资讯";
    info.busCount = @"0";
    info.childCount = @"0";
    info.subs = [NSMutableArray arrayWithCapacity:0];
    [self.selectCategories addObject:info];
    
    [self getDataWithCategoryIds:self.categoryIds sortBy:self.sortBy];
    [self createRefresh];
    
    if(!_isTabbarHide){
        _tableViewHeight = 41;
        _tableViewBottom = 0;
        //筛选部分
        [self setupScreenView];
    } else{
        _tableViewHeight =0;
        _tableViewBottom = 90;
    }
    [self.view addSubview:self.tableView];
    [self setupUI];
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
    __weak DynamicsViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getDataWithCategoryIds:weakSelf.categoryIds sortBy:weakSelf.sortBy];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark --- 顶部view
-(void)setupUI{
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark ---- 筛选部分
 - (void) setupScreenView
{
    self.headerView = [[DynHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41) titleArray:_screenArray];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
}

-(void)doSearch:(UIButton *)sender{
    //跳转到搜索界面
    SearchViewController * vc = [[SearchViewController alloc]init];
    vc.type = SearchInformation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---  DynHeaderViewDelegate
-(void)clickRepons:(UIButton *)sender asc:(NSInteger)asc
{
    if (sender.tag == 0) {
        _menuView = [[ZSMultiselectMenuView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 110.0) andItemsArray:categories selectItemsArray:self.selectCategories];
        _menuView.theDelegate = self;
        
        self.menuPopup = [KLCPopup popupWithContentView:_menuView];
        [self.menuPopup showAtCenter:CGPointMake(self.view.width/2.0, (SCREEN_HEIGHT - 25.0)/2.0) inView:self.view];
    } else {
        if (sender.tag == 1){
            if (asc == 1) {
                self.sortBy = @"hot:asc";
            } else {
                self.sortBy = @"hot:desc";
            }
        } else {
            if (asc == 1) {
                self.sortBy = @"date:asc";
            } else {
                self.sortBy = @"date:desc";
            }
        }
        [self getDataWithCategoryIds:self.categoryIds sortBy:self.sortBy];
    }
}

#pragma mark --- ZSMultiselectMenuViewDelegate
-(void)clickMenuItemInSelectItemArray:(NSArray *)selectItemArray
{
    if (selectItemArray.count < 1) {
        [self showHint:@"至少选中一个条件"];
        return;
    }
    [_menuPopup dismiss:YES];
    _menuView = nil;
    [_headerView removeFromSuperview];
    _headerView = nil;
    [self.selectCategories removeAllObjects];
    [self.selectCategories addObjectsFromArray:selectItemArray];
    ZSCategoryInfo *info = [selectItemArray firstObject];
    NSString *titleStr ;
    if (info.subs.count >= 1) {
        titleStr = [info.subs firstObject].name;
    } else {
        titleStr = info.name;
    }
    [_screenArray replaceObjectAtIndex:0 withObject:titleStr];
    
    [self setupScreenView];
    
    for (NSInteger i = 0; i < selectItemArray.count; i ++) {
        ZSCategoryInfo *aInfo = selectItemArray[i];
        if (i == 0) {
            if (aInfo.subs.count > 0) {
                for (NSInteger j = 0; j < aInfo.subs.count; j ++) {
                    if (j == 0) {
                        self.categoryIds = aInfo.subs[j].id;
                    } else {
                        self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.subs[j].id];
                    }
                }
            } else {
                self.categoryIds = aInfo.id;
            }
        } else {
            if (aInfo.subs.count > 0) {
                for (NSInteger k = 0; k < aInfo.subs.count; k ++) {
                    self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.subs[k].id];
                }
            } else {
                self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.id];
            }
        }
    }
//    NSLog(@"_________%@",self.categoryIds)
    self.sortBy = @"";
    [self getDataWithCategoryIds:self.categoryIds sortBy:self.sortBy];
}

#pragma mark ---- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        if(!_isTabbarHide){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tableViewHeight + 40.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 -_tableViewHeight-_tableViewBottom - 40.0) style:UITableViewStyleGrouped];
        }
        else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tableViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0-_tableViewHeight-_tableViewBottom)  style:UITableViewStyleGrouped];
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"DynCell" bundle:nil] forCellReuseIdentifier:@"dynCell"];
        
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DynDetailsViewController *vc =[DynDetailsViewController new];
    vc.ID = model.infoId;

        vc.isCreateImg = NO;
    vc.type = 1;

    vc.infoModel =model;
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark --- 获取数据
- (void)getDataWithCategoryIds:(NSString *)categoryIds sortBy:(NSString *)sortBy
{
    self.curPage = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,
                          @"curPage":[NSString stringWithFormat:@"%ld",self.curPage],//页码，从1开始，默认1
                          @"perPage":@"10",//每页记录数，默认10
                          @"categoryIds":self.categoryIds,//分类ID串，逗号分隔
                          @"sortBy":self.sortBy,//排序字段(hot/date),服务端实现统一使用倒序 hot:desc,date:asc
                          };
    [self.request requestDiscoveryInformationWithDic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            self.total = model.totalPages;
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

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    if (self.curPage > self.total) {
        [self.tableView.infiniteScrollingView stopAnimating];
        return;
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"userId":gUserID,
                          @"curPage":[NSString stringWithFormat:@"%ld",self.curPage],//页码，从1开始，默认1
                          @"perPage":@"10",//每页记录数，默认10
                          @"categoryIds":self.categoryIds,//分类ID串，逗号分隔
                          @"sortBy":self.sortBy,//排序字段(hot/date),服务端实现统一使用倒序 hot:desc,date:asc
                          };
    
    [self.request requestDiscoveryInformationWithDic:dic block:^(DiscoveryInformationModel *model, NSError *error) {
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

@end
