//
//  CourseLearnViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CourseLearnViewController.h"
#import "CourseLearnCell.h"
#import "CourseStudyViewController.h"

@interface CourseLearnViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) GroupCourseStudy *groupModel;
@end

@implementation CourseLearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:self.tableView];
    
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark --- init data
-(void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    
//    NSLog(@"___%@__%@___%@",self.userId,self.objectId,self.type)
    NSDictionary *dic = @{
//                          @"curPage":@"1",//页码，从1开始，默认1
//                          @"perPage":@"100",//每页记录数，默认10
                          @"userId":self.userId,//用户ID
                          @"objectId":self.objectId,//对象ID
                          @"type":self.type,//班级：class，个人专题：program，学习圈：circle
                          };
    
    [self.request requestOnlineGroupCourseListWithDic:dic block:^(GroupCourseStudyModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            self.groupModel = model.data;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0) style:UITableViewStyleGrouped];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"CourseLearnCell" bundle:nil] forCellReuseIdentifier:@"courseLearnCell"];
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
    return section == 0 ? self.groupModel.mustCourseList.count : self.groupModel.selectCourseList.count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseLearnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseLearnCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.studyBtn.hidden = YES;
        CourseList *list = self.groupModel.mustCourseList[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.courseName];
//        cell.cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 18, 3, 18);
        [cell.cancelBtn setImage:[ThemeInsteadTool imageWithImageName:@"start_study"] forState:UIControlStateNormal];
//        cell.cancelBtn.tag = indexPath.row;
//        [cell.cancelBtn addTarget:self action:@selector(studyClick:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.studyBtn.hidden = NO;
        CourseList *list = self.groupModel.selectCourseList[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.courseName];
        cell.cancelBtn.tag = indexPath.row;
        cell.studyBtn.tag = indexPath.row;
        
        [cell.studyBtn addTarget:self action:@selector(studySelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        cell.cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
//        cell.studyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        [cell.cancelBtn setImage:[ThemeInsteadTool imageWithImageName:@"cancel_choose"] forState:UIControlStateNormal];
        [cell.studyBtn setImage:[ThemeInsteadTool imageWithImageName:@"start_study"] forState:UIControlStateNormal];
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        CourseList *list = self.groupModel.mustCourseList[indexPath.row];
//        CourseStudyViewController *vc = [CourseStudyViewController new];
//        vc.courseId = list.courseId;
//        vc.classId = self.objectId;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
//高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
//自定义
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)];
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5, SCREEN_WIDTH - 30.0, 34.0)];
    if (section == 0) {
        label.text = [NSString stringWithFormat:@"必修课（%ld门%ld%@）",self.groupModel.mustCourseNum,self.groupModel.mustCourseScore, resunit];
    } else {
        label.text = [NSString stringWithFormat:@"选修课（%ld门%ld%@）",self.groupModel.selectCourseNum,self.groupModel.selectCourseScore, resunit];
    }
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = kMainThemeColor;;
    [v addSubview:label];
    
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourseLearnCell *cell = (CourseLearnCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        [self studyClick:cell.cancelBtn];
    }
}

#pragma mark ---
- (void)studyClick:(UIButton *)sender
{
    CourseList *list = self.groupModel.mustCourseList[sender.tag];
    CourseStudyViewController *vc = [CourseStudyViewController new];
    vc.courseId = list.courseId;
    vc.title = list.courseName;
    vc.classId = self.objectId;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)studySelectClick:(UIButton *)sender
{
    CourseList *list = self.groupModel.selectCourseList[sender.tag];
    CourseStudyViewController *vc = [CourseStudyViewController new];
    vc.courseId = list.courseId;
     vc.title = list.courseName;
    vc.classId = self.objectId;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)cancelClick:(UIButton *)sender{
//    //取消选课
//    CourseList *list = self.groupModel.selectCourseList[sender.tag];
//    NSDictionary *dict = @{@"userId":gUserID, @"courseId":list.courseId, @"clazzId":self.objectId};
//    [self.request cancelChooseCourseWithDict:dict block:^(ZSModel *model, NSError *error) {
//        [self showHint:model.message];
//        if (model.isSuccess) {
//            [self.groupModel.selectCourseList removeObjectAtIndex:sender.tag];
//            [self.tableView reloadData];
//        }
//    }];
//    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""message:@"确定删除课程吗？"preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消选课
        CourseList *list = self.groupModel.selectCourseList[sender.tag];
        NSDictionary *dict = @{@"userId":gUserID, @"courseId":list.courseId, @"clazzId":self.objectId};
        [self.request cancelChooseCourseWithDict:dict block:^(ZSModel *model, NSError *error) {
            [self showHint:model.message];
            if (model.isSuccess) {
                [self.groupModel.selectCourseList removeObjectAtIndex:sender.tag];
                [self.tableView reloadData];
            }
        }];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];

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
