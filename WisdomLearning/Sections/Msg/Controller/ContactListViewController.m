//
//  ContactListViewController.m
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//联系人界面

#import "ContactListViewController.h"
#import "Buddy_Group_Cell.h"
#import "ContactCell.h"
//#import "ContactsManager.h"
#import "ChatViewController.h"
#import "ApplyViewController.h"
#import "GroupListViewController.h"
#import "SortUtil.h"


static NSString *buddy = @"新朋友";
static NSString *group = @"群组";

@interface ContactListViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
}
@property (nonatomic, assign) NSInteger unapplyCount;
@property (nonatomic, strong) NSMutableArray *sectionTitles;  //索引数据
@property (nonatomic, strong) NSMutableArray *dataArray;     //表数据


@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //创建分组样式的TableView
    [self crateTableViewWithFrame:self.view.bounds andStyle:UITableViewStyleGrouped];
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
//        self.tableView.sectionIndexBackgroundColor = [UIColor redColor];
//        self.tableView.sectionIndexTrackingBackgroundColor = [UIColor redColor];
        [self.tableView setSectionIndexColor:[UIColor grayColor]];
    }
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    //设置TableView的blocks
    self.title = @"联系人";
    [self tableViewBlocks];
    //下拉刷新
    [self pullDown];
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
    NSString *text = @"暂无联系人";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadContactDataSource];
    [self reloadApplyView];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - kBaseViewControllerProtocol
-(void)tableViewBlocks{
    __weak typeof(self) weakSelf = self;
    [weakSelf setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
        return [weakSelf cellForRowAtIndexPath:indexPath forTableView:tableView];
    }];
    [weakSelf setSectionIndexTitlesForTableViewCompletion:^NSArray *(UITableView *tableView) {
        return weakSelf.sectionTitles;
    }];
    [weakSelf setNumberOfSectionsInTableViewCompletion:^NSInteger(UITableView *tableView) {
    
        return [weakSelf.dataArray count] + 1;
    }];
    [weakSelf setNumberOfRowsInSectionCompletion:^NSInteger(UITableView *tableView, NSInteger section) {
        return (section == 0) ? 2 :[weakSelf.dataArray[section-1] count];
    }];
    [weakSelf setTitleForHeaderInSectionCompletion:^NSString *(UITableView *tableView, NSInteger section) {
        return (section == 0) ? @"" :weakSelf.sectionTitles[section-1];
    }];
    [weakSelf setSectionForSectionIndexTitleCompletion:^NSInteger(UITableView *tableView, NSString *title, NSInteger index) {
        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index+1];
        [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        return index+1;
    }];
    [weakSelf setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
        [weakSelf didSelectRowAtIndexPath:indexPath forTableView:tableView];
    }];
    [weakSelf setViewForHeaderInSectionCompletion:^UIView *(UITableView *tableView, NSInteger section) {
        return (section == 0) ? nil : [weakSelf viewForHeaderInSection:section forTableView:tableView];
    }];
    [weakSelf setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
        return (indexPath.section == 0) ? [Buddy_Group_Cell cellHeightWithModel:nil] : [ContactCell cellHeightWithModel:nil];
    }];
    [weakSelf setHeightForHeaderInSectionCompletion:^CGFloat(UITableView *tableView, NSInteger section) {
        return (section == 0) ? CGFLOAT_MIN  : 25.0f;
    }];
    [weakSelf setHeightForFooterInSectionCompletion:^CGFloat(UITableView *tableView, NSInteger section) {
        return CGFLOAT_MIN;
    }];

}

- (void)pullDown
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadContactDataSource];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
}

#pragma mark -reload
- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}


#pragma mark - 加载数据并排序建立索引
-(void)loadContactDataSource{
    __weak __typeof(self) weakSelf = self;
    //[weakSelf showHudInView:weakSelf.view hint:@""];
    [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:^(NSArray *array) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [SortUtil sortData:array completionBlock:^(NSMutableArray *titles, NSMutableArray *data) {
              //  [self hideHud];
                @synchronized (self) {
                    self.sectionTitles = titles;
                    self.dataArray = data;
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        });
    }];
}


#pragma mark - UITableView
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView{
    if (indexPath.section == 0) {
        Buddy_Group_Cell *cell = [Buddy_Group_Cell cellForTableView:tableView];
        cell.ivGroup.image = (indexPath.row == 0) ? [ThemeInsteadTool imageWithImageName:@"new_friend"] : [ThemeInsteadTool imageWithImageName:@"group_icon"];
        cell.lbGroup.text = (indexPath.row == 0) ? buddy : group;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        ContactCell *cell = [ContactCell cellForTableView:tableView];
        ZSMessageFriendListModel *model = _dataArray[indexPath.section-1][indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0) {
        if (indexPath.row == 0) {
            // 跳转到新朋友页面
            if([gUsername isEqualToString:@"hy_px_demo"]){
                return [self showHint:@"访客账号不能聊天!"];
            }
            ApplyViewController *view = [[ApplyViewController alloc] init];
            view.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:view animated:YES];
        }else{
            //跳转到群组页面
           // GroupListController *groupController = [[GroupListController alloc] init];
            if([gUsername isEqualToString:@"hy_px_demo"]){
                return [self showHint:@"访客账号不能聊天!"];
            }
            GroupListViewController *groupController = [[GroupListViewController alloc] init];
            groupController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:groupController animated:YES];
        }
        return ;
    }else{
       // 跳转到聊天页面
       ZSMessageFriendListModel *model = _dataArray[indexPath.section-1][indexPath.row];
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.USER_ID conversationType:EMConversationTypeChat];
        chatController.ID = model.USER_ID;
       // chatController.linkManModel = model;
       // chatController.isMsg = NO;
        chatController.nickName = model.USER_SHORTNAME;
        chatController.title = model.USER_SHORTNAME.length > 0 ? model.USER_SHORTNAME : model.USER_ID;
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

- (UIView *) viewForHeaderInSection:(NSInteger)section forTableView:(UITableView *)tableView{
    UIView *contentView = [[UIView alloc] init];
//    [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
//    [contentView setBackgroundColor:kTextLightGray];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"ArialMT" size:13];
    label.textColor = kTextLightGray;
    [label setText:_sectionTitles[section-1]];
    [contentView addSubview:label];
    return contentView;
}

@end
