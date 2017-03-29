//
//  JobTestViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "JobTestViewController.h"
#import "CourseLearnCell.h"
#import "CourseLearnTextCell.h"
#import "TestResultController.h"
#import "WorkTestViewController.h"
#import "WebViewViewController.h"

extern const CGFloat playerViewHeight;
extern const CGFloat commentViewHeight;

@interface JobTestViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) TestHomework *testModel;
@end

@implementation JobTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
    if (_courseStduyCotroller) {
        _courseStduyCotroller.bShowCommentView = YES;
    }
    [self getData];
    
}

#pragma mark ---- 获取数据
- (void) getData
{
    NSDictionary *dic = @{ @"userId":gUserID,//用户ID
                           @"objectId":self.objectId,//对象ID
                           @"type":self.type,//区分是班级的还是项目。班级：class，项目:program
                           };
    
    [self.request requestOnlineClassTestHomeworkListWithDic:dic block:^(TestHomeworkModel *model, NSError *error) {
        if (model.isSuccess) {
            self.testModel = model.data;
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}


#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        if (_courseStduyCotroller != nil) {
//            SCREEN_HEIGHT-playerViewHeight-commentViewHeight-40-64
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-playerViewHeight-commentViewHeight-40-64) style:UITableViewStyleGrouped];
            _tableView.backgroundColor = [UIColor whiteColor];
        }else{
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 -75.0) style:UITableViewStyleGrouped];
        }
       
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CourseLearnCell" bundle:nil] forCellReuseIdentifier:@"courseLearnCell1"];
        [_tableView registerNib:[UINib nibWithNibName:@"CourseLearnCell" bundle:nil] forCellReuseIdentifier:@"courseLearnCell2"];
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
    return section == 0 ? self.testModel.homeworkList.count : self.testModel.testList.count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CourseLearnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseLearnCell2" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.studyBtn.hidden = YES;
        cell.cancelBtn.layer.cornerRadius = 5.0;
        cell.cancelBtn.layer.borderWidth = 1.0;
        cell.cancelBtn.layer.borderColor = kMainThemeColor.CGColor;
        
        TestWorkList *list = self.testModel.homeworkList[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.homeworkName];
        if (list.status == 1) {
            [cell.cancelBtn setTitle:@" 查看成绩 " forState:UIControlStateNormal];
        } else {
            [cell.cancelBtn setTitle:@" 写作业 " forState:UIControlStateNormal];
        }
        cell.cancelBtn.tag = indexPath.row;
        [cell.cancelBtn addTarget:self action:@selector(homeworkClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else {
        CourseLearnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseLearnCell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.studyBtn.hidden = YES;
        cell.cancelBtn.layer.cornerRadius = 5.0;
        cell.cancelBtn.layer.borderWidth = 1.0;
        cell.cancelBtn.layer.borderColor = kMainThemeColor.CGColor;
        
        TestWorkList *list = self.testModel.testList[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.testName];
        // if (list.hasTest == 1) {  02 12 改动 许
        cell.cancelBtn.enabled = YES;
        if (list.status == 1) {
            [cell.cancelBtn setTitle:@"  查看成绩 " forState:UIControlStateNormal];
        } else {
            [cell.cancelBtn setTitle:@" 开始测试 " forState:UIControlStateNormal];
        }
        //        } else {
        //            cell.cancelBtn.enabled = NO;
        //            [cell.cancelBtn setTitle:@" 暂无测验 " forState:UIControlStateNormal];
        //        }
        
        cell.cancelBtn.tag = indexPath.row;
        [cell.cancelBtn addTarget:self action:@selector(testClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.testModel.homeworkList.count == 0 ? CGFLOAT_MIN : 44.0f;
    } else {
        return self.testModel.testList.count == 0 ? CGFLOAT_MIN : 44.0f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
//自定义
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.testModel.homeworkList.count == 0) {
            return nil;
        } else {
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
            v.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5, SCREEN_WIDTH - 30.0, 34.0)];
            label.text = @"作业";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = kMainThemeColor;;
            [v addSubview:label];
            return v;
        }
    } else {
        if (self.testModel.testList.count == 0) {
            return nil;
        } else {
            UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
            v.backgroundColor = [UIColor whiteColor];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5, SCREEN_WIDTH - 30.0, 34.0)];
            label.text = @"测验";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = kMainThemeColor;;
            [v addSubview:label];
            return v;
        }
    }
}

#pragma mark --- 按钮响应
- (void)testClick:(UIButton *)sender
{
    TestWorkList *list = self.testModel.testList[sender.tag];
    WebViewViewController *vc = [WebViewViewController new];
   // if (list.finished) 02 12 改动 许
    if(list.status ==1){
        vc.urlStr = list.testResUrl;
    } else {
        vc.urlStr = list.testUrl;
    }
    vc.title = list.testName;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)homeworkClick:(UIButton *)sender
{
    TestWorkList *list = self.testModel.homeworkList[sender.tag];
    WebViewViewController *vc = [[WebViewViewController alloc]init];
    vc.urlStr = list.viewUrl;
    vc.title = list.homeworkName;
    [self.navigationController pushViewController:vc animated:YES];
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
