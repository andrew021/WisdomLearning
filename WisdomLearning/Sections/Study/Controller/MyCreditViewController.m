//
//  MyCreditViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//我的学分

#import "MyCreditViewController.h"
#import "CreditHeadCell.h"
#import "CreditListTableViewCell.h"
#import "TestResultController.h"
#import "RechargeViewController.h"
#import "WorkTestViewController.h"
#import "StudyModel.h"

@interface MyCreditViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign)long totalScore;
@property (nonatomic,strong) UserStudyinfo * infoModel;

@end

@implementation MyCreditViewController

- (UITableView *) tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView. delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [@"我的" add:resunit];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
//    self.view.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    _dataArr = [[NSMutableArray alloc]init];
    _tableView.showsVerticalScrollIndicator = NO;
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak MyCreditViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
}

#pragma mark---请求数据
- (void)fetchData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary * dic =@{@"userId":gUserID};
    [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
        if (model.isSuccess) {
            self.infoModel = model.data;
            [self.request requestMyCreditWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
                [self hideHud];
                [_dataArr removeAllObjects];
                if(model.isSuccess){
                    [self showHint:model.message];
                    _totalScore = model.score;
                    [_dataArr addObjectsFromArray:model.pageData];
                }else{
                    [self showHint:model.message];
                }
                  [self.tableView.pullToRefreshView stopAnimating];
                [self.tableView reloadData];
            }];
        } else {
            [self showHint:model.message];
        }
    }];

//    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.zhisou.studyload", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t dispatchGroup = dispatch_group_create();
//    for (int i = 0; i < 2; i++) {
//        dispatch_group_async(dispatchGroup, dispatchQueue, ^() {
//            dispatch_group_enter(dispatchGroup);
//            if (i == 0) {
//                [self.request requestMyCreditWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
//                    [self hideHud];
//                    [_dataArr removeAllObjects];
//                    if(model.isSuccess){
//                        _totalScore = model.score;
//                        [_dataArr addObjectsFromArray:model.pageData];
//                    }else{
//                        [self showHint:model.message];
//                    }
//                  //  [self.tableView.pullToRefreshView stopAnimating];
//                    //[self.tableView reloadData];
//                }];
//            } else {
//                [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
//                    if (model.isSuccess) {
//                        self.infoModel = model.data;
//                        dispatch_group_leave(dispatchGroup);
//                    } else {
//                        [self showHint:model.message];
//                    }
//                }];
//            }
//        });
//    }
//    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
//        [self hideHud];
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView reloadData];
//    });
    
//    [self.request requestMyCreditWithDic:dic block:^(ZSMyCreditModel *model, NSError *error) {
//        [self hideHud];
//        [_dataArr removeAllObjects];
//        if(model.isSuccess){
//            _totalScore = model.score;
//            [_dataArr addObjectsFromArray:model.pageData];
//        }else{
//            [self showHint:model.message];
//        }
//        [self.tableView.pullToRefreshView stopAnimating];
//        [self.tableView reloadData];
//    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1){
        return _dataArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString* cellIdentifier = @"CreditHeadCellIdentity";
        CreditHeadCell* cell = (CreditHeadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreditHeadCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headImageView.image = [UIImage imageNamed:@"myCredit_icon"];
//        NSString *sss = [@"我的" add:resunit];
        cell.creditLabel.text = [NSString stringWithFormat:@"%@: %.f",resunit,self.infoModel.learningScore];
        return cell;
    }
    else{
        static NSString* cellIdentifier = @"CreditListCellIdentity";
        CreditListTableViewCell* cell = (CreditListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreditListTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.model = _dataArr[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 120;
    }
    else{
        return 68;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
