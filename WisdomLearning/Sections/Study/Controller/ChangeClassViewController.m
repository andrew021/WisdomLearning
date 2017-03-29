//
//  ChangeClassViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ChangeClassViewController.h"
#import "ChangeClassCell.h"
#import "FaceTeachingViewController.h"
#import "DistanceTrainingViewController.h"


@interface ChangeClassViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *clazzId;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *oclazzId;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, assign) BOOL showEmptyView;
@end

@implementation ChangeClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.clazzId = @"";
    self.oclazzId = @"";
    [self getData];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offsetCenter:) name:@"SCROLLVIEW" object:nil];
    
    //底部换班级 按钮
    _btn = [UIButton new];
    if (SCREEN_HEIGHT == 480) {
        _btn.frame = CGRectMake(10.0, self.offset - 100, SCREEN_WIDTH - 20.0, 50.0);
    } else if (SCREEN_HEIGHT == 568){
        _btn.frame = CGRectMake(10.0, self.offset - 60, SCREEN_WIDTH - 20.0, 50.0);
    } else if (SCREEN_HEIGHT == 667) {
        _btn.frame = CGRectMake(10.0, self.offset + 30, SCREEN_WIDTH - 20.0, 50.0);
    } else {
        _btn.frame = CGRectMake(10.0, self.offset + 100, SCREEN_WIDTH - 20.0, 50.0);
    }

    [_btn setBackgroundColor:kMainThemeColor];
    _btn.layer.cornerRadius = 5.0f;
    [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [_btn setTitle:@"我要换班级" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(BottomClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    [self createRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immobilization:) name:@"IMMOBILIZATION" object:nil];
    Offset *set = [Offset sharedInstance];
    if (set.offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}

- (void)immobilization:(NSNotification *)note
{
    CGFloat offset = [note.userInfo[@"OFFSET"] floatValue];
    if (offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)offsetCenter:(NSNotification *)note
{
    CGFloat offset = [note.userInfo[@"OFFSET"] floatValue];
    
    if (SCREEN_HEIGHT == 480) {
        _btn.frame = CGRectMake(10.0, offset - 100.0, SCREEN_WIDTH - 20.0, 50.0);
    } else if (SCREEN_HEIGHT == 568){
        _btn.frame = CGRectMake(10.0, offset - 60.0, SCREEN_WIDTH - 20.0, 50.0);
    } else if (SCREEN_HEIGHT == 667) {
        _btn.frame = CGRectMake(10.0, offset + 30.0, SCREEN_WIDTH - 20.0, 50.0);
    } else {
        _btn.frame = CGRectMake(10.0, offset + 100.0, SCREEN_WIDTH - 20.0, 50.0);
    }
}

-(void)BottomClick
{
    if (self.userId.length == 0) {
        [self directLoginWithSucessBlock:^{
            
        }];
        return ;
    }
    if ([self.clazzId isEqualToString:@""]) {
        [self showHint:@"请选择班级"];
        return;
    }
    
    NSDictionary *dic = @{
                          @"oclazzId":self.oclazzId,
                          @"clazzId":self.clazzId,//班级ID
                          @"userId":self.userId,//用户ID
                          };
    [self.request requestChangeClassWithDict:dic block:^(ZSModel *model, NSError *error) {
        [self showHint:model.message];
        if (model.isSuccess) {
            [self getData];
            self.clazzId = @"";
            self.oclazzId = @"";
        }
    }];
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
}


#pragma mark --- setup tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0 - 70.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ChangeClassCell" bundle:nil] forCellReuseIdentifier:@"changeClassCell"];
    }
    return _tableView;
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeClassCell * cell = [tableView dequeueReusableCellWithIdentifier:@"changeClassCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ClassList *list = _dataArray[indexPath.section];
    cell.changeList = list;
    if (list.joinFlag) {
        self.oclazzId = list.classId;
    }
    cell.clickButton.tag = indexPath.section + 100;
    [cell.clickButton addTarget:self action:@selector(clickSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassList *list = _dataArray[indexPath.section];
    if (list.joinFlag) {
        if (list.classType == 2) {
            DistanceTrainingViewController *destVc = [DistanceTrainingViewController new];
            destVc.classId = list.classId;
            [self.navigationController pushViewController:destVc animated:YES];
        } else {
            FaceTeachingViewController *destVc = [FaceTeachingViewController new];
            destVc.classId = list.classId;
            destVc.title = list.className;
            [self.navigationController pushViewController:destVc animated:YES];
        }
    } else {
        ChangeClassCell *cell = (ChangeClassCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self clickSelect:cell.clickButton];
    }
}

#pragma mark --- 选班级按钮
- (void)clickSelect:(UIButton *)sender
{
    ClassList *list = _dataArray[sender.tag - 100];
    self.clazzId = list.classId;
    self.className = list.className;
    list.isViewFlag = 1;
    for (NSInteger i = 0; i < _dataArray.count; i ++) {
        ClassList *aList = _dataArray[i];
        if (i != sender.tag - 100) {
            aList.isViewFlag = 0;
        }
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 获取数据
- (void)getData
{
    NSDictionary *dic = @{
                          @"programId":self.programId,//项目ID
                          @"userId":self.userId,//用户ID
                          };
    [self.request requestProjectClassListWithDic:dic block:^(ClassListModel *model, NSError *error) {
        self.showEmptyView = YES;
        if (model.isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.data];
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
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
    return 40.0f;
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
