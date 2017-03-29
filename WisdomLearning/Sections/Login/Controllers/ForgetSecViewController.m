//
//  ForgetSecViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  

#import "ForgetSecViewController.h"
#import "ForgetTextCell.h"
#import "ZSRequest+LoginInfo.h"

@interface ForgetSecViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, copy) NSString *verNum,*pawNum,*pawAginNum, *telNum;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger indx;
@end

@implementation ForgetSecViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"忘记密码";
    
    self.verNum = @"";
    self.pawNum = @"";
    self.pawAginNum = @"";
    self.telNum = @"";
    self.indx = 60;
    
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoardTap)];
    [self.tableView addGestureRecognizer:tap];
    
    _getBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95.0, 72.0, 80.0, 30.0)];
    _getBtn.backgroundColor = kMainThemeColor;
    _getBtn.layer.cornerRadius = 5.0;
    [_getBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [_getBtn setTitleColor:KMainLine forState:UIControlStateHighlighted];
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [_getBtn addTarget:self action:@selector(getNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableView addSubview:_getBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)getNumberClick:(UIButton *)sender
{
    [Tool hideKeyBoard];
    
    if ([Tool isMobileNumber:self.telNum]) {
        //获取验证码
        [self showHudInView:self.view hint:@"发送中..."];
        [self.request requestSendValidcodeWithTelphone:self.telNum block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            if (model.isSuccess) {
                [self showHint:model.message];
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(time:) userInfo:nil repeats:YES];
            } else {
                [self showHint:model.message];
            }
        }];
    } else {
        [self showHint:@"输入的不是手机号"];
    }
    
    
}

- (void)time:(NSTimer *)timer
{
    if (_indx > 0) {
        _getBtn.enabled = NO;
        [_getBtn setTitle:[NSString stringWithFormat:@"%lds后再发送",_indx] forState:UIControlStateNormal];
        _indx -- ;
    } else {
        _getBtn.enabled = YES;
        [_getBtn setTitle:@"点击获取" forState:UIControlStateNormal];
        _indx = 60;
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)hideKeyBoardTap
{
    [Tool hideKeyBoard];
}

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"ForgetTextCell" bundle:nil] forCellReuseIdentifier:@"forgetTextCell"];
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForgetTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forgetTextCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textFiled.delegate = self;
    if (indexPath.section == 0) {
        cell.textFiled.placeholder = @"请输入手机号";
        cell.textFiled.tag = 1;
        [cell.textFiled setSecureTextEntry:NO];
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.section == 1) {
        cell.textFiled.placeholder = @"请输入验证码";
        cell.textFiled.tag = 2;
        [cell.textFiled setSecureTextEntry:NO];
        cell.textFiled.keyboardType = UIKeyboardTypeNumberPad;
    } else if (indexPath.section == 2) {
        cell.textFiled.placeholder = @"请输入新密码";
        cell.textFiled.tag = 3;
        [cell.textFiled setSecureTextEntry:YES];
        cell.textFiled.keyboardType = UIKeyboardTypeDefault;
    } else {
        cell.textFiled.placeholder = @"请再次输入新密码";
        cell.textFiled.tag = 4;
        [cell.textFiled setSecureTextEntry:YES];
        cell.textFiled.keyboardType = UIKeyboardTypeDefault;
    }
    return cell;
}
//表尾
- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.0)];
        _footView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UIButton * sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(30.0, 60.0, SCREEN_WIDTH - 60.0, 40.0)];
        sureBtn.backgroundColor = kMainThemeColor;
        sureBtn.layer.cornerRadius = 5.0;
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn setTitleColor:KMainLine forState:UIControlStateHighlighted];
        [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sureBtn];
    }
    return _footView;
}
//确定 按钮的响应
- (void)sure
{
    [Tool hideKeyBoard];
    
//    NSLog(@"__%@__%@___%@__%@",self.telNum,self.verNum,self.pawNum,self.pawAginNum)
    
    if ([self.telNum isEqualToString:@""]) {
        [self showHint:@"手机号不能为空"];
        return;
    }
    if ([self.verNum isEqualToString:@""]) {
        [self showHint:@"验证码不能为空"];
        return;
    }
    if ([self.pawNum isEqualToString:@""]) {
        [self showHint:@"新密码不能为空"];
        return;
    }
    if ([self.pawAginNum isEqualToString:@""]) {
        [self showHint:@"再次输入密码不能为空"];
        return;
    }
    if (![self.pawNum isEqualToString:self.pawAginNum]) {
        [self showHint:@"两次输入的新密码不一样"];
        return;
    }
    
    [self showHudInView:self.view hint:@"重置中..."];
    
    NSDictionary *dic = @{
//                          @"username":@"",//
                          @"telphone":self.telNum,//手机号
                          @"validCode":self.verNum,//手机验证码
                          @"newPwd":self.pawNum,//新密码
                          };
    [self.request requestResetPwdWithDict:dic block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
        } else {
            [self showHint:model.message];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        self.telNum = textField.text;
    } else if (textField.tag == 2) {
        self.verNum = textField.text;
    } else if (textField.tag == 3){
        self.pawNum = textField.text;
    } else {
        self.pawAginNum = textField.text;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}


@end
