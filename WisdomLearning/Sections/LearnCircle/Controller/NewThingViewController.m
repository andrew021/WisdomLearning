//
//  NewThingViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//新鲜事

#import "NewThingViewController.h"
#import "NewThingCell.h"
#import "NewThingFootView.h"
#import "CrowdFundingImageView.h"

@interface NewThingViewController ()<UITableViewDelegate,UITableViewDataSource,NewThingFootViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NewThingFootView * footView;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation NewThingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    _dataArr = [[NSMutableArray alloc]init];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self createRefresh];
    [self fetchData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immobilization:) name:@"IMMOBILIZATION" object:nil];
    Offset *set = [Offset sharedInstance];
    if (set.offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}

- (void)immobilization:(NSNotification *)note
{
    CGFloat offset = [note.userInfo[@"OFFSET"] floatValue];
    if (offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma mark--创建TableView
-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 420;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak NewThingViewController * weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf fetchMoreData];
    }];
}

#pragma mark---请求数据
- (void)fetchData
{
     kPageNum = 1;
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
 
    if (_objectId == nil) {
        _objectId = @"";
    }
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"objectId":_objectId,@"objectType":_objectType};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestNewThingWithDic:dic block:^(ZSNewThingrModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            [self.dataArr addObjectsFromArray:model.pageData];
             _curPage = model.curPage;
             _totalPage = model.totalPages;
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
            }
            else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
        }
        else{
            [self showHint:model.message];
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
    NSString * str = [NSString stringWithFormat: @"%ld", (long)page];
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"objectId":_objectId,@"objectType":_objectType};

   [self.request requestNewThingWithDic:dic block:^(ZSNewThingrModel *model, NSError *error) {
       if(model.isSuccess){
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



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString* identifier = @"NewThingCell";
    NewThingCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NewThingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = _dataArr[indexPath.section];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewThingModel * model = _dataArr[indexPath.section];
    NSString * imageStr = model.imgStr;
    NSArray *arr = [imageStr componentsSeparatedByString:@","];
    
    CGFloat imHeight = [CrowdFundingImageView getImagesGirdViewHeight:arr withWidth:SCREEN_WIDTH-30 ];
    
    CGFloat height = [GetHeight getHeightWithContent:model.content width:SCREEN_WIDTH-30 font:14];
    
    return imHeight+height+70;
    
}

#pragma mark--区头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark--区尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

//#pragma mark--区尾点赞评论View
//-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.footView = (NewThingFootView *)[[[NSBundle mainBundle] loadNibNamed:@"NewThingFootView" owner:nil options:nil] lastObject];
//    self.footView.frame = CGRectMake(0, 0.0, SCREEN_WIDTH, 60.0);
//    self.footView.delegate = self;
//    [view addSubview:self.footView];
//    return view;
//}

#pragma mark--点赞评论按钮点击方法
-(void)clickBtns:(UIButton *)sender
{
    if(sender.tag == 0){
        NSLog(@"评论");
    }
    else{
        NSLog(@"点赞");
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y < 0.1) {
        _tableView.scrollEnabled = NO;
    } else {
        _tableView.scrollEnabled = YES;
    }
}

@end
