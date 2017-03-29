//
//  SysWebViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2017/1/5.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "SysWebViewController.h"

@interface SysWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * myWebView;

@end

@implementation SysWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"测试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self showHudInView:self.view hint:@"加载中..."];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60 * 60 * 24 * 30];
    
    self.myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.myWebView.backgroundColor = [UIColor whiteColor];
    [self.myWebView setUserInteractionEnabled:YES];//是否
    [self.myWebView loadRequest:request];
    //    self.myWebView.scalesPageToFit = YES;
    [self.myWebView setScalesPageToFit:YES];
    self.myWebView.delegate = self;
    [self.view addSubview:_myWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:NO animated:animated];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    
    [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);"];
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
