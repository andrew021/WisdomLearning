//
//  DynDetailsViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//资讯详情

#import "DynDetailsViewController.h"

@interface DynDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIView * headView;

@property (nonatomic,assign) CGFloat iconHeight;
@property (nonatomic,strong) UILabel * numLabel;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * timeLabel;
@property (nonatomic,strong) UIImageView * icon;
@property (nonatomic,strong) UIImageView * numicon;
@property (nonatomic,strong) UIWebView * webView;

@end

@implementation DynDetailsViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == 1) {
        self.navigationItem.title = @"资讯详细";
    } else {
        self.navigationItem.title = @"通知详细";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
 
//    if(_isCreateImg){
//        self.iconHeight = 170;
//    }
//    else{
        self.iconHeight = 0;
   // }

    [self setheadViewNoModel];
  
    [self fetchData];
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.backgroundColor = [UIColor whiteColor];
    
    _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    _webView.scalesPageToFit=YES;
    _webView.delegate = self;
    
  //  _webView.multipleTouchEnabled=YES;
    
   _webView.userInteractionEnabled=YES;
    
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
     [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '240%'"];
}

#pragma mark---请求数据
- (void)fetchData
{
//    if(_ID.length == 0){
//        _ID = @"1";
//    }
    NSDictionary * dic = @{@"id":_ID ,@"type":[NSString stringWithFormat:@"%ld",(long)self.type]};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestInfoDetailWithDic:dic block:^(InfoModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            _model = model.data;
            if(_model.shareUrl!=nil && _model.shareUrl.length>0){
                [self setupNav];
            }

             CGFloat height = [GetHeight getHeightWithContent:_model.title width:SCREEN_WIDTH-30 font:15];
            NSString *strHTML = _model.subject;
            
     
             _webView.frame = CGRectMake(0, self.iconHeight+45+height, SCREEN_WIDTH, SCREEN_HEIGHT -self.iconHeight-45-height-64);
            [_webView loadHTMLString:strHTML baseURL:nil];
            //[self setHTML:_model.subject];
       
      
                
                            _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.iconHeight+45+height);
                
                            _titleLabel.frame = CGRectMake(15, self.iconHeight+15, SCREEN_WIDTH-30, height);
                             _titleLabel.text = _model.title;
                
                
                            _numLabel.frame = CGRectMake(SCREEN_WIDTH*0.58+22, self.iconHeight+25+height, SCREEN_WIDTH*0.4, 15);
                            _numLabel.text = [NSString stringWithFormat:@"%ld人浏览",_model.viewNum];
                           // _numLabel.backgroundColor = [UIColor redColor];
                
                            _timeLabel.frame = CGRectMake(SCREEN_WIDTH*0.18, self.iconHeight+25+height, SCREEN_WIDTH*0.4, 15);
                            _timeLabel.text = _model.createDate;
                           // _timeLabel.backgroundColor = [UIColor redColor];
                            
                            _numicon.frame = CGRectMake(SCREEN_WIDTH*0.58, self.iconHeight+28+height, 15, 10);
                            [_icon sd_setImageWithURL:[_model.img stringToUrl]];
        }
        else{
            [self showHint:model.message];
        }
        
    }];
    
}

- (void)setupNav{
    UIBarButtonItem * shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    [self.navigationItem setRightBarButtonItem:shareItem];
}


//分享
-(void)shareAction:(id)sender{
  
    NSString *url = _model.shareUrl;
    [ZSShare platShareView:self.view WithShareContent:@"智慧学习" WithShareUrlImg:@"logo" WithShareUrl:url WithShareTitle:_model.title];
    
}

-(void)setheadViewNoModel
{
    
    _headView = [[UIView alloc]init];
   
    if(_isCreateImg){
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, self.iconHeight)];
        [_headView addSubview:_icon];
    }
    

    _titleLabel = [[UILabel alloc]init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = KMainBlack;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;//表示label可以多行显示
    

    [_headView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]init];

    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.textColor = KMainTextGray;
    [_headView addSubview:_timeLabel];
    
   
    if(self.type == 1){
    _numicon = [[UIImageView alloc]init];
    _numicon.image = [UIImage imageNamed:@"per_browse"];
    [_headView addSubview:_numicon];
    
    

    _numLabel = [[UILabel alloc]init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = KMainTextGray;
    _headView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_numLabel];
    }
    else{
        
    }
    [self.view addSubview:self.headView];
        
    
    

    
    
    
}

- (void)keyboardWillShowOrHide:(NSNotification *)notification {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
