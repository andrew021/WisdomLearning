//
//  NewGroupViewController.m
//  BigMovie
//
//  Created by Shane on 16/4/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//群组列表

#import "GroupListViewController.h"
#import "NewGroupCell.h"
#import "EMGroup.h"
#import "ChatViewController.h"
#import "ZSMessageModel.h"


@interface GroupListViewController ()<EMGroupManagerDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation GroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
    self.title = @"联系人";
    //创建navigationBar‘s left button
   // [self setupBackButtonItem];
    //创建普通样式的TableView
    [self crateTableViewWithFrame:self.view.bounds andStyle:UITableViewStylePlain];
    //创建下拉刷新
    [self pullDownData];
    //设置TableView Blocks
    [self tableViewBlocks];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //上拉加载更多
    // [self pullUp];
}


- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView
{
    UIImage* img = [ThemeInsteadTool imageWithImageName:@"Dia_NoContent"];;
    return img;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView
{
    return YES;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -60.f;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无群组";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadGroupDataSource];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
}

- (void)pullDownData
{
    __weak GroupListViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadGroupDataSource];
        
    }];
}

-(void)pullUp
{
    __weak GroupListViewController* weakSelf = self;
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
        
    }];
}

-(void)fetchMoreData
{
    kPageNum ++;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.noGroupView removeFromSuperview];
}


#pragma mark - 无群组显示信息
-(void)showNoGroupView{
    self.dataArray.count == 0 ?
    [self.tableView addSubview:self.noGroupView] :
    [self.noGroupView removeFromSuperview];
    
}

#pragma mark - kBaseViewControllerProtocol
-(void)tableViewBlocks{
    __weak typeof(self) weakSelf = self;
    [weakSelf setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        return [weakSelf cellForRowAtIndexPath:indexPath forTableView:tableView];
    }];
    [weakSelf setNumberOfSectionsInTableViewCompletion:^NSInteger(UITableView *tableView) {
        return 1;
    }];
    [weakSelf setNumberOfRowsInSectionCompletion:^NSInteger(UITableView *tableView, NSInteger section) {
        return weakSelf.dataArray.count;
    }];
    [weakSelf setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakSelf didSelectRowAtIndexPath:indexPath forTableView:tableView];
    }];
    [weakSelf setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return [NewGroupCell cellHeightWithModel:nil];
    }];
}


- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView
-(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView{
    NewGroupCell *cell = [NewGroupCell cellForTableView:tableView];
    // cell.group = (GroupModel *)_dataArray[indexPath.row];
    NSLog(@"%lu",(unsigned long)_dataArray.count);
    ZSMessageGroupModel * model = _dataArray[indexPath.row];
    cell.group = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到聊天界面
    ZSMessageGroupModel * model = [_dataArray objectAtIndex:indexPath.row];
    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.GP_ID conversationType:EMConversationTypeGroupChat];
//    chatController.isMsg = NO;
    chatController.title = model.GP_NAME;
    chatController.ID = model.GP_ID;
//    chatController.fromSpecificPage = YES;
    chatController.nickName = model.GP_NAME;
    [self.navigationController pushViewController:chatController animated:YES];
}


#pragma mark - 请求数据
- (void)loadGroupDataSource
{
    kPageNum = 1;
    [self showHudInView:self.view hint:@"加载中..."];
    IMRequest * request = [[IMRequest alloc]init];
    [request requestGroupListBlock:^(ZSMessageGroupListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
          //  [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            //[self showNoGroupView];
            
            NSLog(@"shuzugeshu %lu",(unsigned long)self.dataArray.count);
            
            self.title = (self.dataArray.count > 0) ? [NSString stringWithFormat:@"群组(%lu)", self.dataArray.count]: @"群组";
            [self.tableView reloadData];
        }else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmptyView;
}

#pragma mark - getter
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
