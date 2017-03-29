//
//  SignupListViewController.m
//  WisdomLearning
//
//  Created by Shane on 16/11/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SignupListViewController.h"
#import "SignupListCell.h"

@interface SignupListViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray<Signup *>*signupList;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation SignupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self createRefresh];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"SignupListCell" bundle:nil] forCellReuseIdentifier:@"SignupListCell"];
    }
    return _tableView;
}

-(void)setBBounce:(BOOL)bBounce{
    _bBounce = bBounce;
    _tableView.scrollEnabled = bBounce;
}

#pragma mark ---创建刷新和加载更多---
- (void)createRefresh
{
    __weak __typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

-(void)fetchData{
    kPageNum = 1;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    if (_classId == nil) {
        _classId = @"";
    }
    if (_courseId == nil) {
        _courseId = @"";
    }
    NSDictionary *dict = @{@"userId":gUserID, @"clazzId":_classId, @"courseId":_courseId,@"curPage":curPage};
    
    [self.request requestSignupListWithDict:dict block:^(ZSSignupListModel *model, NSError *error) {
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            _signupList = model.pageData.mutableCopy;
            
            if (_signupList.count < model.totalRecords) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
        }else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
    
}

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    kPageNum ++;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    NSDictionary *dict = @{@"userId":gUserID, @"clazzId":_classId, @"courseId":_courseId,@"curPage":curPage};
    [self.request requestSignupListWithDict:dict block:^(ZSSignupListModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            [_signupList addObjectsFromArray:model.pageData];
            
            if (_signupList.count < model.totalRecords) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
            
            [self.tableView reloadData];
            
        }else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];

}


#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _signupList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SignupListCell" forIndexPath:indexPath];
    cell.signupModel = _signupList[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    TopicCourseDetailController *destVc = [[TopicCourseDetailController alloc] init];
//    destVc.classId = _classId;
//    [self.navigationController pushViewController:destVc animated:YES];
    
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
