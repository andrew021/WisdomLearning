//
//  OrderDetailViewController.m
//  WisdomLearning
//
//  Created by Shane on 17/2/22.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * myWebView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"订单详情";
    
    [self.view addSubview:self.myWebView];
//    NSString * uriStr =  [NSString stringWithFormat:@"%@&userId=%@",_detailUrl,gUserID];
    
    NSURL *url = [NSURL URLWithString:_detailUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60 * 60 * 24 * 30];
    [self.myWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIWebView *)myWebView{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        
        _myWebView.backgroundColor = [UIColor whiteColor];
        [_myWebView setUserInteractionEnabled:YES];//是否
        [_myWebView setScalesPageToFit:YES];
        _myWebView.delegate = self;
    }
    return _myWebView;
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
