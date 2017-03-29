//
//  SystemMessageViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//系统消息

#import "SystemMessageViewController.h"
#import "SystemMessageCell.h"
#import "LXAlipayViewController.h"
#import "DynDetailsViewController.h"
#import "PersonalDetailsViewController.h"
#import "CourseStudyViewController.h"
#import "ChangeClassViewController.h"
#import "FaceTeachingViewController.h"
#import "DistanceTrainingViewController.h"
#import "JobTestViewController.h"
#import "WebViewViewController.h"

@interface SystemMessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic,strong) NSMutableArray * dataArr;
@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.dataArr = [[NSMutableArray alloc]init];
    [self fetchData];
    [self createRefresh];

    
}




#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak SystemMessageViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark---请求数据
- (void)fetchData
{
    kPageNum = 1;
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    NSDictionary * dic = nil;
    if(self.type == nil || self.objectId == nil){
         dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"userId":gUserID};
    }
    else{
         dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"userId":gUserID,@"objectId":self.objectId,@"type":self.type};
    }
  
    [self showHudInView:self.view hint:@"加载中..."];
    
    [self.request requesSystemMsgWithDict:dic Block:^(ZSSystemMsgModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            _totalPage = model.totalPages;
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
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

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    NSInteger page = _curPage+1;
    if(page>_totalPage){
        [self.tableView.infiniteScrollingView stopAnimating];
        return [self  showHint:@"已经是最后一页了"];
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)page];
    NSDictionary * dic = nil;
    if(self.type == nil || self.objectId == nil){
        dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"userId":gUserID};
    }
    else{
        dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"userId":gUserID,@"objectId":self.objectId,@"type":self.type};
    }
    
    [self.request requesSystemMsgWithDict:dic Block:^(ZSSystemMsgModel *model, NSError *error) {
        [self hideHud];
        
        if(model.isSuccess){
            [self showHint:model.message];
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            [self.tableView reloadData];
            
        }
        else{
            [self showHint:model.message];
            
        }
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
      [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString* identifier = @"SystemMessageCell";
    SystemMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SystemMsgModel * model = _dataArr[indexPath.row];
//    cell.nameLabel.text = model.senderName;
//    cell.
    cell.model = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemMsgModel * model = _dataArr[indexPath.row];

    CGFloat height = [GetHeight getHeightWithContent:model.content width:SCREEN_WIDTH-80 font:14];
    
    return height + 50;
    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     SystemMsgModel * model = _dataArr[indexPath.row];
    if(model.type == 1 || model.type == 2 || model.type == 7){
        if(model.clazzType == 1){
            FaceTeachingViewController * vc = [[FaceTeachingViewController alloc]init];
            vc.classId = model.clazzId;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            DistanceTrainingViewController * vc = [[DistanceTrainingViewController alloc]init];
            vc.classId = model.clazzId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if(model.type == 3){
        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
        vc.projectId = model.programId;
        vc.classId = model.clazzId;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(model.type == 4 || model.type == 6){
        CourseStudyViewController * vc = [[CourseStudyViewController alloc]init];
        vc.courseId = model.courseId;
        vc.classId = model.clazzId;
        vc.title = @"课程学习";
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(model.type == 5){
        DynDetailsViewController * vc = [[DynDetailsViewController alloc]init];
        
        vc.ID = model.newsId;
        vc.isCreateImg = NO;
        vc.type = 1;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        WebViewViewController * vc = [[WebViewViewController alloc]init];
        
        if(model.type == 8){
           // self.title = @"测验列表";
             vc.urlStr = model.testUrl;
        }
        else{
            vc.urlStr = model.homeworkUrl;
          //  self.title = @"作业列表";
        }
       
        vc.title = model.senderName;
        [self.navigationController pushViewController:vc animated:YES];
//        JobTestViewController * vc = [[JobTestViewController alloc]init];
//        vc.objectId = model.;
//        vc.type = @"class";
      
       
        [self.navigationController pushViewController:vc animated:YES];
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
