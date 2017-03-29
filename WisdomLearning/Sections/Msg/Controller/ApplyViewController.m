/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */
//新朋友界面

#import "ApplyViewController.h"

#import "NewApplyCell.h"
#import "InvitationManager.h"
//#import "LGAlertView.h"
//#import "ZSMessageModel.h"


static ApplyViewController *controller = nil;

@interface ApplyViewController ()<ClickBtnToAddOrReject, CellLongPressDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UILabel * hintLabel;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation ApplyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         controller = [[self alloc] initWithStyle:UITableViewStylePlain];
    });
    
    return controller;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"新朋友";
    self.tableView.tableFooterView = [[UIView alloc] init];
   
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self createRefresh];
   // [self setupBackButtonItem];
   // [self setupTableView];
    
    [self loadDataSourceFromLocalDB];
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}


//-(void)loadMoreData{
//    __weak ApplyViewController * weakSelf = self;
//    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
//        [weakSelf fetchMoreData];
//        //[weakSelf.tableView reloadData];
//    }];
//}
//
//- (void)fetchMoreData{
//    kPageNum ++;
//    [self showHudInView:self.view hint:@"加载中..."];
//    IMRequest * request = [[IMRequest alloc]init];
//
//    NSString *type = [NSString stringWithFormat:@"%ld",(long)self.type];
//    [request requestCrowdfunding:type pub_pageNo:Int2String(kPageNum) pub_pageSize:Int2String(kPageSize) block:^(PublicManageListModel *model, NSError *error) {
//        [self hideHud];
//        if (model.isSuccess) {
//            [self.dataArray addObjectsFromArray:model.data];
//            [self.tableView reloadData];
//        }else{
//            [self showHint:model.message];
//        }
//        [self.tableView.infiniteScrollingView stopAnimating];
//    }];
//}


- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView
{
    UIImage* img = [ThemeInsteadTool imageWithImageName:@"Dia_NoContent"];
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
    NSString *text = @"暂无新朋友";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createRefresh
{
    __weak ApplyViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadDataSourceFromLocalDB];
        [weakSelf.tableView reloadData];
    }];

}

-(void)loadMoreData
{
    __weak ApplyViewController* weakSelf = self;
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
        [weakSelf.tableView reloadData];
    }];
}

-(void)fetchMoreData
{
    kPageNum++;
    __weak typeof(self) weakSelf = self;
     IMRequest * request = [[IMRequest alloc]init];
    [request requestNewFriendsPageNo:Int2String(kPageNum) pageSize:Int2String(kPageSize) block:^(ZSMessageModel *model, NSError *error) {
        [self showHint:model.message];
        if(model.isSuccess){
            [weakSelf.dataSource addObjectsFromArray:model.data];
//            (weakSelf.dataSource.count == 0) ? [weakSelf.view addSubview:weakSelf.noBuddyView]:
//            [weakSelf.noBuddyView removeFromSuperview];
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }];

    
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (NSString *)loginUsername
{
    return [[EMClient sharedClient] currentUsername];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.dataSource count];
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewApplyCell *cell = [NewApplyCell cellForTableView:tableView];
    ZSMessageNewFriendModel * model = self.dataSource[indexPath.row];
//    NewFriendModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewApplyCell cellHeightWithModel:nil];
}

-(void)longPressAtIndexPath:(NSIndexPath *)indexPath{
//    LGAlertView *alert = [[LGAlertView alloc] initWithTitle:nil
//                                                    message:nil
//                                                      style:LGAlertViewStyleActionSheet
//                                               buttonTitles:@[@"删除"]
//                                          cancelButtonTitle:@"取消"
//                                     destructiveButtonTitle:nil
//                                              actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
//                                                  ApplyEntity *entity = self.dataSource[indexPath.row];
//                                                  NSString *loginUsername = [[EMClient sharedClient] currentUsername];
//                                                  [self.dataSource removeObject:entity];
//                                                  [[InvitationManager sharedInstance] removeInvitation:entity loginUser:loginUsername];
//                                                  [self loadDataSourceFromLocalDB];
//                                              }
//                                              cancelHandler:nil
//                                         destructiveHandler:nil];
//    
//    
//    
//    alert.coverColor = [UIColor colorWithWhite:0.85f alpha:0.9];
//    alert.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
//    alert.layerShadowRadius = 4.f;
//    alert.layerCornerRadius = 0.f;
//    alert.layerBorderWidth = 2.f;
//    alert.layerBorderColor = [UIColor whiteColor];
//    alert.backgroundColor = [UIColor whiteColor];
//    alert.buttonsHeight = 56.f;
//    alert.buttonsFont = [UIFont systemFontOfSize:20.f];
//    alert.cancelButtonFont = [UIFont systemFontOfSize:20.f];
//    alert.destructiveButtonFont = [UIFont systemFontOfSize:20.f];
//    alert.buttonsTitleColor = [UIColor blackColor];
//    alert.destructiveButtonTitleColor = [UIColor blackColor];
//    alert.cancelButtonTitleColor = [UIColor redColor];
//    alert.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
//    alert.offsetVertical = 16.f;
//    alert.cancelButtonOffsetY = 3.f;
//    alert.buttonsBackgroundColorHighlighted = [UIColor lightGrayColor];
//    alert.cancelButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
//    alert.destructiveButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
//    [alert showAnimated:YES completionHandler:nil];
//
}


//接受
-(void)clickAddBtnWithIndex:(NSIndexPath *)index completionBlock:(void (^)())completionBlock
{
    if (index.row < [self.dataSource count]) {
     //   NewFriendModel * model = self.dataSource[index.row];
        ZSMessageNewFriendModel * _model = self.dataSource[index.row];
        [self showHudInView:self.view hint:@"正在处理中..."];
        IMRequest * request = [[IMRequest alloc]init];
        [request requestDisposeFriend:_model.APL_ID state:@"1" block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            [self showHint:model.message];
            if(model.isSuccess){
                _model.APL_STATUS = 1;
                if (completionBlock) {
                    completionBlock();
                }
            }
            

        }];

    }
}

-(void)clickRejectBtnWithIndex:(NSIndexPath *)index completionBlock:(void (^)())completionBlock
{
    if (index.row < [self.dataSource count]) {
        
        
        ZSMessageNewFriendModel * _model = self.dataSource[index.row];
        [self showHudInView:self.view hint:@"正在处理中..."];
         IMRequest * request = [[IMRequest alloc]init];
        [request requestDisposeFriend:_model.APL_ID state:@"2" block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            [self showHint:model.message];
            if(model.isSuccess){
                _model.APL_STATUS = 2;
                if (completionBlock) {
                    completionBlock();
                }
            }
            
            
        }];


    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ApplyFriendCellDelegate


#pragma mark - public

- (void)addNewApply:(NSDictionary *)dictionary
{

}


-(void)loadDataSourceFromLocalDB
{
    kPageNum = 1;
    __weak typeof(self) weakSelf = self;
   
     [weakSelf showHudInView:self.view hint:@"加载中..."];
    IMRequest * request = [[IMRequest alloc]init];

    [request requestNewFriendsPageNo:Int2String(kPageNum) pageSize:Int2String(kPageSize) block:^(ZSMessageModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self showHint:model.message];
        if(model.isSuccess){
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:model.data];
//            (weakSelf.dataSource.count == 0) ? [weakSelf.view addSubview:weakSelf.noBuddyView]:[weakSelf.noBuddyView removeFromSuperview];
            if(weakSelf.dataSource.count == kPageSize){
                [self loadMoreData];
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
    
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmptyView;
}

- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUntreatedApplyCount" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

@end
