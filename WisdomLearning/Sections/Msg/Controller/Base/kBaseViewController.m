//
//  kBaseViewController.m
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "kBaseViewController.h"

@interface kBaseViewController ()

@end

@implementation kBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupBackButtonItem{
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.navigationItem setLeftBarButtonItem:addItem];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)crateTableViewWithFrame:(CGRect)rect andStyle:(UITableViewStyle)style{
    _tableView = [[UITableView alloc] initWithFrame:rect style:style];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.edges.equalTo(self.view);
    }];
  

    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}


#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (_sectionIndexTitlesForTableViewCompletion) {
        return _sectionIndexTitlesForTableViewCompletion(tableView);
    }else{
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_numberOfSectionsInTableViewCompletion) {
        return  _numberOfSectionsInTableViewCompletion(tableView);
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_numberOfRowsInSectionCompletion) {
        return _numberOfRowsInSectionCompletion(tableView, section);
    } else {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_titleForHeaderInSectionCompletion) {
        return _titleForHeaderInSectionCompletion(tableView, section);
    } else {
        return @"";
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (_sectionForSectionIndexTitleCompletion) {
        return _sectionForSectionIndexTitleCompletion(tableView, title, index);
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_cellForRowAtIndexPathCompletion) {
        return _cellForRowAtIndexPathCompletion(tableView, indexPath);
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    if (_didSelectRowAtIndexPathCompletion) {
        _didSelectRowAtIndexPathCompletion(tableView, indexPath);
    }
    return ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_viewForHeaderInSectionCompletion) {
        return _viewForHeaderInSectionCompletion(tableView, section);
    } else {
        return nil;
    }
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (_heightForRowAtIndexPathCompletion) {
        return _heightForRowAtIndexPathCompletion(tableView, indexPath);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_heightForHeaderInSectionCompletion) {
        return _heightForHeaderInSectionCompletion(tableView, section);
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_heightForFooterInSectionCompletion) {
       return _heightForFooterInSectionCompletion(tableView, section);
    } else {
        return 0;
    }
}

-(UIView *)noGroupView{
    if (!_noGroupView) {
        _noGroupView = [self viewWithNoDataHint:@"暂无群组"];
    }
    return _noGroupView;
}


-(UIView *)viewWithNoDataHint:(NSString *)noDataHint{
    UIView *noDataView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *ivImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 100,80, 95)];
    ivImage.image = [UIImage imageNamed:@"no_data"];
    UILabel *lbHint = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 30)];
    lbHint.textColor = kLineLight;
    lbHint.textAlignment = NSTextAlignmentCenter;
    
    [noDataView addSubview:lbHint];
    lbHint.text = noDataHint;
    [noDataView addSubview:ivImage];
    
    return noDataView;
}


@end
