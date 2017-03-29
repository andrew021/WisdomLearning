//
//  WebLoginViewController.m
//  WisdomLearning
//
//  Created by Shane on 17/1/6.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "WebLoginViewController.h"

@interface WebLoginViewController ()

@end

@implementation WebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"扫描登录";
    self.navigationController.navigationBar.hidden = NO;
    
    _sureButton.layer.cornerRadius = 5.0f;
    _sureButton.backgroundColor = kMainThemeColor;
    _cancelButton.layer.cornerRadius = 5.0f;
    
//    self.view.backgroundColor = [UIColor whiteColor];
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
- (IBAction)sureButtonClicked:(UIButton *)sender {
    NSDictionary *dict = @{@"randcode":_ranCode, @"username":gUsername};
    [self.request scanToWebpageWithDict:dict block:^(ZSModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showHint:model.message];
        }
    }];
}
- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
