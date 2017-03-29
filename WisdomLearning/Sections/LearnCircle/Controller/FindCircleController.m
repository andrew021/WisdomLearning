//
//  FindCircleController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//发现圈子

#import "FindCircleController.h"
#import "LearnCircleCell.h"
#import "HeaderView.h"
#import "LeanCircleDetailController.h"
#import "SearchViewController.h"
#import "LoginController.h"

@interface FindCircleController ()<UITableViewDataSource,UITableViewDelegate,HeaderViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTop;
@property (strong, nonatomic) LoginController * loginCtrl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutBottom;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic,strong) NSString * searchKey;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation FindCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_isTabbarHide){
        HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        
        headerView.delegate = self;
        _layoutConstraintTop.constant = 41;
        _layoutBottom.constant = 0;
        [self.view addSubview:headerView];
    }
    else{
        _layoutConstraintTop.constant = 0;
        _layoutBottom.constant = 42;
    }

    self.tableView.rowHeight = 133;
    if(!_isSlideVC){
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"personal_hearImage"] style:UIBarButtonItemStylePlain target:self action:@selector(slideVCBtnClick)];
    }
     _dataArr = [[NSMutableArray alloc]init];
    _searchKey = @"date";
    [self createRefresh];
    [self fetchDataWith:_searchKey];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   
}



#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak FindCircleController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchDataWith:weakSelf.searchKey];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark---请求数据
- (void)fetchDataWith:(NSString*)searchKey
{
    kPageNum = 1;
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
     NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"sortBy":searchKey};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestLearnCircleListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            _totalPage = model.totalPages;
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
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

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    NSInteger page = _curPage+1;
    if(page>_totalPage){
        [self.tableView.infiniteScrollingView stopAnimating];
        return [self  showHint:@"已经是最后一页了"];
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)page];
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"sortBy":_searchKey};
    
    [self.request requestLearnCircleListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
      
        if(model.isSuccess){
            [self showHint:model.message];
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            [self.tableView reloadData];
            
        }
        else{
            [self showHint:model.message];
            
        }
        [self.tableView.infiniteScrollingView stopAnimating];
       
    }];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString* cellIdentifier = @"LearnCircleCellIdentity";
    LearnCircleCell* cell = (LearnCircleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LearnCircleCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeanCircleDetailController * detail = [[LeanCircleDetailController alloc]init];
    ZSLearnCircleListModel * model = _dataArr[indexPath.row];
    detail.proId = model.ID;
    detail.title = model.name;
    detail.hidesBottomBarWhenPushed = YES;
    detail.title = [NSString stringWithFormat:@"%@详细",model.name];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark---  创建学习圈
- (IBAction)addLearnCircle:(id)sender {
    NSLog(@"创建学习圈");
}

#pragma mark--- 侧边栏
-(void)slideVCBtnClick{
   
    if (![[Config Instance] isLogin]) {
        [self toLogin];
    }else{
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (tempAppDelegate.LeftSlideVC.closed)
        {
            [tempAppDelegate.LeftSlideVC openLeftView];
        } else
        {
            [tempAppDelegate.LeftSlideVC closeLeftView];
        }
    }

}


#pragma mark---  搜索学习圈
- (IBAction)searchLearnCircle:(id)sender {
    NSLog(@"搜索学习圈");
    
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchLearnCircle;
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark---头部选择控件方法
-(void)clickRepons:(UIButton *)sender{
    
    NSLog(@"%ld",(long)sender.tag);
    NSString * str = nil;
    if(sender.tag == 0){
        str = @"date";
    }
    else if(sender.tag){
        str = @"hot";
    }
    else{
        str = @"matchRate";
    }
    [self fetchDataWith:str];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:YES];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:NO];
}


-(void)toLogin{
    if (!_loginCtrl) {
        _loginCtrl  = [[LoginController alloc]init];
    }
    
    _loginCtrl = [[LoginController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_loginCtrl];
    [self presentViewController:nav animated:YES completion:nil];
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
