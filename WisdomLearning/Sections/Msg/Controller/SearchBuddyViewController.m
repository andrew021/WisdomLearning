
//  SearchBuddyViewController.m
//  BigMovie
//
//  Created by Shane on 16/4/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//搜索群组和好友

#import "SearchBuddyViewController.h"
#import "JZSearchBar.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "RealtimeSearchUtil.h"
#import "ContactsManager.h"
#import "UserProfileManager.h"
#import "SearchBuddyCell.h"
#import "ChatViewController.h"
#import "ZSMessageModel.h"

//@implementation NSString (search)
//
////根据用户昵称进行搜索
//- (NSString*)showName
//{
//    return [[UserProfileManager sharedInstance] getNickNameWithUsername:self];
//}
//
//@end

@interface SearchBuddyViewController ()<UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) JZSearchBar* searchBar;
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, strong)ZSMessageSearchModel * zsModel;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, assign) BOOL showEmptyView;


@end

@implementation SearchBuddyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldIsEditing:) name:UITextFieldTextDidChangeNotification object:nil];
    [self createSearch];
    [self setupTableView];
    [self createRefresh];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    [self preferredStatusBarStyle];

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
    NSString *text = @"暂无搜索结果";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)createRefresh
{
    __weak SearchBuddyViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf didSearchBuddy];
        //[weakSelf.tableView reloadData];
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self didSearchBuddy];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
   // [self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    return UIStatusBarStyleDefault;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.searchBar resignFirstResponder];
  //  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createSearch
{
    self.searchBar = [JZSearchBar searchBar];
    self.searchBar.delegate = self;
    self.searchBar.returnKeyType = UIReturnKeySearch;
    // self.searchBar.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索电影项目、需求、资源、众筹" attributes:dict];
    self.searchBar.frame = CGRectMake(10, 0, SCREEN_WIDTH - 70, 30);
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar becomeFirstResponder];
    
    UIButton* button_back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    [button_back setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    button_back.titleLabel.font = [UIFont systemFontOfSize:14];
    [button_back setTitle:@"取消" forState:UIControlStateNormal];
    [button_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_back.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithCustomView:button_back];
    [backButton setStyle:UIBarButtonItemStyleDone];
    [self.navigationItem setRightBarButtonItem:backButton];
}

- (void)setupTableView
{
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 72;
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _zsModel.GROUP_LIST.count+_zsModel.FRIEND_LIST.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchBuddyCell *cell = [SearchBuddyCell cellForTableView:tableView];
  
    cell.searchText = _searchText;
    NSArray * group = _zsModel.GROUP_LIST;
    NSArray * friend = _zsModel.FRIEND_LIST;
    if(indexPath.row<group.count){
        ZSMessageGroupModel * model = group[indexPath.row];
         cell.isGroup = YES;
        cell.model = [self getModel:model];
       
    }
    else{

        ZSMessageFriendListModel *model = friend[indexPath.row-group.count];
        cell.isGroup = NO;
        cell.model = model;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(ZSMessageFriendListModel*)getModel:(ZSMessageGroupModel*)model
{
    ZSMessageFriendListModel * list = [[ZSMessageFriendListModel alloc]init];
    list.USER_SHORTNAME = model.GP_NAME;
    list.USER_ID = model.GP_ID;
    return list;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchBuddyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // SearchModel *model = self.resultList[indexPath.row];
    NSLog(@"%u",cell.conversationType);
    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:cell.conversationId conversationType:cell.conversationType];
    chatVC.title = cell.title;
    chatVC.ID = cell.conversationId;
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SearchBuddyCell cellHeightWithModel:nil];
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



//请求数据
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (self.searchBar.text.length != 0) {
        [self didSearchBuddy];
    }else{
        [self.tableView reloadData];
    }
    [self.searchBar resignFirstResponder];
    return YES;
}

#pragma mark - Private Methods
//监听TextField变化
- (void)textFieldIsEditing:(NSNotification*)notfication
{
    [self didSearchBuddy];
}

-(void)didSearchBuddy{
    NSString *searchText = self.searchBar.text;
    if (searchText.length == 0) {
        self.resultList = nil;
        [self.tableView reloadData];
        return ;
    }
    [self.resultList removeAllObjects];
    _searchText = searchText;
    IMRequest * request  =[[IMRequest alloc]init];
    [request requestSearchLinkManOrGroupList:searchText block:^(ZSMessageSearchListModel *model, NSError *error) {
         self.showEmptyView = YES;
        if(model.isSuccess){
           [self showHint:model.message];
            _zsModel = model.data;

           
            [self.tableView reloadData];
        }
        else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
//    [[APIManager sharedAPI] searchListWithUserid:gUserID keywords:searchText result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
//        self.resultList = arrays;
//        [self.tableView reloadData];
//    }];
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmptyView;
}

@end
