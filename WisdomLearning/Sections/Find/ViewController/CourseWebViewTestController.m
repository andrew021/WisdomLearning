//
//  CourseWebViewTestController.m
//  WisdomLearning
//
//  Created by Shane on 17/2/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "CourseWebViewTestController.h"

@interface CourseWebViewTestController ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * myWebView;

@end

@implementation CourseWebViewTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.myWebView];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60 * 60 * 24 * 30];
    [self.myWebView loadRequest:request];
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

-(UIWebView *)myWebView{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        
        _myWebView.backgroundColor = [UIColor whiteColor];
        [_myWebView setUserInteractionEnabled:YES];//是否
        //    self.myWebView.scalesPageToFit = YES;
        [_myWebView setScalesPageToFit:YES];
        _myWebView.delegate = self;

    }
    return _myWebView;
}

@end
