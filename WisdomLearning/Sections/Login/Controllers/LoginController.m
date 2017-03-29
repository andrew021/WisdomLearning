//
//  LoginController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "LoginController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputPwdCell.h"
#import "InputUserNameCell.h"
#import "ClickLoginCell.h"
#import "LoginFooterView.h"
#import "SDScanViewController.h"
#import "ZSRequest+LoginInfo.h"
#import "ValidatePhoneController.h"
#import "JPUSHService.h"
#import "WXApi.h"

#import "UserInfo.h"

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "ForgetFirstViewController.h"
#import "RegisterViewController.h"

extern NSString *outscanewm;

@interface LoginController ()<UITableViewDelegate, UITableViewDataSource, SDScanViewDelegate>{
    SSDKPlatformType _platformType;
    NSString *_icon;
}

@property (strong, nonatomic) TPKeyboardAvoidingTableView* myTableView;
@property (strong, nonatomic) LoginFooterView* footerView;
@property (strong, nonatomic) InputUserNameCell *usernameCell;
@property (strong, nonatomic) ClickLoginCell *clickLoginCell;
@property (strong, nonatomic) InputPwdCell *pwdCell;
@property (strong, nonatomic) SDScanViewController *scanView;



@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.myTableView];
    self.usernameCell, self.pwdCell, self.clickLoginCell;
    if(!self.isBack){
        [self.view addSubview:[self closeButton]];
    }
    else{
        
    }
    [SSEThirdPartyLoginHelper setUserClass:[UserInfo class]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark --closebtn
-(UIButton *)closeButton{
    UIButton* closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 15, 15)];
    closeBtn.tag = 6;
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return closeBtn;
}

#pragma mark --lazy method
-(TPKeyboardAvoidingTableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        UIImageView* bgImg = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        bgImg.contentMode = UIViewContentModeScaleAspectFill;
        bgImg.image = [ThemeInsteadTool imageWithImageName:@"login_bg"];
        
        
        _myTableView.backgroundView = bgImg;
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.allowsSelection = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.separatorInset = UIEdgeInsetsMake(0, 25, 0, 25);
        _myTableView.scrollEnabled = NO;
        
        _myTableView.tableHeaderView = [self customHeaderView];
        _myTableView.tableFooterView = [self customFooterView];
        
        [_myTableView registerNib:[UINib nibWithNibName:@"InputUserNameCell" bundle:nil] forCellReuseIdentifier:@"userNameIdentity"];
        [_myTableView registerNib:[UINib nibWithNibName:@"InputPwdCell" bundle:nil] forCellReuseIdentifier:@"pwdIdentity"];
        [_myTableView registerNib:[UINib nibWithNibName:@"ClickLoginCell" bundle:nil] forCellReuseIdentifier:@"ClickLoginCell"];
    }
    return _myTableView;
}

-(InputUserNameCell *)usernameCell{
    if (!_usernameCell) {
        _usernameCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if ([outscanewm isEqualToString:@"on"]) {
            _usernameCell.scanLogin.hidden = NO;
            _usernameCell.scanLogin.userInteractionEnabled = YES;
            
            _usernameCell.scanLogin.tag = 0;
            [_usernameCell.scanLogin addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _usernameCell.scanLogin.hidden = YES;
            _usernameCell.scanLogin.userInteractionEnabled = NO;

        }
        
        
      
    }
    return _usernameCell;
}

-(InputPwdCell *)pwdCell{
    if (!_pwdCell) {
        _pwdCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    }
    return _pwdCell;
}

-(ClickLoginCell *)clickLoginCell{
    if (!_clickLoginCell) {
        _clickLoginCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        _clickLoginCell.loginButton.tag = 1;
        _clickLoginCell.forgetPwdButton.tag = 2;
        _clickLoginCell.registerButton.tag = 8;
        if ([regfunc isEqualToString:@"off"]) {
            _clickLoginCell.registerButton.hidden = YES;
            _clickLoginCell.registerButton.enabled = NO;
        }else{
            _clickLoginCell.registerButton.hidden = NO;
            _clickLoginCell.registerButton.enabled = YES;
        }
        [_clickLoginCell.loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clickLoginCell.forgetPwdButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_clickLoginCell.registerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickLoginCell;
}

- (UIView*)customHeaderView
{
    CGFloat height = 250;
    if (kDevice_Is_iPhone5 || kDevice_Is_iPhone4) {
        height = 200;
    }
    UIView* headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UIImageView* logoView = [[UIImageView alloc] initWithFrame:CGRectZero];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [headerV addSubview:logoView];
    
    [logoView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, height));
        make.centerX.mas_equalTo(headerV);
        make.centerY.mas_equalTo(headerV);
    }];
    
    logoView.image = [ThemeInsteadTool imageWithImageName:@"login_logo"];
    
    return headerV;
}

- (UIView*)customFooterView
{
    _footerView = [[[NSBundle mainBundle] loadNibNamed:@"LoginFooterView" owner:self options:nil] lastObject];
    [_footerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    [_footerView.qqLoginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    BOOL bWxInstalled = [WXApi isWXAppInstalled];
    if (bWxInstalled == NO) {
        _footerView.weixinLoginButton.hidden = YES;
        _footerView.weixinLoginButton.enabled = NO;
    }else{
        _footerView.weixinLoginButton.hidden = NO;
        _footerView.weixinLoginButton.enabled = YES;
         [_footerView.weixinLoginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [_footerView.weiboLoginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_footerView.vistorButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return _footerView;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 2) {
        return 100;
    }else{
        return 55;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([indexPath row] == 0) {
        NSString* cellIdentifier = @"userNameIdentity";
        InputUserNameCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }else if([indexPath row] == 1) {
        NSString* cellIdentifier = @"pwdIdentity";
        InputPwdCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        return cell;
    }else{
        NSString* cellIdentifier = @"ClickLoginCell";
        ClickLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark --SDScanViewDelegate  
// {666666:111111}
-(void)scannedString:(NSString *)result{
    NSRange range = [result rangeOfString:@"{"];
    if (range.location != NSNotFound) {
        NSRange range = [result rangeOfString:@":"];
        NSString *sub1 = [result substringToIndex:range.location];
        NSString *sub2 = [result substringFromIndex:range.location+1];
        NSString *username = [sub1 substringFromIndex:1];
        NSString *password = [sub2 substringToIndex:sub2.length-1];
        [self loginWithUsername:username withPassword:password];
    }else{
        [_scanView.session startRunning];
    }
    
//    NSString *regex = @"^\{.+\}$";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    if ([predicate evaluateWithObject:result]) {
//        [_scanView.session stopRunning];
//        
//        NSRange range = [result rangeOfString:@":"];
//        NSString *sub1 = [result substringToIndex:range.location];
//        NSString *sub2 = [result substringFromIndex:range.location+1];
//        NSString *username = [sub1 substringFromIndex:1];
//        NSString *password = [sub2 substringToIndex:sub2.length-1];
//        [self loginWithUsername:username withPassword:password];
//    }else{
//        [_scanView.session startRunning];
//    }
}


#pragma mark --click button event
-(void)buttonClicked:(UIButton *)sender{
    NSInteger tag = sender.tag;
    switch (tag) {  //扫描登录
        case 0:{
            _scanView = [[SDScanViewController alloc] init];
            _scanView.theScanDelegate = self;
            [self.navigationController pushViewController:_scanView animated:YES];
        }break;
        case 1:{  //账号登录
            
//            _usernameCell.usernameTextField.text = @"342425198011190045";
//            _pwdCell.pwdTextField.text = @"771129";
            
           // _usernameCell.usernameTextField.text = @"340824197601230616";
            //_pwdCell.pwdTextField.text = @"230616";
            
            
            Hint(_usernameCell.usernameTextField.text, @"请输入手机号或用户名");
            Hint(_pwdCell.pwdTextField.text, @"请输入密码");
            
            
            NSString *username = _usernameCell.usernameTextField.text;
            NSString *password = _pwdCell.pwdTextField.text;
          
            [self loginWithUsername:username withPassword:password];
           // [self loginIMWithUserName:_usernameCell.usernameTextField.text andPassWord:_pwdCell.pwdTextField.text];
        }break;
        case 2:{  //忘记密码
            ForgetFirstViewController *vc =[ForgetFirstViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 3:{  //QQ登录
            _platformType = SSDKPlatformTypeQQ;
            [self thirdPartyLogin];
        }break;
        case 4:{  //微信登录
            _platformType = SSDKPlatformTypeWechat;
            [self thirdPartyLogin];
        }break;
        case 5:{  //微博登录
            _platformType = SSDKPlatformTypeSinaWeibo;
            [self thirdPartyLogin];
        }break;
        case 6:{
            [self dismissViewControllerAnimated:YES completion:nil];
        }break;
        case 7:{  //游客登录
            [self loginWithUsername:@"hy_px_demo" withPassword:@"demo123"];
        }break;
        case 8:{
            RegisterViewController *destVc = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:destVc animated:YES];
        }break;
        default:
            break;
    }
}


#pragma mark  --第三方登录接口
-(void)thirdPartyLogin{
    [SSEThirdPartyLoginHelper loginByPlatform:_platformType
                                   onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
                                       //在此回调中可以将社交平台用户信息与自身用户系统进行绑定，最后使用一个唯一用户标识来关联此用户信息。
                                       //在此示例中没有跟用户系统关联，则使用一个社交用户对应一个系统用户的方式。将社交用户的uid作为关联ID传入associateHandler。
                                       associateHandler (user.uid, user, user);
                                   }
                                onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
                                    if (state == SSDKResponseStateSuccess){
                                        [self toLearningController:user];
                                    
                                    }else{
                                        NSLog(@"%@", error.description);
                                        [self showHint:error.description];
                                    }
                                    
                                }];
}


#pragma mark --跳到个人信息页面
-(void)toLearningController:(SSEBaseUser *) user{
    NSString *thirdType, *thirdMark;
    SSDKUser *aUser = user.socialUsers.allValues[0];
    thirdMark = aUser.uid;
    if (_platformType == SSDKPlatformTypeQQ) {
        thirdType = @"qq";
    }else if (_platformType == SSDKPlatformTypeWechat){
        thirdType = @"wx";
    }else{
        thirdType = @"wb";
    }
    
    [[Config Instance] saveThirtyPartyUserInfo:user];
    //判断是否已经绑定账号
    NSDictionary *dict = @{@"thirdMark":thirdMark, @"thirdType":thirdType};
    [self.request isBindThirdPartyWithDict:dict block:^(ZSLoginModel *model, NSError *error) {
        if (model.isSuccess == YES) {
            if (model.data != nil) {   //已经绑定了账号的情况
                //暂时还是用账户登录的信息，不用第三方登录的信息
                ZSLoginInfo* loginInfo = model.data;
                
                [[Config Instance] saveLoginInfo:loginInfo];
                
                [self loginIMWithUserName:gUserID andPassWord:@"111111"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JPUSHService setTags:nil alias:loginInfo.userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"%@",iAlias);
                    }];
                });
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESS object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{  //还未绑定，则进行绑定
                //            [self showHint:model.message];
                ValidatePhoneController *destVc = [[ValidatePhoneController alloc] init];
                destVc.thirdType = thirdType;
                destVc.thirdMark = thirdMark;
                [self.navigationController pushViewController:destVc animated:YES];
            }
        }else{
            [self showHint:model.message];
        }
}];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)loginWithUsername:(NSString *)username withPassword:(NSString *)password{
    NSDictionary* dic = @{ @"loginName" : username,
                           @"password" : password};
    
    [self.request requestLoginUserDataWith:dic withBlock:^(ZSLoginModel* model, NSError* error) {
        [self hideHud];
        if (model.isSuccess) {
            if (model.data != nil) {
                [self showHint:model.message];
                ZSLoginInfo* loginInfo = model.data;
                [[Config Instance] saveLoginInfo:loginInfo];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [JPUSHService setTags:nil alias:loginInfo.userId fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
                        NSLog(@"%@",iAlias);
                    }];
                });
                
                [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESS object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
                [self loginIMWithUserName:loginInfo.userId andPassWord:@"111111"];
            }else{
                [self showHint:model.message];
            }
            
           // loginInfo.userId
        }
        else {
            [self showHint:model.message];
        }
    }];

}

//暂时登录
-(void)loginIMWithUserName:(NSString*)userName andPassWord:(NSString*)passWord{
    __weak typeof(self) weakself = self;
  //  NSLog(@"%@ %@",userName,passWord)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError* error = [[EMClient sharedClient] loginWithUsername:userName password:passWord];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                //设置是否自动登录
                [self showHint: @"同步登录聊天服务成功!"];
               
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
               [self showHint: @"同步登录聊天不成功,请重新登录才能聊天!"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
