//
//  ValidatePhoneController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/31.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ValidatePhoneController.h"
#import "InputPhoneTextCell.h"
#import "ForgetTextCell.h"
#import "ZSRequest+LoginInfo.h"
#import "JPUSHService.h"

@interface ValidatePhoneController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *footView;
@property(nonatomic, copy) NSString *phoneNum;
@property(nonatomic, strong) UIButton *getBtn;
@property(nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger indx;
@property(nonatomic, strong) InputPhoneTextCell *userCell;
@property(nonatomic, strong) InputPhoneTextCell *pwdCell;

@end

@implementation ValidatePhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"绑定用户名";
    self.indx = 60;
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self.view addSubview:self.tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoardTap)];
    [self.tableView addGestureRecognizer:tap];
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

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        
        [_tableView registerNib:[UINib nibWithNibName:@"InputPhoneTextCell" bundle:nil] forCellReuseIdentifier:@"InputPhoneTextCell"];
        _tableView.tableFooterView = self.footView;
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _userCell = [tableView dequeueReusableCellWithIdentifier:@"InputPhoneTextCell" forIndexPath:indexPath];
        _userCell.phoneTextfield.placeholder = @"请输入用户名";
        _userCell.phoneTextfield.delegate = self;
        return _userCell;
    }else{
        _pwdCell = [tableView dequeueReusableCellWithIdentifier:@"InputPhoneTextCell" forIndexPath:indexPath];
        _pwdCell.phoneTextfield.placeholder = @"请输入密码";
        _pwdCell.phoneTextfield.delegate = self;
        
        return _pwdCell;
    }
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
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(toNext:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:sureBtn];
    }
    return _footView;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _phoneNum = textField.text;
}


-(void)toNext:(UIButton *)sender{
    [Tool hideKeyBoard];
    Hint(_userCell.phoneTextfield.text, @"请输入用户名");
    Hint(_pwdCell.phoneTextfield.text, @"请输入密码");
    
    NSString *userName = _userCell.phoneTextfield.text;
    NSString *password = _pwdCell.phoneTextfield.text;
    
    NSDictionary *dict = @{@"username":userName, @"password":password, @"thirdType":_thirdType, @"thirdMark":_thirdMark};
    
    [self.request bindUserAccoutWithDict:dict block:^(ZSModel *model, NSError *error) {
        if (model.isSuccess) { // 绑定成功后，再重新登录一次（多余）
            [self showHint:model.message];
            NSDictionary* dic = @{ @"loginName" : userName,
                                   @"password" : password,
                                   };
                
            [self.request requestLoginUserDataWith:dic withBlock:^(ZSLoginModel *model, NSError *error) {
                if (model.isSuccess) {
                    if (model.data != nil) {
                        ZSLoginInfo* loginInfo = model.data;
                        [[Config Instance] saveLoginInfo:loginInfo];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [JPUSHService setTags:nil alias:loginInfo.userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                                NSLog(@"%@",iAlias);
                            }];
                        });
                        [self loginIMWithUserName:gUserID andPassWord:@"123456"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESS object:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [self showHint:model.message];
                    }
                }else{
                    [self showHint:model.message];
                }
            }];
        }else{
            [self showHint:model.message];
        }
    }];
}

- (void)hideKeyBoardTap
{
    [Tool hideKeyBoard];
}

//- (void)getNumberClick:(UIButton *)sender
//{
//    [Tool hideKeyBoard];
//    
//    //获取验证码
//    [self showHudInView:self.view hint:@"发送中..."];
//    [self.request requestSendValidcodeWithTelphone:@"13917265803" block:^(ZSModel *model, NSError *error) {
//        [self hideHud];
//        if (model.isSuccess) {
//            [self showHint:@"发送成功"];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(time:) userInfo:nil repeats:YES];
//        } else {
//            [self showHint:model.message];
//        }
//    }];
//}

//- (void)time:(NSTimer *)timer
//{
//    if (_indx > 0) {
//        _getBtn.enabled = NO;
//        [_getBtn setTitle:[NSString stringWithFormat:@"%lds后再发送",_indx] forState:UIControlStateNormal];
//        _indx -- ;
//    } else {
//        _getBtn.enabled = YES;
//        [_getBtn setTitle:@"点击获取" forState:UIControlStateNormal];
//        _indx = 60;
//        [_timer invalidate];
//        _timer = nil;
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//暂时登录
-(void)loginIMWithUserName:(NSString*)userName andPassWord:(NSString*)passWord{
    __weak typeof(self) weakself = self;
//    NSLog(@"%@ %@",userName,passWord);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError* error = [[EMClient sharedClient] loginWithUsername:userName password:passWord];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                //设置是否自动登录
                
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
                [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
                [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
                    
                    if (!aError) {
                        EMPushOptions *option = [[EMClient sharedClient] pushOptions];
                        option.displayStyle = EMPushDisplayStyleMessageSummary;
                        //  option.nickname = gUserName;
                        EMError* error = [[EMClient sharedClient] setApnsNickname:gUserNickname];
                        
                    }
                }];
                
                [[EMClient sharedClient] updatePushOptionsToServer];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //发送自动登陆状态通知
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        NSString* password = passWord;
                        
                        if (password && password.length > 0) {
                            //                            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                            //                            [ud setObject:password forKey:[NSString stringWithFormat:@"em_lastLogin_password"]];
                            //
                            //                            [ud setObject:userName forKey:@"em_lastLogin_username"];
                            //                            [ud synchronize];
                        }
                        //保存最近一次登录用户名
                        // [weakself saveLastLoginUsername];
                    });
                });
            }
            else {
                NSLog(@"++++ %d %@",error.code,error);
                switch (error.code) {
                        
                    case EMErrorNetworkUnavailable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        //[self loginWithPassWord:password AndUserId:userId];
                        break;
                    case EMErrorServerNotReachable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        // [self loginWithPassWord:password AndUserId:userId];
                        break;
                    case EMErrorUserAuthenticationFailed:
                        //[self loginWithPassWord:password AndUserId:userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        break;
                    case EMErrorServerTimeout:
                        //[self loginWithPassWord:password AndUserId:userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        break;
                    default:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        //[self loginWithPassWord:password AndUserId:userId];
                        break;
                }
            }
        });
        
    });
    
}





#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

@end
