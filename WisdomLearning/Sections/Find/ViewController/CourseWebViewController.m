//
//  CourseWebViewController.m
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "CourseWebViewController.h"
#import "CourseStudyViewController.h"

extern CGFloat playViewHeight;
extern const CGFloat playerViewHeight;
extern const CGFloat commentViewHeight;

@interface CourseWebViewController ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,strong)UIWebView * myWebView;
@property (nonatomic, assign) double breakpoint;

@end

@implementation CourseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _breakpoint = 0;
    if (_isFromCourseHtml == YES) {
        [self startTimer];
    }
    
    if (_courseStduyCotroller) {
        _courseStduyCotroller.bShowCommentView = YES;
    }
   
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self killTimer];
}

-(UIWebView *)myWebView{
    if (!_myWebView) {
        if (_isFromCourseHtml == NO) {
            _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-playerViewHeight-commentViewHeight-40-64)];
            _myWebView.scrollView.scrollEnabled = NO;
            _myWebView.scrollView.delegate = self;
        }else{
            _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        }
        
        _myWebView.backgroundColor = [UIColor whiteColor];
        [_myWebView setUserInteractionEnabled:YES];//是否
        //    self.myWebView.scalesPageToFit = YES;
        [_myWebView setScalesPageToFit:YES];
        _myWebView.delegate = self;
    }
    return _myWebView;
}

-(void)setBBounce:(BOOL)bBounce{
    if (_isFromCourseHtml == NO) {
        self.myWebView.scrollView.scrollEnabled = bBounce;
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
//    CGFloat yyy = scrollView.contentOffset.y;
//    if (yyy == 0) {
//        _myWebView.scrollView.bounces = NO;
//    }else{
//        _myWebView.scrollView.bounces = YES;
//    }
//}




-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:60 * 60 * 24 * 30];
    [self.myWebView loadRequest:request];
}

-(void)setHtmlStr:(NSString *)htmlStr{
    _htmlStr = htmlStr;
    [self.myWebView loadHTMLString:_htmlStr baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideHud];
    
    [webView stringByEvaluatingJavaScriptFromString:@"var element = document.createElement('meta');  element.name = \"viewport\";  element.content = \"width=device-width,initial-scale=1.0,minimum-scale=0.5,maximum-scale=3,user-scalable=1\"; var head = document.getElementsByTagName('head')[0]; head.appendChild(element);"];
    
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---定时器---
-(void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:studysaveinterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode: UITrackingRunLoopMode];
    }else{
        _timer.fireDate = [NSDate distantPast]; //恢复定时器
    }
    return ;
}

-(void)killTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil ;
    }
    return ;
}

-(void)timerAction{
    if (_learnFlag == NO) {  //只有在选课的情况下才保存
        return ;
    }
    
    _breakpoint += 60;
    
    NSLog(@"%@", [NSString stringWithFormat:@"%f", _breakpoint]);
    
    NSDictionary *dict = @{@"courseId":_courseId, @"userId":gUserID, @"clazzId":_classId, @"chapterId":_chapterId, @"breakPoint":[NSString stringWithFormat:@"%f", _breakpoint], @"timerInterval":@"10", @"videoLen":@"-1"};
    [self.request saveCousrseInfoWithData:dict withBlock:^(ZSModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
        }else{
            [self showHint:model.message];
        }
    }];
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
