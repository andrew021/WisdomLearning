//
//  AssigningCourseController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AssigningCourseController.h"
#import "AssignCourseCell.h"
#import "TopicCourseDetailController.h"

@interface AssigningCourseController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray<CourseList *> *courseList;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation AssigningCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
//    [self createRefresh];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"AssignCourseCell" bundle:nil] forCellReuseIdentifier:@"AssignCourseCell"];
    }
    return _tableView;
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
//    NSString * curPage = [NSString stringWithFormat: @"%ld",kPageNum];
    NSDictionary *dict = @{@"clazzId":_classId, @"userId":gUserID};
    [self.request requestOffLineClassCourseListWithDict:dict block:^(OfflineCourseListModel *model, NSError *error) {
        self.showEmptyView = YES;
        if (model.isSuccess) {
            _courseList = model.data.mutableCopy;
            
//            if (model.curPage < model.totalPages) {
//                [self.tableView setShowsInfiniteScrolling:YES];
//            } else {
//                [self.tableView setShowsInfiniteScrolling:NO];
//            }
            
        } else {
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
    NSDictionary *dict = @{@"curPage":curPage, @"clazzId":_classId};
    
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestOffLineClassCourseListWithDict:dict block:^(OfflineCourseListModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if (model.isSuccess) {
            [_courseList addObjectsFromArray:model.data];
            
            [self.tableView reloadData];
            
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _courseList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssignCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssignCourseCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.courseModel = _courseList[indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicCourseDetailController *destVc = [[TopicCourseDetailController alloc] init];
    destVc.classId = _classId;
    destVc.courseId = _courseList[indexPath.row].courseId;
    [self.navigationController pushViewController:destVc animated:YES];

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
