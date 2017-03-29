//
//  UnLoginController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "UnLoginController.h"
#import "LoginController.h"

@interface UnLoginController ()

@end

@implementation UnLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * unLogin = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, SCREEN_HEIGHT*0.2, 200, 250)];
    [self.view addSubview:unLogin];
    unLogin.image = [ThemeInsteadTool imageWithImageName:@"unLogin"];
    
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, ViewMaxY(unLogin)+50, 120, 40)];
    loginButton.layer.borderColor = kMainThemeColor.CGColor;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.cornerRadius = 6;
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    
    [loginButton addTarget:self action:@selector(clickLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
}

-(void)clickLogin:(UIButton *)sender{
    LoginController *loginCtrl = [[LoginController alloc] init];
    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginCtrl];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
