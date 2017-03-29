//
//  WorkTestViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "WorkTestViewController.h"
#import "OrderConfirmCell.h"
#import "WorkTestCell.h"
#import "WorkTestSelectCell.h"
#import "TestResultPopView.h"
#import "TestResultController.h"
#import "UIViewController+PagesControl.h"
#import "TestViewController.h"

@interface WorkTestViewController ()<ClickTestResultPopViewBtn,TestAnswerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UILabel * testNumLabel;
@property (nonatomic,strong) UILabel * testTimeLabel;
@property (nonatomic,strong) UIButton * submitBtn;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic,strong) TestResultPopView * popView;
@property (nonatomic)       int       m_countNum;
@property (nonatomic, strong) NSTimer        *m_timer;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * itemArr;
@property (nonatomic,strong) NSMutableArray * questionArr;
@property (nonatomic,strong) NSDictionary * questionDic;
@property (nonatomic,strong) NSMutableArray * historyArr;
@property (nonatomic,assign) BOOL isCanSideBack;
@property (nonatomic,strong) NSMutableArray * moreArr;

@property (nonatomic,strong) NSMutableArray * viewPages;
@property (nonatomic,assign) NSInteger numValue;
@property (nonatomic,strong) UIView *pagesView;



@end

@implementation WorkTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"作业测试";
    [self createTopAndBottomView];
    

   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    for (int i=0;i<10;i++){
        NSString * key = [NSString stringWithFormat:@"answerKey%ld",(long)i];
        NSUserDefaults * user = [[NSUserDefaults alloc]init];
        
        [user setObject:_questionDic forKey:key];
        [user synchronize];
    }
    _num = 1;
    _m_countNum = 3600;
    _testNumLabel.text = [NSString stringWithFormat:@"%ld/10",_num];
    [self createTimer];
    _testTimeLabel.text = [NSString stringWithFormat:@"%@",[self currentTimeString]];
    _dataArr = [[NSMutableArray alloc]init];
    _itemArr = [[NSMutableArray alloc]init];
    _questionArr = [[NSMutableArray alloc]init];
    _historyArr = [[NSMutableArray alloc]init];
    _moreArr = [[NSMutableArray alloc]init];
    _viewPages = [[NSMutableArray alloc]init];
    
    [self fetchData];
    [_pagesView removeFromSuperview];
    [self createPagesView];
}

#pragma mark--- 创建ViewControllers
-(void)createPagesView
{
    for (int i=0;i<10;i++){

        TestViewController * vc = [[TestViewController alloc]init];
        vc.delegate = self;
        vc.tag = i;
        vc.num = i+1;
        if(i<4){
           vc.num = i+1;
        }
        else{
            vc.num = 4;
        }
    
        
        [_viewPages addObject:vc];
    }
    
//    _pagesView = self
    
//    _pagesView = [self pageViewWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH,SCREEN_HEIGHT-50-64 ) andTitles:@[@"群消息", @"个人消息", @"系统消息"] andTitleFontSize:14 andImages:nil andImagePadding:SCREEN_WIDTH*0.064 andPageControllers:[self.viewPages copy] andSegmentColor:KMainBarGray];
    
//    _pagesView = self pagevie
    
    _pagesView = [self pagesViewWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH,SCREEN_HEIGHT-50-64 ) andTitles:@[@"群消息", @"个人消息", @"系统消息"]  andTitleFontSize:14 andImages:nil andPageControllers:[self.viewPages copy] andSegmentColor:KMainBarGray];
    [self.view addSubview:_pagesView];
    
}

-(void)sendTag:(NSInteger)tag
{

      _testNumLabel.text = [NSString stringWithFormat:@"%ld/10",(long)tag+1];
      _numValue = tag;
//    if(tag==9){
//        [self showHint:@"已经是最后一题了!"];
//    }
//    else if(tag == 0){
//        [self showHint:@"已经是第一题了!"];
//    }
//    else{
//        
//    }
}

-(void)fetchData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary * dic =@{@"testId":_testId};
    [self.request requestWorkTestWithDic:dic block:^(ZSWorkTestPaperModel *model, NSError *error) {
        [self hideHud];
        [_dataArr removeAllObjects];
        if(model.isSuccess){
            
        }else{
            
        }
    }];
}


- (NSString*)currentTimeString {
                               
        if (_m_countNum <= 0) {
                [_m_timer invalidate];                  
                return @"00:00";
                                   
        } else {
            
            return [NSString stringWithFormat:@"%02ld:%02ld",(long)_m_countNum%3600/60,(long)_m_countNum%60];
        }
                           
}
                           
- (void)createTimer {
    
    self.m_timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_m_timer forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    _m_countNum--;
    if(_m_countNum == 0){
        [self showHint:@"已到交卷时间!"];
    }
    _testTimeLabel.text = [NSString stringWithFormat:@"%@",[self currentTimeString]];
    
}

-(void)createTopAndBottomView
{
    NSArray * arr = @[@"exam_num",@"time_surplu"];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:view];
    for(int i=0;i<2;i++){
        UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(20+(SCREEN_WIDTH-110)*i, 12, 16, 16)];
        icon.image = [UIImage imageNamed:arr[i]];
        [self.view addSubview:icon];
        if(i==0){
            _testNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+(SCREEN_WIDTH-80)*i, 10, SCREEN_WIDTH/4, 20)];
            [self.view addSubview:_testNumLabel];
            _testNumLabel.textColor = KMainGray;
            
            
        }
        else {
            _testTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+(SCREEN_WIDTH-110)*i, 10, SCREEN_WIDTH/4, 20)];
            [self.view addSubview:_testTimeLabel];
            // _testTimeLabel.text = @"00:00";
            _testTimeLabel.textColor = KMainGray;
        
        }
        
    }
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-51, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:lineView];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(10, ViewMaxY(lineView)+3, SCREEN_WIDTH-20, 44);
    [_submitBtn setTitle:@"交卷" forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(clickSubmitBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.backgroundColor = kMainThemeColor;
    _submitBtn.layer.cornerRadius = 5;
    [self.view addSubview:_submitBtn];
    
}

//交卷
-(void)clickSubmitBtn:(UIButton*)btn
{
    NSLog(@"交卷");
     int a = 0;
    for (int i=0;i<10;i++){
        NSUserDefaults * user  = [[NSUserDefaults alloc]init];
        NSString * key = [NSString stringWithFormat:@"answerKey%ld",(long)i];
        NSDictionary * dic = [user objectForKey:key];
        if(dic==nil){
            dic = @{@"questionId":@"",@"answerText":@""};
            
        }
        else{
            a++;
        }
        [_questionArr addObject:dic];
    }
    NSString * haveStr = [NSString stringWithFormat:@"%d",a];
    _popView = [[TestResultPopView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5, 70, SCREEN_WIDTH/5*3, 230) withTitle:@"10" subTitle:haveStr image:[UIImage imageNamed:@"result_pop"]];
    _popView.layer.cornerRadius = 5;
    _popView.backgroundColor = [UIColor whiteColor];
    _popView.delegate = self;
    
    KLCPopup * popView = [KLCPopup popupWithContentView:_popView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
    [popView showWithLayout:KLCPopupLayoutCenter];
    popView.didFinishDismissingCompletion = ^{
     
    };

  
}


//TestResultPopView 按钮点击方法
-(void)clickTestResultPopViewBtn:(UIButton *)btn
{
    [_popView dismissPresentingPopup];

    if(btn.tag == 1){
        NSLog(@"确认交卷");
        [self.m_timer invalidate];
        TestResultController* view = (TestResultController*)[[UIStoryboard storyboardWithName:@"Study" bundle:nil] instantiateViewControllerWithIdentifier:@"testResult"];
        view.hidesBottomBarWhenPushed = YES;
        view.timeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)(3600-_m_countNum)%3600/60,(long)(3600-_m_countNum)%60];
        
        [self showHudInView:self.view hint:@"正在提交...."];
        NSDictionary * dic = @{@"testId":_testId,@"answerList":_questionArr};
        [self.request requestWorkTestResultWithDic:dic block:^(ZSWorkTestResultModel *model, NSError *error) {
            [self hideHud];
            if(model.isSuccess){
                 [self.navigationController pushViewController:view animated:YES];
            }
            else{
                [self showHint:model.message];
            }
        }];

       

    }
    else{
        NSLog(@"返回检查");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
