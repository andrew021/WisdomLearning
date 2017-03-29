//
//  TopicCourseChooseController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TopicCourseChooseController.h"
#import "TopicCourseChooseCell.h"
#import "OrderConfirmCOntroller.h"
#import "DistanceTrainingViewController.h"
#import "FaceTeachingViewController.h"

@interface TopicCourseChooseController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *assureView;

@property (nonatomic, strong) NSMutableArray <CourseList *> *mustCourseList;//必修课表
@property (nonatomic, strong) NSMutableArray <CourseList *> *selectCourseList;//选修课表
@property (nonatomic, strong) UILabel *scroeLabel;
@property (nonatomic, assign) double scroe,money;
@property (nonatomic, copy) NSString *mustCourseId, *selectCourseId;
@property (nonatomic, assign) NSInteger choseNum;

@end

@implementation TopicCourseChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程选择";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scroe = 0.0;
    self.money = 0.0;
    _choseNum = 0;
    self.mustCourseId = @"";
    self.selectCourseId = @"";
    
    NSDictionary *dict = @{
                           @"programId":self.projectId,
                           @"clazzId":self.clazzId,
                           };
    [self.request requestProgramCourseList:dict withBlock:^(GroupCourseStudyModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            _mustCourseList = model.data.mustCourseList;
            _selectCourseList = model.data.selectCourseList;
            
            [self.view addSubview:self.tableView];
            
//            [_tableView reloadData];
        }else{
            [self showHint:model.message];
        }
        [self.view addSubview:self.assureView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- lazy method
-(UIView *)assureView{
    if (!_assureView) {
        _assureView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60-64, SCREEN_WIDTH, 60)];
        _assureView.layer.borderColor = [UIColor colorWithHexString:@"b6b6b6"].CGColor;
        _assureView.layer.borderWidth = 1;
        _assureView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
        _scroeLabel = [[UILabel alloc] init];
        _scroeLabel.textColor = KMainOrange;
        _scroeLabel.font = [UIFont systemFontOfSize:13.0f];
        [_assureView addSubview:_scroeLabel];
        [_scroeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_assureView);
            make.left.equalTo(_assureView.mas_left).offset(10);
            make.height.equalTo(@30);
        }];
        
        for (NSInteger i = 0; i < _mustCourseList.count; i ++) {
            CourseList *list = _mustCourseList[i];
            _choseNum += 1;
            _scroe = list.score + _scroe;
            _money = list.learnCurrency  + _money;
            if ([self.mustCourseId isEqualToString:@""]) {
                self.mustCourseId = list.courseId;
            } else {
                self.mustCourseId = [NSString stringWithFormat:@"%@,%@",self.mustCourseId,list.courseId];
            }
        }
        
        _scroeLabel.attributedText = [[NSString stringWithFormat:@"已选课程%g%@，%.f%@",_money,priceunit,_scroe,resunit] takeString:@"已选课程" toColor:[UIColor colorWithHexString:@"000000"] isBefore:NO];
        
        UIButton *assureBtn = [[UIButton alloc] init];
        [_assureView addSubview:assureBtn];
        [assureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_assureView);
            make.right.equalTo(_assureView.mas_right).offset(-10);
            make.height.equalTo(@45);
            make.width.equalTo(@125);
        }];
        assureBtn.backgroundColor = kMainThemeColor;
        [assureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [assureBtn addTarget:self action:@selector(projectEnrollClick) forControlEvents:UIControlEventTouchUpInside];
        assureBtn.layer.cornerRadius = 6;
    }
    return _assureView;
}

#pragma mark ---- 提交报名
- (void)projectEnrollClick
{
    NSString * courseStr = @"";
    if ([self.mustCourseId isEqualToString:@""]) {
        courseStr = self.selectCourseId;
    } else if ([self.selectCourseId isEqualToString:@""]) {
        courseStr = self.mustCourseId;
    } else {
        courseStr = [NSString stringWithFormat:@"%@,%@",self.mustCourseId,self.selectCourseId];
    }
    
    if (self.money == 0) {   //如果不需要金币，则直接报名
        NSDictionary *dict = @{
                               @"userId":gUserID,//用户ID
                               @"clazzId":self.clazzId,//班级ID
                               @"courseStr":courseStr,//课程
                               };
        [self.request requestProjectEnrollWithDic:dict block:^(ZSModel *model, NSError *error) {
            if (model.isSuccess) {
                [self showHint:model.message];
                if (self.classType == 1) {
                    FaceTeachingViewController *faceVC = [FaceTeachingViewController new];
                    faceVC.classId = self.clazzId;
                    [self.navigationController pushViewController:faceVC animated:YES];
                } else {
                    DistanceTrainingViewController *vc = [DistanceTrainingViewController new];
                    vc.classId = self.clazzId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self showHint:model.message];
            }
        }];

    }else{  //需要金币，用金币支付或钞票支付
        OrderConfirmCOntroller *destVc = [[OrderConfirmCOntroller alloc] init];
        destVc.isFromSign = YES;
        destVc.courseId = courseStr;
        destVc.coursePrice = self.money;
        destVc.clazzId = self.clazzId;
        destVc.clazzType = self.classType;
        destVc.courseIcon = self.courseIcon;
        destVc.orderDesc = [NSString stringWithFormat:@"%@  已选%li门课程，%g%@", _className,_choseNum,_scroe, resunit];
        [self.navigationController pushViewController:destVc animated:YES];
    }
}


#pragma mark --tableview
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:@"TopicCourseChooseCell" bundle:nil] forCellReuseIdentifier:@"TopicCourseChooseCell"];
    }
    return _tableView;
}

#pragma mark  --tableview delegate && tableview datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _mustCourseList.count;
    }else{
        return _selectCourseList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CourseList *course = nil;
    if (indexPath.section == 0) {
        course = _mustCourseList[indexPath.row];
    }else{
        course = _selectCourseList[indexPath.row];
    }
    
   CGSize size = [course.courseName sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(SCREEN_WIDTH-60, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height +　70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20.0)];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 2, 150.0, 20.0)];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    [view addSubview:titleLabel];
    
    if (section == 0) {
        titleLabel.text = @"必修课";
    } else {
        titleLabel.text = @"选修课";
    }
    
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TopicCourseChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopicCourseChooseCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.course = _mustCourseList[indexPath.row];
        [cell.selectButton setImage:[UIImage imageNamed:@"gary_select"] forState:UIControlStateNormal];
        cell.selectButton.enabled = NO;
    }else{
        cell.selectButton.enabled = YES;
        cell.course = _selectCourseList[indexPath.row];
        [cell.selectButton setImage:[ThemeInsteadTool imageWithImageName:@"blue_circle"] forState:UIControlStateNormal];
        [cell.selectButton setImage:[ThemeInsteadTool imageWithImageName:@"selected"] forState:UIControlStateSelected];
        cell.selectButton.tag = indexPath.row + 1;
        [cell.selectButton addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *sender = (UIButton *)[cell viewWithTag:indexPath.row + 1];
        [self selectClick:sender];
    }
}

- (void)selectClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    CourseList *list = _selectCourseList[sender.tag - 1];
    if (sender.selected) {
        if ([self.selectCourseId isEqualToString:@""]) {
            self.selectCourseId = list.courseId;
        } else {
            self.selectCourseId = [NSString stringWithFormat:@"%@,%@",self.selectCourseId,list.courseId];
        }
        _money += list.learnCurrency;
        _scroe += list.score;
        _choseNum += 1;
    } else {
        _money -= list.learnCurrency;
        _scroe -= list.score;
        _choseNum -= 1;
        NSMutableArray *IdArray = [NSMutableArray array];
        [IdArray addObjectsFromArray:[self.selectCourseId componentsSeparatedByString:@","]];
        for (long i = 0; i < IdArray.count; i ++) {
            if ([IdArray[i] isEqualToString:list.courseId]) {
                [IdArray removeObjectAtIndex:i];
                self.selectCourseId = @"";
                for (long j = 0; j < IdArray.count; j ++) {
                    if (j == 0) {
                        self.selectCourseId = IdArray[j];
                    } else {
                        self.selectCourseId = [NSString stringWithFormat:@"%@,%@",self.selectCourseId,IdArray[j]];
                    }
                }
            }
        }
    }
    
    _scroeLabel.attributedText = [[NSString stringWithFormat:@"已选课程%g%@，%g%@",_money,priceunit,_scroe, resunit] takeString:@"已选课程" toColor:[UIColor colorWithHexString:@"000000"] isBefore:NO];
}

@end
