//
//  CourseIntroController.m
//  WisdomLearning
//
//  Created by Shane on 16/11/5.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CourseIntroController.h"

@implementation CourseIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    [self.view endEditing:YES];
}


@end
