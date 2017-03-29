//
//  HomeworkDemandController.m
//  WisdomLearning
//
//  Created by Shane on 16/11/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HomeworkDemandController.h"

@interface HomeworkDemandController ()

@end

@implementation HomeworkDemandController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    [self.view endEditing:YES];
}



@end
