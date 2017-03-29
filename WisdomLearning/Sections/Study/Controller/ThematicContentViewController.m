//
//  ThematicContentViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ThematicContentViewController.h"
#import "CourseListCell.h"
#import "TopicCourseDetailController.h"
#import "CourseStudyViewController.h"


@interface ThematicContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GroupCourseStudy *groupModel;
@end

@implementation ThematicContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self getData];
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
#pragma mark---创建刷新
- (void)createRefresh
{
    __weak ThematicContentViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf getData];
    }];
}

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0 - 75.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"CourseListCell" bundle:nil] forCellReuseIdentifier:@"courseListCell"];
    }
    return _tableView;
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.groupModel.mustCourseList.count;
    } else {
        return self.groupModel.selectCourseList.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        CourseList * list = self.groupModel.mustCourseList[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.courseName];
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.courseLabel.hidden = NO;
        NSString *storeStr = [NSString stringWithFormat:@"%@：%ld",resunit,list.courseScore];
        cell.courseLabel.attributedText = [self attributedStringByString:storeStr color:kMainThemeColor];
    } else {
        CourseList * list = self.groupModel.selectCourseList[indexPath.row];
        cell.nameLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row + 1,list.courseName];
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.courseLabel.hidden = NO;
        NSString *storeStr = [NSString stringWithFormat:@"%@：%ld",resunit,list.courseScore];
        cell.courseLabel.attributedText = [self attributedStringByString:storeStr color:kMainThemeColor];
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 5.0, SCREEN_WIDTH - 60.0, 20.0)];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = kMainThemeColor;
    if (section == 0) {
        label.text = [NSString stringWithFormat:@"必修课(%ld门%ld%@)",self.groupModel.mustCourseNum,self.groupModel.mustCourseScore, resunit];
    } else {
        label.text = [NSString stringWithFormat:@"选修课(%ld门%ld%@)",self.groupModel.selectCourseNum,self.groupModel.selectCourseScore, resunit];
    }
    [v addSubview:label];
    
    return v;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CourseList *list;
    if (indexPath.section == 0) {
        list = self.groupModel.mustCourseList[indexPath.row];
    } else {
        list = self.groupModel.selectCourseList[indexPath.row];
    }
   
    if (self.classId == nil) {
        self.classId = self.groupModel.clazzId;
    }
    if (list.onlined) {
      
       // if (indexPath.row != _courses.count) {
            CourseStudyViewController *destVc = [CourseStudyViewController new];
        destVc.classId = self.classId;
            destVc.courseId = list.courseId;
            destVc.title = list.courseName;
            [self.navigationController pushViewController:destVc animated:YES];
       // }
    } else {
        TopicCourseDetailController *destVc = [[TopicCourseDetailController alloc] init];
        destVc.courseId = list.courseId;
        destVc.navigationItem.title = list.courseName;
        destVc.classId  = self.classId;
        [self.navigationController pushViewController:destVc animated:YES];
    }
   
}

//富文本 颜色
- (NSAttributedString *)attributedStringByString:(NSString *)string color:(UIColor *)color
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttributes:@{NSForegroundColorAttributeName : color} range:NSMakeRange(3, string.length - 3)];
    return att;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- init data
-(void)getData
{
    NSDictionary *dic = @{
//                          @"curPage":@"",//页码，从1开始，默认1
//                          @"perPage":@"",//每页记录数，默认10
                          @"userId":gUserID,//用户ID
                          @"objectId":self.objectId,//对象ID
                          @"type":self.objectType,//班级：class，个人专题：program，学习圈：circle
                          };
    [self.request requestOnlineGroupCourseListWithDic:dic block:^(GroupCourseStudyModel *model, NSError *error) {
        if (model.isSuccess) {
            self.groupModel = model.data;
            [self.tableView reloadData];
        } else {
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
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
