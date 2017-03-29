//
//  SearchCoursrViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//搜索课程

#import "SearchCoursrViewController.h"
#import "ChooseCourseCell.h"
#import "CourseStudyViewController.h"

@interface SearchCoursrViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, strong) KLCPopup *menuPopup;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation SearchCoursrViewController
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
//    if(_key == nil){
//        _key = @"";
//    }
    [self createRefresh];
    [self searchFetchData];
    [self setTableView];
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)interactData:(id)sender tag:(int)tag data:(id)data
{
    _key = data;
    [self searchFetchData];
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak SearchCoursrViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf searchFetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

-(void)searchFetchData{
    
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    if(_key !=nil &&_key.length>0){
    NSDictionary * dic = @{@"name":_key ,@"userId":gUserID,@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize]};
    [self showHudInView:self.view hint:@"加载中..."];
     [self.request requestCourseListWithData:dic withBlock:^(ZSCurriculumModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArray removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            _curPage = model.curPage;
             _totalPage = model.totalPages;
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
                self.curPage ++;
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
        }
        else{
            [self showHint:model.message];
            [self.tableView setShowsInfiniteScrolling:NO];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
    }
}


#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    if(_key !=nil &&_key.length>0){
        if(_curPage>_totalPage){
            [self.tableView.infiniteScrollingView stopAnimating];
            return [self  showHint:@"已经是最后一页了"];
        }
    [self showHudInView:self.view hint:@"加载中..."];
     NSString * str = [NSString stringWithFormat: @"%ld", (long)_curPage];
    
    NSDictionary * dic = @{@"name":_key ,@"userId":gUserID,@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize]};
    
     [self.request requestCourseListWithData:dic withBlock:^(ZSCurriculumModel *model, NSError *error)  {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (self.curPage < model.totalPages) {
                self.curPage ++;
            }
            [self.tableView reloadData];
        } else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}
}

-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 130.f;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    //_tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_tableView registerNib:[UINib nibWithNibName:@"ChooseCourseCell" bundle:nil] forCellReuseIdentifier:@"ChooseCourseCell"];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    ChooseCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCourseCell" forIndexPath:indexPath];
    ZSCurriculumInfo * model = _dataArray[indexPath.row];
    cell.curriculum = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
  //  StudyCourseController *destVc = [StudyCourseController new];
    ZSCurriculumInfo * model = _dataArray[indexPath.row];
//    NSLog(@"+++  %@ %@",model.courseId,self.navigationController);
//    destVc.courseId =  model.courseId;

    if(_delegate){
        [self.delegate interactData:model.courseName tag:1 data:model.courseId];
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


@end
