//
//  FriendListViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "FriendListViewController.h"

@interface FriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
    
}

#pragma mark--创建TableView
-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40-50) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 420;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
