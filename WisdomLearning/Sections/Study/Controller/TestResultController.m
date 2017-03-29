//
//  TestResultController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TestResultController.h"
#import "WebViewViewController.h"

@interface TestResultController ()

@end

@implementation TestResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"测试结果";
    
  
 //   NSString * num = [NSString stringWithFormat:@"第%f次测验",self.list.testNum]];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"第 %ld 次测验",self.list.testNum]];
    //[[NSMutableAttributedString alloc]initWithString:@"第 2 次测验"];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:KMainOrange
     
                          range:NSMakeRange(2, 1)];
    
    _numLabel.attributedText = AttributedStr;
    _timeLabel.text = self.list.testTime;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)doBack:(UIButton*)btn
{
    UIViewController * viewCtl = self.navigationController.
    viewControllers[2];
    [self.navigationController popToViewController:viewCtl animated:YES];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAgain:(UIButton *)sender {
    
    WebViewViewController * vc = [[WebViewViewController alloc]init];
    vc.urlStr = self.list.testUrl;
    vc.title = @"测验";
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
