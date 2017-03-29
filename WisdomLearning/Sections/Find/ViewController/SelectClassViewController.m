//
//  SelectClassViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SelectClassViewController.h"
#import "ClassSelectView.h"
#import "ClassCell.h"
#import "TopicCourseChooseController.h"
#import "UIViewController+LoadLoginView.h"

@interface SelectClassViewController () <UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ClassSelectView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *clazzId;//班级id
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) NSInteger clazzType;//班级
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation SelectClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选班级";
    self.clazzId = @"";
    self.className = @"";
    [self.view addSubview:self.tableView];
    
    [self getData];
    [self setupBottomView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 134.0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ClassCell" bundle:nil] forCellReuseIdentifier:@"classCell"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
#pragma mark ---- setup 表头
-(ClassSelectView * )headerView
{
    if (!_headerView) {
        _headerView = (ClassSelectView *)[[[NSBundle mainBundle] loadNibNamed:@"ClassSelectView" owner:self options:nil]lastObject];
        _headerView.frame =CGRectMake(0, 0, SCREEN_WIDTH, 250.0);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.details = self.transferModel;
    }
    return _headerView;
}
#pragma  mark --- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassCell *cell =[tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
    ClassList *list = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectBtn.tag = indexPath.row + 1000;
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.list = list;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *sender = (UIButton *)[cell viewWithTag:indexPath.row + 1000];
    [self selectBtnClick:sender];
}

#pragma mark --- 选班级按钮
-(void)selectBtnClick:(UIButton *)sender
{
    ClassList *list = _dataArray[sender.tag - 1000];
    self.clazzId = list.classId;
    self.className = list.className;
    self.clazzType = list.classType;
    list.isViewFlag = 1;
    for (NSInteger i = 0; i < _dataArray.count; i ++) {
        if (i != sender.tag - 1000) {
            ClassList *aList = _dataArray[i];
            aList.isViewFlag = 0;
        }
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建 底部 bottom
- (void)setupBottomView
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10.0, ViewMaxY(self.tableView) + 10.0, SCREEN_WIDTH - 20.0, 50.0)];
    [btn setBackgroundColor:kMainThemeColor];
    btn.layer.cornerRadius = 5.0f;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [btn setTitle:@"我要报名" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BottomClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)BottomClick
{
    if (gUserID.length == 0) {
        [self directLoginWithSucessBlock:^{
            
        }];
        return ;
    }
    if ([self.clazzId isEqualToString:@""]) {
        [self showHint:@"请选择班级"];
        return;
    }
    TopicCourseChooseController *vc = [TopicCourseChooseController new];
    vc.clazzId = self.clazzId;
    vc.projectId = self.transferModel.Id;
    vc.classType = self.clazzType;
    vc.courseIcon = self.transferModel.image;
    vc.className = self.className;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 获取数据
- (void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"programId":self.transferModel.Id,//项目ID
                          @"userId":gUserID,
                          };
    [self.request requestProjectClassListWithDic:dic block:^(ClassListModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
    }];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    return 180.0f;
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
