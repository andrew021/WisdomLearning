//
//  RechargeViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "RechargeViewController.h"
#import "RechargeCell.h"
#import "PayKindTableViewCell.h"
#import "MyCurrencyViewController.h"



@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate>{
    RechargeCell *rechargeCell;
}

@property (nonatomic, strong) NSMutableArray *payIcons;
@property (nonatomic, strong) NSMutableArray *payTitles;
@property (nonatomic,strong) UITableView * tableView;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    self.title = @"充值";
    
    UITapGestureRecognizer *tr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tr.delegate=self;
    [self.view addGestureRecognizer:tr];
    
    [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            NSNumber *coinNumber = [NSNumber numberWithLong:model.data.learnCurrency];
            rechargeCell.userLearnCoin = [coinNumber stringValue];
        } else {
            [self showHint:model.message];
        }
    }];
    
    _payIcons = @[].mutableCopy;
    _payTitles = @[].mutableCopy;
    
    for (NSString *name in payPaths) {
        if ([name isEqualToString:@"ali"]) {
            [_payIcons addObject:@"pay_icon"];
            [_payTitles addObject:@"支付宝支付"];
        }else if ([name isEqualToString:@"wx"]){
            [_payIcons addObject:@"weixin_icon"];
            [_payTitles addObject:@"微信支付"];
        }else if ([name isEqualToString:@"union"]){
            [_payIcons addObject:@"unionpay_icon"];
            [_payTitles addObject:@"银联支付"];
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//判断如果点击的是tableView的cell，就把手势给关闭了
        [Tool hideKeyBoard];
        return NO;//关闭手势
    }//否则手势存在
    return YES;
}

-(void)tap:(UITapGestureRecognizer *)tr{
    [Tool hideKeyBoard];
}

//setup TableView
-(void)createTableView
{
   
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 250;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1){
        return payPaths.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        static NSString* cellIdentifier = @"RechargeCellIdentity";
        RechargeCell* cell = (RechargeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RechargeCell" owner:nil options:nil] lastObject];
        }
        rechargeCell = cell;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        static NSString* cellIdentifier = @"payKindCellIdentity";
        PayKindTableViewCell* cell = (PayKindTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayKindTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.payIcon.image = [UIImage imageNamed:_payIcons[indexPath.row]];
        cell.payLabel.text = _payTitles[indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        NSString *moneyNum = rechargeCell.moneyNum;
        if (rechargeCell.otherNumTf.isHidden == NO) {
            moneyNum = rechargeCell.otherNumTf.text;
            moneyNum = [NSString stringWithFormat:@"%.2f", [moneyNum floatValue]/coinrule];
        }
        Hint(moneyNum, @"请输入学币数额");
        
        NSDictionary *dict = @{@"userId":gUserID, @"putmoney":moneyNum, @"useCoin":@"0",@"clazzId":@"0"};
        [[ZSPay instance] payCourseWithPayType:payPaths[indexPath.row] andFromAward:NO andDataDicitonary:dict andViewController:self successBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:USERCOINCHANGE object:nil];
            [self.navigationController popToViewController:(UIViewController *)_preVC animated:YES];
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGFLOAT_MIN;
    }
    else{
        return 40;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
        return CGFLOAT_MIN;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 ){
        return 170;
    }
    else{
        return 55;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 40)];
        label.text = @"请选择支付方式";
        [view addSubview:label];
        return view;
    }
    else{
        return nil;
        
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
