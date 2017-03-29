//
//  SpecialDetailViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SpecialDetailViewController.h"
#import "IntroduceCell.h"
#import "CourseListCell.h"
#import "SpecialHeaderView.h"
#import "SelectClassViewController.h"
#import "TopicCourseDetailController.h"
#include "TopicCourseChooseController.h"

@interface SpecialDetailViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SpecialHeaderView *headerView;
@property (nonatomic, strong)TopicsDetails *model;
@property (nonatomic, strong) GroupCourseStudy *groupModel;
@end

@implementation SpecialDetailViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
}

#pragma mark ---- setup TableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"introduceCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CourseListCell" bundle:nil] forCellReuseIdentifier:@"courseListCell"];
    }
    return _tableView;
}

#pragma mark ---- 创建表头
- (SpecialHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = (SpecialHeaderView *)[[[NSBundle mainBundle]loadNibNamed:@"SpecialHeaderView" owner:self options:nil]lastObject];
       
        _headerView.backgroundColor = [UIColor whiteColor];
        
        [_headerView.headerImage sd_setImageWithURL:[_model.image stringToUrl] placeholderImage:kPlaceDefautImage];
        _headerView.nameLabel.text = self.model.name;
        
        CGFloat height = [GetHeight getHeightWithContent:self.model.name width:SCREEN_WIDTH - 120.0 font:15.0];
        if (height > 20.0) {
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 340.0);
        } else {
            _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 320.0);
        }
        _headerView.perNumLabel.text = [NSString stringWithFormat:@"%ld人参加",self.model.joinNum];
        _headerView.scrLabel.text = [NSString stringWithFormat:@"%ld%@",self.model.scoreNeed, resunit];
        _headerView.certificateLabel.text = self.model.certificateName;
        NSString *string = [NSString stringWithFormat:@"%g%@",self.model.price, priceunit];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:string];
        [att addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length - 2)];
        _headerView.moneyLabel.attributedText = att;
        
        _headerView.numLabel.text = [NSString stringWithFormat:@"%ld个",self.model.classCount];
        
        [_headerView.detailBtn addTarget:self action:@selector(lookDetaulClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

#pragma mark ---- 查看可选班级
-(void)lookDetaulClick
{
    SelectClassViewController *vc = [SelectClassViewController new];
    vc.transferModel = self.model;
//    vc.projectId = self.projectId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return section == 1 ? self.groupModel.mustCourseList.count + 1 : self.groupModel.selectCourseList.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceCell" forIndexPath:indexPath];
        cell.introduceLabel.text = self.model.descr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.nameLabel.text =[NSString stringWithFormat:@"必修课（%ld门%ld%@）",self.groupModel.mustCourseNum,self.groupModel.mustCourseScore, resunit];
            cell.nameLabel.textColor = kMainThemeColor;
            cell.courseLabel.hidden = YES;
        } else {
            CourseList *list = self.groupModel.mustCourseList[indexPath.row - 1];
            cell.nameLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row,list.courseName];
            NSString *str = [NSString stringWithFormat:@"%@：%.f",resunit,list.score];
            cell.courseLabel.hidden = NO;
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.courseLabel.attributedText = [self attributedStringByString:str color:kMainThemeColor];
        }
        return cell;
    } else {
        CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.nameLabel.text =[NSString stringWithFormat:@"选修课（%ld门%ld%@）",self.groupModel.selectCourseNum,self.groupModel.selectCourseScore, resunit];
            cell.nameLabel.textColor = kMainThemeColor;
            cell.courseLabel.hidden = YES;
        } else {
            CourseList *list = self.groupModel.selectCourseList[indexPath.row - 1];
            cell.nameLabel.text = [NSString stringWithFormat:@"%02ld-%@",indexPath.row,list.courseName];
            NSString *str = [NSString stringWithFormat:@"%@：%.f",resunit,list.score];
            cell.courseLabel.hidden = NO;
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.courseLabel.attributedText = [self attributedStringByString:str color:kMainThemeColor];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize size =[self.model.descr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil].size;
        if (size.height < 21.0) {
            return 35.0;
        } else {
            return 20.0 + size.height;
        }
    } else {
        return 40.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return CGFLOAT_MIN;
    } else {
        return 10.0f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return CGFLOAT_MIN;
    } else {
        return 30.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return nil;
    } else {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.0)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 8, 2, 30 - 16)];
        lineLabel.backgroundColor = kMainThemeColor;
        [view addSubview:lineLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0, 4, 150.0, 21.0)];
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        [view addSubview:titleLabel];
        
        if (section == 0) {
            titleLabel.text = @"专题介绍";
        } else {
            titleLabel.text = @"专题内容";
        }
        return view;
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
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 获取数据
- (void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.zhisou.studyload", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();
    for (int i = 0; i < 2; i++) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^() {
            dispatch_group_enter(dispatchGroup);
            if (i == 0) {
                NSDictionary *dic = @{
                                      @"type":@"program",
                                      @"projectId":self.projectId,
                                      };
                [self.request requestTopicsDetailsWithDic:dic block:^(TopicsDetailsModel *model, NSError *error) {
                    [self hideHud];
                    if (model.isSuccess) {
                        [self showHint:model.message];
                        self.model = model.data;
                        dispatch_group_leave(dispatchGroup);
                    } else {
                        [self showHint:model.message];
                    }
                }];
            } else {
                NSDictionary *dict = @{
                                       @"programId":self.projectId,
                                       };
                [self.request requestProgramCourseList:dict withBlock:^(GroupCourseStudyModel *model, NSError *error) {
                    if (model.isSuccess) {
                        [self showHint:model.message];
                        self.groupModel = model.data;
                        dispatch_group_leave(dispatchGroup);
                    } else {
                        [self showHint:model.message];
                    }
                }];
            }
        });
    }
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
        [self hideHud];
        _tableView.tableHeaderView = self.headerView;
        self.navigationItem.title = self.model.name;
        [self.tableView reloadData];
    });
}

@end
