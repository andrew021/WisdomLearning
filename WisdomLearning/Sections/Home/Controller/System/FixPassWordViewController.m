//
//  FixPassWordViewController.m
//  BigMovie
//
//  Created by martin on 16/3/23.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "FixPassWordViewController.h"
#import "ChangePasswordView.h"
@interface FixPassWordViewController ()<UITextFieldDelegate> {
    UITextField *enterAgainTextField;
    UITextField *newTextField;
    UITextField *oldTextField;
    NSString *oldString;
    NSString *newString;
    NSString *enterAgainString;
}

@end

@implementation FixPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self creatUI];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
//    
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing: YES];
}

- (void)creatUI {
    UIView *backGroundView = [UIView new];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backGroundView];
    [backGroundView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(150);
    }];
    
    UILabel *oldPassWordLabel = [UILabel new];
    oldPassWordLabel.text = @"原密码";
    [backGroundView addSubview:oldPassWordLabel];
    [oldPassWordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(backGroundView.mas_top).offset(15);
        make.width.offset(55);
        make.left.mas_equalTo(10);
    }];
    
    UILabel *lineLabel = [UILabel new];
    [lineLabel setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1]];
    [backGroundView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(backGroundView.mas_top).offset(50);
    }];
    
    UILabel *newlineLabel = [UILabel new];
    [newlineLabel setBackgroundColor:[UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1]];
    [backGroundView addSubview:newlineLabel];
    [newlineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(backGroundView.mas_top).offset(100);
    }];
    
    UILabel *newPassWordLabel = [UILabel new];
    newPassWordLabel.text = @"新密码";
    [backGroundView addSubview:newPassWordLabel];
    [newPassWordLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(backGroundView.mas_top).offset(65);
        make.left.mas_equalTo(10);
    }];

    UILabel *enterAgainLabel = [UILabel new];
    enterAgainLabel.text = @"再次输入";
    [backGroundView addSubview:enterAgainLabel];
    [enterAgainLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(newlineLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(10);
    }];



    UIButton *confirmBtn = [UIButton new];
    [confirmBtn setBackgroundColor:kMainThemeColor];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.clipsToBounds = YES;
    confirmBtn.layer.cornerRadius = 5;
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo (backGroundView.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(40);
     }];
    
    oldTextField = [UITextField new];
    oldTextField.placeholder = @"请输入原始密码";
    oldTextField.delegate = self;
    oldTextField.keyboardType = UIKeyboardTypeDefault;
    oldTextField.secureTextEntry = YES;
    [backGroundView addSubview:oldTextField];
    [oldTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(backGroundView.mas_top).offset(15);
        make.left.equalTo(oldPassWordLabel.mas_right).offset(15);
        make.right.mas_equalTo(-10);
    }];
    
    newTextField = [UITextField new];
    newTextField.placeholder = @"请输入新密码";
    newTextField.delegate = self;
    newTextField.keyboardType = UIKeyboardTypeDefault;
    newTextField.secureTextEntry = YES;
    [backGroundView addSubview:newTextField];
    [newTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(backGroundView.mas_top).offset(65);
        make.left.equalTo(newPassWordLabel.mas_right).offset(15);
        make.right.mas_equalTo(-10);
    }];
    enterAgainTextField = [UITextField new];
    enterAgainTextField.placeholder = @"请再次输入新密码";
    enterAgainTextField.delegate = self;
    enterAgainTextField.secureTextEntry = YES;
    enterAgainTextField.keyboardType = UIKeyboardTypeDefault;
    [backGroundView addSubview:enterAgainTextField];
    [enterAgainTextField mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(newlineLabel.mas_bottom).offset(12);
        make.left.equalTo(enterAgainLabel.mas_right).offset(15);
        make.right.mas_equalTo(-10);
    }];

}

- (void)confirmClick {
//这里面出错有好多方式。，原密码不正确  等等 以后再写吧
    [self.view endEditing:YES];
    if(oldString.length == 0)
    {
        return [self showHint:@"请输入原密码"];
    }
    if(newString.length == 0)
    {
        return [self showHint:@"请输入新密码"];
    }

    if(enterAgainString.length == 0)
    {
        return [self showHint:@"请再次输入新密码"];
    }
    NSString *strUrl = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([oldString isEqualToString:newString]) {
       return [self showHint:@"新密码和原密码一样"];
    }
    if ( strUrl.length < 6 || strUrl.length > 18) {
       return [self showHint:@"密码位数6-18位数,密码中不能有空格"];
    }
    if (![newString isEqualToString:enterAgainString]) {
       return [self showHint:@"两次输入的密码不一致"];
    }
    
    
    [self checkIsHaveNumAndLetter:strUrl];
    
}

-(void)checkIsHaveNumAndLetter:(NSString*)pPassword{
    //數字條件
  
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合數字條件的有幾個字元
    NSInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:pPassword
                                                                options:NSMatchingReportProgress
                                                                  range:NSMakeRange(0, pPassword.length)];
    
    //英文字條件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字條件的有幾個字元
    NSInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:pPassword options:NSMatchingReportProgress range:NSMakeRange(0, pPassword.length)];
//    if (tNumMatchCount == pPassword.length)
//    {
//        //全部符合數字，表示沒有英文
//        return [self showHint:@"新密码必须包含数字和字母"];
//    }
//    else if (tLetterMatchCount == pPassword.length)
//    {
//        //全不符合英文，表示沒有數字
//        return [self showHint:@"新密码必须包含数字和字母"];
//    }
//   
   if (tNumMatchCount + tLetterMatchCount != pPassword.length)
    {
        //符合英文和符合數字條件的相加等於密碼長度
        return [self showHint:@"新密码不符合要求"];
    }
    else{
        [self showHudInView:self.view hint:@"提交中..."];
        [self.request requestEditPassword:gUserID password:oldString newPassword:newString block:^(ZSModel *model, NSError *error) {
            [self hideHud];
            if(model.isSuccess){
                [self showHint:model.message];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self showHint:model.message];
            }

        }];


    }
    
}
#pragma mark textfieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length > 18) {
        [self showHint:@"密码最多18位数字"];
        [self.view endEditing:YES];
        textField.text = [textField.text substringToIndex:6];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == oldTextField) {
        oldString = textField.text;
    } else if (textField == newTextField) {
        newString = textField.text;
    } else {
        enterAgainString = textField.text;
    }
    NSLog(@"===== %@----- %@++++++ %@",oldString, newString, enterAgainString);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
