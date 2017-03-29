//
//  OrderConfirmCOntroller.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "OrderConfirmCOntroller.h"
#import "OrderConfirmCell.h"
#import "OrderConfirmCell2.h"
#import "PayKindTableViewCell.h"
#import "CoinUseCell.h"
#import "CourseStudyViewController.h"
#import "TrainingSeminarViewController.h"
#import "DistanceTrainingViewController.h"
#import "FaceTeachingViewController.h"



@interface OrderConfirmCOntroller ()<UITableViewDataSource,UITableViewDelegate, CoinUseCellDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong) CoinUseCell* coinCell;
//@property (nonatomic, assign) double jinbiNum;
@property (nonatomic, assign) NSInteger sectionNum;
@property (nonatomic, assign) double shouldPayMoney;
@property (nonatomic, assign) CGFloat theSectionFooterHeight;
@property (nonatomic, strong) UIView *jinbiPayView;
@property (nonatomic, copy) NSString *useCoin;
@property (nonatomic, copy) NSString *putMoney;
@property (nonatomic, assign) NSInteger userLearnCoin;
@property (nonatomic, strong) NSMutableArray *payIcons;
@property (nonatomic, strong) NSMutableArray *payTitles;

@end

@implementation OrderConfirmCOntroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"确认订单";
    _shouldPayMoney = _coursePrice;
    _sectionNum = 3;
    _useCoin = @"0";
    _theSectionFooterHeight = 15;
   
    [self.request requestUserStudyinfoWithUserId:gUserID block:^(UserStudyinfoModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            [self createTableView];
            NSNumber *coinNumber = [NSNumber numberWithLong:model.data.learnCurrency];
            _userLearnCoin = [coinNumber integerValue];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:YES];
}

//setup TableView
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 250;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

-(UIView *)jinbiPayView{
    if (!_jinbiPayView) {
        _jinbiPayView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, SCREEN_WIDTH-2*10, 50)];
        payButton.backgroundColor = kMainThemeColor;
        [payButton setTitle:@"学币支付" forState:UIControlStateNormal];
        payButton.layer.cornerRadius = 6.0f;
        [payButton addTarget:self action:@selector(clickJinbiPay:) forControlEvents:UIControlEventTouchUpInside];
        [_jinbiPayView addSubview:payButton];
    }
    return _jinbiPayView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionNum;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2){
        return payPaths.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if (_isFromSign) {
            static NSString* cellIdentifier = @"orderConfirmCellIdentity";
            OrderConfirmCell2* cell = (OrderConfirmCell2*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderConfirmCell2" owner:nil options:nil] lastObject];
            }
            cell.courseIcon = _courseIcon;
            cell.desc = _orderDesc;
            cell.price = [NSString stringWithFormat:@"%.2f", _coursePrice];
            
//            cell.coursePrice = [NSString stringWithFormat:@"%.2f", _coursePrice];
//            cell.courseName = _courseName;
//            cell.courseIcon = _courseIcon;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }else{
            static NSString* cellIdentifier = @"orderConfirmCellIdentity";
            OrderConfirmCell* cell = (OrderConfirmCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderConfirmCell" owner:nil options:nil] lastObject];
            }
            
            cell.coursePrice = [NSString stringWithFormat:@"%.2f", _coursePrice];
            cell.courseName = _courseName;
            cell.courseIcon = _courseIcon;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
    }
    else if(indexPath.section == 1){
        static NSString* cellIdentifier = @"CoinUseCell";
        _coinCell = (CoinUseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!_coinCell) {
            _coinCell = [[[NSBundle mainBundle] loadNibNamed:@"CoinUseCell" owner:nil options:nil] lastObject];
        }
        _coinCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _coinCell.theDelegate = self;
        if (_userLearnCoin == 0) {
            _coinCell.selectButton.enabled = NO;
        }else{
            _coinCell.selectButton.enabled = YES;
        }
        _coinCell.coinLabel.text = [NSString stringWithFormat: @"您的可用学币为%d个", _userLearnCoin ];
        [_coinCell setAccessoryType:UITableViewCellAccessoryNone];

        return _coinCell;
    }
    else{
        static NSString* cellIdentifier = @"payKindCellIdentity";
        PayKindTableViewCell* cell = (PayKindTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PayKindTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (payPaths.count == 0) {
            return cell;
        }else{
            cell.payIcon.image = [UIImage imageNamed:_payIcons[indexPath.row]];
            cell.payLabel.text = _payTitles[indexPath.row];
            return cell;
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *userId = gUserID;
    if (userId.length == 0 || userId == nil) {
        userId = @"";
    }
  
    if (_clazzId.length == 0 || _clazzId == nil) {
        _clazzId = @"0";
    }
    
    NSDictionary *dict = @{@"userId":userId, @"courseStr":_courseId, @"clazzId":_clazzId, @"putmoney":[NSString stringWithFormat:@"%.2f", _shouldPayMoney], @"useCoin":_useCoin};
    if (indexPath.section == 2) {
        if (_isFromSign) {
            [[ZSPay instance] payCourseWithPayType:payPaths[indexPath.row] andFromAward:NO andDataDicitonary:dict andViewController:self successBlock:^{
                if (_useCoin) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USERCOINCHANGE object:nil];
                }
                [self loginClass];
            }];
      }else{
          [[ZSPay instance] payCourseWithPayType:payPaths[indexPath.row] andFromAward:NO andDataDicitonary:dict andViewController:self successBlock:^{
              _preVc.isPurchaseSucess = YES;
              [self.navigationController popToViewController:(UIViewController *)_preVc animated:YES];
              if (_useCoin) {
                  [[NSNotificationCenter defaultCenter] postNotificationName:USERCOINCHANGE object:nil];
              }
          }];
        }
        
    }
}

- (void)loginClass
{
    if (self.clazzType == 1) {
        FaceTeachingViewController *faceVC = [FaceTeachingViewController new];
        faceVC.classId = _clazzId;
        [self.navigationController pushViewController:faceVC animated:YES];
    } else {
        DistanceTrainingViewController *vc = [DistanceTrainingViewController new];
        vc.classId = _clazzId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UITableViewDelegate && UITableViewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return CGFLOAT_MIN;
    }
    else{
        return 35;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
            return _theSectionFooterHeight;
            break;
        case 2:
            return CGFLOAT_MIN;
            break;
        default:
            break;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section ==0 ){
        return 70;
    }
    else if(indexPath.section ==1){
        return 45;
    }
    else{
        return 55;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section==1){
        if ([_useCoin boolValue] == YES) {
            NSString *s2 = @"";
            NSString *s1 = @"";
            if (_userLearnCoin >= _coursePrice*coinrule) {
                s1 = [NSString stringWithFormat:@"%.02f", _coursePrice];
                s2 = [NSString stringWithFormat:@"(抵扣%.f学币)", _coursePrice*coinrule];
            }else{
                s1 = [NSString stringWithFormat:@"%.02f", _userLearnCoin*1.0/coinrule];
                s2 = [NSString stringWithFormat:@"(抵扣%i学币)", _userLearnCoin];
            }
            return  [self createHeadViewWithTitle:@"学币支付金额:" andNum:[@"￥" add:s1] addOther:s2];
        }else{
            return  [self createHeadViewWithTitle:@"学币支付金额:" andNum:[@"￥" add:@"0.00"] addOther:@""];
        }
    }
    else if(section ==2){
        return [self createHeadViewWithTitle:@"剩余需支付金额:" andNum:[@"￥" add:[NSString stringWithFormat:@"%.2f", _shouldPayMoney]] addOther:@""];
    }
    else{
        return nil;
        
    }
}

-(UIView*)createHeadViewWithTitle:(NSString*)title andNum:(NSString*)num addOther:(NSString *)other{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [GetHeight getWidthWithContent:title height:35 font:15];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, width, 35)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    width = [GetHeight getWidthWithContent:title height:35 font:15];
    UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(width+15, 0, width, 35)];
    numLabel.text = num;
    numLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:numLabel];
    numLabel.textColor = KMainRed;
    
    
    UILabel * dikouLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), 0, 100, 35)];
    dikouLabel.text = other;
    dikouLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:dikouLabel];
    
    return view;
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

-(void)useCoin:(BOOL)isUseCoin{
    _useCoin = [NSString stringWithFormat:@"%d", isUseCoin];
    if (isUseCoin && _userLearnCoin >= _coursePrice*coinrule  ) { //使用金币且金币数大于课程价格
        _sectionNum = 2;
        _theSectionFooterHeight = 1;
        _tableView.tableFooterView = self.jinbiPayView;
        [_tableView reloadData];
    }else{
        if (!isUseCoin) {   // 不使用金币的情况
            _shouldPayMoney = _coursePrice;
        }else{
            double ddd = _coursePrice - _userLearnCoin/coinrule;
           _shouldPayMoney = ddd > 0 ?  ddd : _coursePrice;
        }
        _theSectionFooterHeight = 15;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _sectionNum = 3;
        [_tableView reloadData];
    }
    
}

-(void)clickJinbiPay:(UIButton *)sender{
  if (_clazzId.length == 0 || _clazzId == nil) {
        _clazzId = @"0";
    }
    
    NSDictionary *dict = @{@"userId":gUserID, @"courseStr":_courseId, @"clazzId":_clazzId, @"putmoney":[NSString stringWithFormat:@"%.2f", _shouldPayMoney], @"useCoin":_useCoin};
    
    [self.request requestAliPayOrderWithDict:dict block:^(ZSPayOrderModel *model, NSError *error) {
        if (model.isSuccess) {
            if ([model.data.onlineFee doubleValue] == 0) {
                NSDate *date = [NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYYMMddhhmmss"];
                
                NSString *dateTime = [formatter stringFromDate:date];
                
                NSDictionary *dict = @{@"orderNum":model.data.orderNum, @"payTime":dateTime};
                [self.request postServerWithPayDict:dict block:^(ZSModel *model, NSError *error) {
                    NSString *strMsg;
                    if (model.isSuccess) {
                        if (_isFromSign) {  //来自报名
                            [self loginClass];
                        }else{
                            _preVc.isPurchaseSucess = YES;
                            [self.navigationController popToViewController:(UIViewController *)_preVc animated:YES];
                        }
                        if (_useCoin) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:USERCOINCHANGE object:nil];
                        }
                        
                    }else{
                        strMsg = model.message;
                    }
                }];

            }
        }else{
            [self showHint:model.message];
        }
    }];
}

@end
