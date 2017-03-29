//
//  CurriculumViewController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CurriculumViewController.h"
#import "DoingCurriculumCell.h"
#import "CourseStudyViewController.h"

@interface CurriculumViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ZSMyCourseInfo *> *myCoursesList;
@property (nonatomic, assign) BOOL showEmptyView;

@end

@implementation CurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
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

#pragma mark ---lazy method---
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"DoingCurriculumCell" bundle:nil] forCellReuseIdentifier:@"DoingCurriculumCell"];
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

#pragma mark ---请求数据---
- (void)fetchData
{
    kPageNum = 1;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];

    NSDictionary *dict = @{@"userId":gUserID, @"listType":_listType, @"curPage":curPage};
//    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestMyCourseListWithDict:dict block:^(ZSMyCourseListModel *model, NSError *error) {
//        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            _myCoursesList = model.pageData.mutableCopy;
            [self showHint:model.message];
            if (_myCoursesList.count < model.totalRecords) {
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
    NSDictionary *dict = @{@"userId":gUserID, @"listType":_listType, @"curPage":curPage};
    
//    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestMyCourseListWithDict:dict block:^(ZSMyCourseListModel *model, NSError *error) {
//        [self hideHud];
        if (model.isSuccess) {
            [_myCoursesList addObjectsFromArray:model.pageData];
            [self showHint:model.message];
            if (_myCoursesList.count < model.totalRecords) {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myCoursesList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoingCurriculumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoingCurriculumCell" forIndexPath:indexPath];
    cell.type = [_listType intValue];
    cell.myCourse = _myCoursesList[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseStudyViewController *destVc = [CourseStudyViewController new];
    ZSMyCourseInfo *myCourse = _myCoursesList[indexPath.row];
    destVc.courseId = myCourse.courseId;
    destVc.title = myCourse.courseName;
    
    [self.navigationController pushViewController:destVc animated:YES];
    
}

/*当点击UINavigationBar 上面系统提供的编辑按钮的时候, 系统会调用这个方法*/
- (void)setEditing:(BOOL)editing animated:animated
{
    /*首先调用父类的方法*/
    [super setEditing:editing animated:animated];
    /*使tableView出于编辑状态*/
    [self.tableView setEditing:editing animated:animated];
}

// 指定哪些行的 cell 可以进行编辑(UITableViewDataSource 协议方法)
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


//指定cell的编辑状态(删除还是插入)(UITableViewDelegate 协议方法)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 不同的行, 可以设置不同的编辑样式, 编辑样式是一个枚举类型 */
    return UITableViewCellEditingStyleDelete;
//    if (indexPath.row == 0) {
//        return UITableViewCellEditingStyleInsert;
//    } else {
//        return UITableViewCellEditingStyleDelete;
//    }
}

- (void)tableView :(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**   点击 删除 按钮的操作 */
    if (editingStyle == UITableViewCellEditingStyleDelete) { /**< 判断编辑状态是删除时. */
        
//        /** 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据. */
//        [_myCoursesList removeObjectAtIndex:indexPath.row];
//        
//        /** 2. TableView中 删除一个cell. */
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""message:@"确定删除课程吗？"preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        
//        [alert addAction [UIAlertAction actionWithTitle:@"定"style:UIAlertActionStyleDestructivehandler:^(UIAlertAction*action) {  NSLog(@"点击了确定按钮"); }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            ZSMyCourseInfo *myCourse = _myCoursesList[indexPath.row];
            NSDictionary *dict = @{@"userId":gUserID, @"courseId":myCourse.courseId, @"clazzId":myCourse.clazzId};
            //        UIAlertView
            [self.request cancelChooseCourseWithDict:dict block:^(ZSModel *model, NSError *error) {
                if (model.isSuccess) {
                    /** 1. 更新数据源(数组): 根据indexPaht.row作为数组下标, 从数组中删除数据. */
                    [_myCoursesList removeObjectAtIndex:indexPath.row];
                    
                    /** 2. TableView中 删除一个cell. */
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                }else{
                    
                    [self showHint:model.message];
                }
            }];

        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
}
    
//    /** 点击 +号 图标的操作. */
//    if (editingStyle == UITableViewCellEditingStyleInsert) { /**< 判断编辑状态是插入时. */
//        /** 1. 更新数据源:向数组中添加数据. */
//        [self.arr insertObject:@"abcd" atIndex:indexPath.row];
//        
//        /** 2. TableView中插入一个cell. */
//        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        
//    }
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
