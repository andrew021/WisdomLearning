//
//  NearbyStudentsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "NearbyStudentsViewController.h"
#import "ClassmatesCell.h"
#import "IndividualHomepageController.h"

@interface NearbyStudentsViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, strong) UIButton *joinChatButton;

@end

@implementation NearbyStudentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor orangeColor];
    
//    self.ID = @"112";
//    self.type = @"like";
//    self.typeID = @"programId";
    
    
    [self.view addSubview:self.tableView];
  
    _dataArr = [[NSMutableArray alloc]init];
  //  _type = @"hot";
    [self createRefresh];
    [self fetchData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offsetCenter:) name:@"SCROLLVIEW_ClassMates" object:nil];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    if(_isCreateBtn){
        [self.view addSubview:self.joinChatButton];
    }
    else{
        
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immobilization:) name:@"IMMOBILIZATION" object:nil];
    Offset *set = [Offset sharedInstance];
    if (set.offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak NearbyStudentsViewController* weakSelf = self;
   
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
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

//-(void)offsetCenter:(NSNotification *)note
//{
//    double offset = [note.userInfo[@"OFFSET"] doubleValue];
//
//   
//    if (SCREEN_HEIGHT == 480) {
//        _joinChatButton.frame = CGRectMake(10.0, offset-100, SCREEN_WIDTH - 20.0, 40.0);
//
//    } else if (SCREEN_HEIGHT == 568){
//        _joinChatButton.frame = CGRectMake(10.0, offset-50, SCREEN_WIDTH - 20.0, 40.0);
//
//    } else if (SCREEN_HEIGHT == 667) {
//        _joinChatButton.frame = CGRectMake(10.0, offset+50, SCREEN_WIDTH - 20.0, 40.0);
//
//    } else {
//        _joinChatButton.frame = CGRectMake(10.0, offset+100, SCREEN_WIDTH - 20.0, 40.0);
//
//    }
//}


#pragma mark---请求数据
- (void)fetchData
{
    kPageNum = 1;
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    NSDictionary * dic = @{@"curPage":str,_typeID:self.ID,@"type":_type};
  //  [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestClassMateListWith:dic withBlock:^(ZSClassMateModel *model, NSError *error) {
       // [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            _totalPage = model.totalPages;
            _curPage = model.curPage;
            NSArray * arr = [[NSArray alloc]init];
            arr= model.pageData;
            [self.dataArr addObjectsFromArray:arr];
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
        } else{
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
   // [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)page];
    NSDictionary * dic = @{@"curPage":str,_typeID:self.ID,@"type":_type};
    
    [self.request requestClassMateListWith:dic withBlock:^(ZSClassMateModel *model, NSError *error) {
     //   [self hideHud];
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

-(UIButton *)joinChatButton{
    

//    if (!_joinChatButton){
//    _joinChatButton = [UIButton new];
//    if (SCREEN_HEIGHT == 480) {
//        _joinChatButton.frame = CGRectMake(10.0, self.offest - 100, SCREEN_WIDTH - 20.0, 40.0);
//    } else if (SCREEN_HEIGHT == 568){
//        _joinChatButton.frame = CGRectMake(10.0, self.offest - 50, SCREEN_WIDTH - 20.0, 40.0);
//    } else if (SCREEN_HEIGHT == 667) {
//        _joinChatButton.frame = CGRectMake(10.0, self.offest + 50, SCREEN_WIDTH - 20.0, 40.0);
//    } else {
//        _joinChatButton.frame = CGRectMake(10.0, self.offest + 100, SCREEN_WIDTH - 20.0, 40.0);
//    }
//
//        [_joinChatButton setTitle:@"进入群聊" forState:UIControlStateNormal];
//        [_joinChatButton setBackgroundColor:KMainBlue];
//        [_joinChatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
//        _joinChatButton.layer.cornerRadius = 4;
//    
//   }
//    return _joinChatButton;
    
    if (!_joinChatButton) {
        _joinChatButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+5, SCREEN_WIDTH-20, 40)];
        [_joinChatButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        [_joinChatButton setBackgroundColor:kMainThemeColor];
        [_joinChatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
        _joinChatButton.layer.cornerRadius = 4;
    }
    return _joinChatButton;

}

-(void)clickChat:(UIButton*)btn{
//    if(_delegate){
//        [self.delegate ToClassroomViewWithClickBtns:btn];
//    }
    if(_delegate && [_delegate respondsToSelector:@selector(groupChat)]){
        [self.delegate groupChat];
    }
    
}

#pragma mark --- setup tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        int btnHeight = 0;
        if (_isCreateBtn) {
            btnHeight = 50;
        }
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0-btnHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ClassmatesCell" bundle:nil] forCellReuseIdentifier:@"ClassmatesCell"];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassmatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassmatesCell" forIndexPath:indexPath];
    cell.model = _dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IndividualHomepageController *destVc = [[IndividualHomepageController alloc] init];
    CLassMateListModel *model = _dataArr[indexPath.row];
    destVc.userID = model.userId;
    destVc.nickName = model.name;
    [self.navigationController pushViewController:destVc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
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
