//
//  CertificateDetailViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CertificateDetailViewController.h"
#import "SpecialDetailViewController.h"
#import "IntroduceCell.h"
#import "CourseListCell.h"
#import "SpecialHeaderView.h"
#import "SelectClassViewController.h"
#import "TopicCourseDetailController.h"
#include "TopicCourseChooseController.h"

@interface CertificateDetailViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SpecialHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray * mustArr;
@property (nonatomic,strong) NSMutableArray * selectArr;
@property (nonatomic,strong) ZSCertificateCourseListModel * courseModel;

@end

@implementation CertificateDetailViewController

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
  //  self.navigationItem.title = @"证书详细";
    
    [self.view addSubview:self.tableView];
    _mustArr = [NSMutableArray new];
    _selectArr = [NSMutableArray new];
    [self fetchData];
    [self createRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak CertificateDetailViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    
}


#pragma mark---请求数据
- (void)fetchData
{
    
    NSDictionary * dic = @{@"certId":_cerId};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestCerDetailWith:dic withBlock:^(ZSFindListModel *model, NSError *error) {
         [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            _model = model.data;
            _headerView.nameLabel.text = _model.certificateName;
            _headerView.perNumLabel.text = [NSString stringWithFormat:@"%ld人参加",_model.joinNum];
            _headerView.scrLabel.text = [NSString stringWithFormat:@"%ld%A",_model.scoreNeed, resunit];
            [_headerView.headerImage sd_setImageWithURL:[_model.img stringToUrl]  placeholderImage:kPlaceDefautImage];
            
          
        }
        else{
            [self showHint:model.message];
            [self.tableView.pullToRefreshView stopAnimating];
            [self.tableView reloadData];
        }
    }];
    
    [self.request requestCerCourseListWith:dic withBlock:^(ZSCerCourseListModel *model, NSError *error) {
        [self hideHud];
        [_selectArr removeAllObjects];
        [_mustArr removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
            _courseModel = model.data;
            [_mustArr addObjectsFromArray:_courseModel.mustCourseList];
            [_selectArr addObjectsFromArray:_courseModel.selectCourseList];
            
          
        }
        else{
            [self showHint:model.message];
        }
        
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
       
    
}

//setup TableView
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"introduceCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"CourseListCell" bundle:nil] forCellReuseIdentifier:@"courseListCell"];
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

//创建表头
- (SpecialHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = (SpecialHeaderView *)[[[NSBundle mainBundle]loadNibNamed:@"SpecialHeaderView" owner:self options:nil]lastObject];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 230.0);
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.getCertificateLabel.hidden = YES;
        _headerView.detailBtn.hidden = YES;
        _headerView.pullUpImage.hidden = YES;
        _headerView.numLabel.hidden = YES;
        _headerView.selectClassLabel.hidden = YES;
        _headerView.moneyLabel.hidden = YES;
        _headerView.lineView.hidden = YES;
        [_headerView.detailBtn addTarget:self action:@selector(lookDetaulClick) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _headerView;
}

//查看可选班级
-(void)lookDetaulClick
{
    SelectClassViewController *vc = [SelectClassViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        if(_model.certSubject.length == 0){
            return 0;
        }
        else{
            return 1;
        }
    }
    else if(section == 2){
        return _mustArr.count;
    }
    else if(section == 3){
        return  _selectArr.count;
    }
    else if(section == 1){
        return 0;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"introduceCell" forIndexPath:indexPath];
    
        cell.introduceLabel.text = _model.certSubject;
        return cell;
    }
    else if(indexPath.section == 2){
       CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];

        cell.courseLabel.hidden = NO;

        CertificateCourseModel * model = _mustArr[indexPath.row];
        
        cell.nameLabel.text = model.courseName;
        NSString * str = [NSString stringWithFormat:@"%@: %ld", resunit,model.score];
        cell.courseLabel.attributedText = [self attributedStringByString:str color:kMainThemeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.section == 3){
        CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];

        cell.courseLabel.hidden = NO;

      
        CertificateCourseModel * model = _selectArr[indexPath.row];
        
        cell.nameLabel.text = model.courseName;
        NSString * str = [NSString stringWithFormat:@"%@: %ld",resunit,model.score];
       cell.courseLabel.attributedText = [self attributedStringByString:str color:kMainThemeColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseListCell" forIndexPath:indexPath];
        cell.nameLabel.text =_courseModel.aimCourseDesc;
        cell.nameLabel.textColor = [UIColor blackColor];
        cell.courseLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
          CGFloat height = [GetHeight getHeightWithContent:_model.certSubject width:SCREEN_WIDTH-20 font:13];
        return height;

    } else if(indexPath.section == 4){
        CGFloat height = [GetHeight getHeightWithContent:_courseModel.aimCourseDesc width:SCREEN_WIDTH-20 font:13];
        return height+20;
    }
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0){
     return 10.0f;
    }
    else if(section==1){
        return 1;
    }
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        if(_mustArr.count==0){
            return CGFLOAT_MIN;
        }
        else{
            return 30;
        }
    }
   else  if(section == 3){
        if(_selectArr.count==0){
            return CGFLOAT_MIN;
        }
        else{
            return 30;
        }
    }
    return 30.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
        titleLabel.text = @"证书介绍";
    } else  if(section ==1){
        titleLabel.text = @"证书内容";
    }else  if(section ==2){
        titleLabel.text = @"必修课";
        titleLabel.textColor = kMainThemeColor;
        lineLabel.hidden = YES;
    }
    else  if(section ==3){
        titleLabel.text = @"选修课";
        titleLabel.textColor = kMainThemeColor;
        lineLabel.hidden = YES;
    }
    else{
         titleLabel.text = @"辅修课";
        titleLabel.textColor = kMainThemeColor;
        lineLabel.hidden = YES;
    }


    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            //            TopicCourseChooseController *destVc = [[TopicCourseChooseController alloc] init];
            //            [self.navigationController pushViewController:destVc animated:YES];
        }else{
            TopicCourseDetailController *destVc = [[TopicCourseDetailController alloc] init];
            [self.navigationController pushViewController:destVc animated:YES];
            
        }
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

@end
