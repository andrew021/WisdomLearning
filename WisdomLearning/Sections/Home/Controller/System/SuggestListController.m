//
//  SuggestListController.m
//  WisdomLearning
//
//  Created by DiorSama on 2017/1/23.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "SuggestListController.h"
#import "SystemMessageCell.h"
#import "AdviceBackViewController.h"


@interface SuggestListController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end
@implementation SuggestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    self.title = @"意见反馈";
    UIButton *publishBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [publishBtn setImage:[UIImage imageNamed:@"per_put"] forState:UIControlStateNormal];
    [publishBtn addTarget:self action:@selector(publishBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
}

-(void)publishBtn
{
    AdviceBackViewController* adviceBackVC = [[AdviceBackViewController alloc] init];
    [self.navigationController pushViewController:adviceBackVC animated:YES];
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
    return 8;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    static NSString* identifier = @"SystemMessageCell";
    SystemMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SystemMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    SystemMsgModel * model = _dataArr[indexPath.row];
//    cell.model = model;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SystemMsgModel * model = _dataArr[indexPath.row];
//    
//    CGFloat height = [GetHeight getHeightWithContent:model.content width:SCREEN_WIDTH-80 font:14];
//    
//    return height + 50;
    return 50;
    
    
}

@end
