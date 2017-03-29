//
//  EvaluationRequirementsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "EvaluationRequirementsViewController.h"
#import "CurrentScoreCell.h"
#import "EvaluationRequirementsCell.h"

@interface EvaluationRequirementsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) CheckreQuirements *checkModel;
@end

@implementation EvaluationRequirementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark --- getData
-(void)getData
{
    NSDictionary *dict = @{
                           @"userId":gUserID,
                           @"clazzId":self.clazzId,
                           };
    [self.request requestOnLineClassCheckWithdict:dict block:^(CheckreQuirementsModel *model, NSError *error) {
        if (model.isSuccess) {
            self.checkModel = model.data;
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
    }];
}

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1.0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CurrentScoreCell" bundle:nil] forCellReuseIdentifier:@"currentScoreCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"EvaluationRequirementsCell" bundle:nil] forCellReuseIdentifier:@"evaluationRequirementsCell"];
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
//区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//区内行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : self.checkModel.details.count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CurrentScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"currentScoreCell" forIndexPath:indexPath];
        cell.scoreLabel.text = [NSString stringWithFormat:@"%g分",self.checkModel.score];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        EvaluationRequirementsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaluationRequirementsCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CheckList * list = self.checkModel.details[indexPath.row];
        if ([list.type isEqualToString:@"kcxx"]) {
            cell.headerImage.image = [UIImage imageNamed:@"courseLearn_icon"];
        } else if ([list.type isEqualToString:@"khzy"]) {
            cell.headerImage.image = [UIImage imageNamed:@"courseWork_icon"];
        } else if ([list.type isEqualToString:@"ltyt"]) {
            cell.headerImage.image = [UIImage imageNamed:@"tribune_icon"];
        } else if ([list.type isEqualToString:@"ydjb"]) {
            cell.headerImage.image = [UIImage imageNamed:@"readBriefing_icon"];
        } else if ([list.type isEqualToString:@"yxrz"]) {
            cell.headerImage.image = [UIImage imageNamed:@"offline_test"];
        } else if ([list.type isEqualToString:@"kccy"]) {
            cell.headerImage.image = [UIImage imageNamed:@"courseTest_icon"];
        }
        cell.titleLabel.text = list.checkName;
        cell.couresLabel.text = [NSString stringWithFormat:@"%g分/%@",list.myScore,list.realRes];
        cell.standLabel.text = [NSString stringWithFormat:@"标准：%@",list.desc];
        return cell;
    }
}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
         CGFloat height = [GetHeight getHeightWithContent:self.checkModel.khDesc width:SCREEN_WIDTH-30 font:13];
        return height+10;
    } else {
        return CGFLOAT_MIN;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat height = [GetHeight getHeightWithContent:self.checkModel.khDesc width:SCREEN_WIDTH - 30.0 font:13.0f];
        return 10.0f + height;
    } else {
        CheckList * list = self.checkModel.details[indexPath.row];
        CGFloat height = [GetHeight getHeightWithContent:[NSString stringWithFormat:@"标准：%@",list.desc] width:SCREEN_WIDTH - 65.0 font:12.0f];
        return 50.0f +height;
    }
}
//自定义
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGFloat height = [GetHeight getHeightWithContent:self.checkModel.khDesc width:SCREEN_WIDTH - 30.0 font:13.0f];
        
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0 + height)];
        v.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5, SCREEN_WIDTH - 30.0, height)];
        label.numberOfLines = 0;
        label.text = self.checkModel.khDesc;
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor grayColor];
        [v addSubview:label];
        
        return v;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckList * list = self.checkModel.details[indexPath.row];
    if ([list.type isEqualToString:@"kcxx"]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"kcxx", @"change", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeIndex" object:self userInfo:dic];
    } else if ([list.type isEqualToString:@"khzy"]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"khzy", @"change", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeIndex" object:self userInfo:dic];
    } else if ([list.type isEqualToString:@"kccy"]) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"kccy", @"change", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeIndex" object:self userInfo:dic];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
