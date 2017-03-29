//
//  GroupMemberViewController.m
//  BigMovie
//
//  Created by hfcb001 on 16/4/8.
//  Copyright © 2016年 zhisou. All rights reserved.
//群成员

#import "GroupMemBerTableViewCell.h"
#import "GroupMemberViewController.h"
#import "IndividualHomepageController.h"
//#import "ZSMessageModel.h"

@interface GroupMemberViewController () <UITableViewDelegate, UITableViewDataSource,UIAlertViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation GroupMemberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     _dataSource = [[NSMutableArray alloc]init];
    self.title = @"群成员列表";
    [self setupTableView];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self createRefresh];
    [self fetchData];
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
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
    NSString *text = @"暂无群成员";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)createRefresh
{
    __weak GroupMemberViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        
        [weakSelf fetchData];
    }];
    
}

-(void)fetchData
{
    [self showHudInView:self.view hint:@"加载中..."];
    IMRequest * request = [[IMRequest alloc]init];
    [request requestGroupMember:_groupId block:^(ZSMessageGroupMemberListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if(model.isSuccess){
           // [self showHint:model.message];
           [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:model.data];
           //  NSLog(@"%lu",(unsigned long)_dataSource.count);
            
            [self.tableView reloadData];
            
        }
        else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return self.showEmptyView;
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    self.tableView.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.rowHeight = 72;
    //去掉底部多余的表格线
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GroupMemBerTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"groupMemBer"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GroupMemBerTableViewCell" owner:nil options:nil] lastObject];
    }

    ZSMessageGroupMemberModel * model = _dataSource[indexPath.row];
    ZSMessageGroupMemberModel * firstModel = _dataSource[0];
    [cell.avatar sd_setImageWithURL:[model.USER_PIC stringToUrl]  placeholderImage:KPlaceHeaderImage];
    if(model.GM_CARD.length != 0){
        cell.nameLabel.text = model.GM_CARD;
    }
    else{
        cell.nameLabel.text = model.USER_SHORTNAME;
    }
    cell.msgLabel.text = model.USER_SIGN;
    
    if(indexPath.row == 0){
        cell.deleteBtn.hidden = YES;
    }
    else{
        if([firstModel.USER_ID isEqualToString:gUserID]){
            [cell.deleteBtn addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.deleteBtn.tag = indexPath.row;
        }
        else{
            cell.deleteBtn.hidden = YES;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IndividualHomepageController * view = [[IndividualHomepageController alloc]init];
    ZSMessageGroupMemberModel * model = _dataSource[indexPath.row];
    view.userID = model.USER_ID;
    view.nickName = model.USER_SHORTNAME;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)clickDeleteBtn:(id)sender
{

    UIButton * btn = (UIButton*)sender;
    _tag = btn.tag;
    [self deleClick];
   
}

- (void)deleClick
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确认要删除该群成员吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.size = CGSizeMake(SCREEN_WIDTH - 20, 200);
    [alertView show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        ZSMessageGroupMemberModel * model = _dataSource[_tag];
        [self showHudInView:self.view hint:@"正在移除..."];
        IMRequest * request = [[IMRequest alloc]init];
        [request requestDeleteGroupMember:model.GM_ID type:@"1" block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            if(model.isSuccess){
                [self showHint:model.message];
                [self.dataSource removeObjectAtIndex:_tag];
                [self.tableView reloadData];
            }
            else{
                [self showHint:model.message];
            }
            
        }];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
