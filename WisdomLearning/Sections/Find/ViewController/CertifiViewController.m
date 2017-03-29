//
//  CertificateViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/26.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CertifiViewController.h"
#import "HeaderView.h"
#import "CertificateListCell.h"
#import "EaseViewController.h"
#import "SearchViewController.h"
#import "CertificateDetailViewController.h"
#import "FindModel.h"

@interface CertifiViewController ()<UITableViewDataSource,UITableViewDelegate,HeaderViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) CGFloat tableViewBottom;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, strong) NSString * searchKey;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation CertifiViewController

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
    self.navigationItem.title = @"发现证书";
    
    
    if(!_isTabbarHide){
        HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
        
        headerView.delegate = self;
        _tableViewHeight = 42;
        _tableViewBottom = 0;
        [self.view addSubview:headerView];
    }
    else{
        _tableViewHeight = 0;
        _tableViewBottom = 90;
    }
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    
    [self.view addSubview:self.tableView];
    _dataArr = [[NSMutableArray alloc]init];
    _searchKey = @"date";
    [self createRefresh];
    [self fetchDataWith:_searchKey];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
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
    __weak CertifiViewController* weakSelf = self;
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
    
    [self.request requestCertificateListWith:dic withBlock:^(ZSFindListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            _curPage = model.curPage;
             _totalPage = model.totalPages;
            [self.dataArr addObjectsFromArray:model.pageData];
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
            }
            else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
        } else {
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
    
    [self.request requestCertificateListWith:dic withBlock:^(ZSFindListModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            [self.tableView reloadData];
        } else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


//setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tableViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0-_tableViewHeight-_tableViewBottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 110;
    }
    return _tableView;
}
#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"CertificateListCell";
    CertificateListCell* cell = (CertificateListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CertificateListCell" owner:nil options:nil] lastObject];
    }
    cell.model = _dataArr[indexPath.row];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CertificateDetailViewController *vc = [[CertificateDetailViewController alloc]init];
    CertificateListModel * model = _dataArr[indexPath.row];
    vc.cerId = model.certId;
    vc.title = [NSString stringWithFormat:@"%@详细",model.name];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark---头部选择控件方法
-(void)clickRepons:(UIButton *)sender{
    NSString * str = nil;
    if(sender.tag == 0){
        str = @"date";
    } else if(sender.tag){
        str = @"hot";
    } else{
        str = @"matchRate";
    }
    [self fetchDataWith:str];
    
}

-(void)searchBtnClick{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchCertificate;
    [self.navigationController pushViewController:VC animated:YES];
    
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
