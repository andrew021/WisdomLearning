//
//  PersonViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "PersonViewController.h"
#import "AppDelegate.h"
#import "TextAndImageCell.h"
#import "MyCreditViewController.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>

#import "MyOrderViewController.h"
#import "MyInformationViewController.h"
#import "MyCurrencyViewController.h"
#import "SystementSetingViewController.h"
#import "UIViewController+ModifyPhoto.h"
#import "ZSUploader.h"
#import "EditViewController.h"
#import "MyCertificateViewController.h"
#import "MyCreditViewController.h"

extern NSString *avaterimguploadurl;
extern NSString *orderform;

@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *headerImageView;
    UILabel *nicknameLabel;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, copy) NSString *myUndefined;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kMainThemeColor;
    
    _myUndefined = [@"我的" add: resunit];
    
    if ([orderform isEqualToString:@"on"]) {
        if ([coin isEqualToString:@"on"]) {
        }else{
            [self.titleArray removeObjectAtIndex:1];
            [self.imageArray removeObjectAtIndex:1];
        }
       
    } else {
        if ([coin isEqualToString:@"on"]) {
            [self.titleArray removeObjectAtIndex:0];
            [self.imageArray removeObjectAtIndex:0];
        }else{
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            [indexSet addIndex:0];
            [indexSet addIndex:1];
            [self.titleArray removeObjectsAtIndexes:indexSet];
            [self.imageArray removeObjectsAtIndexes:indexSet];
        }
    }

    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bg.image = [ThemeInsteadTool imageWithImageName:@"per_bg"];
    [self.view addSubview:bg];
    
    
    [self.view addSubview:self.tableView];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(30.0, _tableView.bounds.size.height - 43.0, 17.0, 17.0)];
    image.image = [UIImage imageNamed:@"login_out"];
    [_tableView addSubview:image];
    
    UIButton * logoutBtn = [[UIButton alloc]initWithFrame:CGRectMake(30.0, _tableView.bounds.size.height - 50.0, 70.0, 30.0)];
    [logoutBtn setTitle:@"    退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:KMainGray forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess) name:LOGINSUCCESS object:nil];
    [_tableView addSubview:logoutBtn];
}

-(NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"我的订单", @"我的学币",_myUndefined, @"我的证书", @"修改个人信息", @"设置"].mutableCopy;
    }
    return _titleArray;
}

-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"per_order", @"per_learnCoin",@"per_credit",@"per_cer",@"per_put", @"per_setup"].mutableCopy;
    }
    return _imageArray;
}


#pragma mark ---登录成功
-(void)loginSucess{
    [self initUser];
}

#pragma mark ---设置用户名和图像
-(void)initUser{
    NSURL *url = [[[Config Instance] getUsericon] stringToUrl];
    [headerImageView sd_setImageWithURL:url];
    [nicknameLabel setText:[[Config Instance] getUserNickname]];
}
#pragma mark --- 退出登录
-(void)logoutClick
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC closeLeftView];
    SSEBaseUser *user = [[Config Instance] getThirtyPartyUserInfo];
    if (user) {  //第三方登录的退出
        BOOL isLogout = [SSEThirdPartyLoginHelper logout:user];
        if (isLogout) {
            NSLog(@"退出第三方登录成功");
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutLocation" object:nil];
    [[Config Instance] clearUserData];
   
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    [self showHint:@"退出成功"];
}

#pragma mark --- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor greenColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.userInteractionEnabled = YES;
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"TextAndImageCell" bundle:nil] forCellReuseIdentifier:@"textAndImageCell"];
        _tableView.tableHeaderView = self.headView;
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextAndImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textAndImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.titleLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.headerImage.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    UIViewController *vc;

//    _titleArray = [NSArray arrayWithObjects:@"我的订单", @"我的学币", @"设置",  nil];
    NSString *contentStr = _titleArray[indexPath.row];
    
//    UIViewController *vc = [contentStr isEqualToString:@"我的学币"] ? [MyCurrencyViewController new] : ([contentStr isEqualToString:@"设置"] ? [SystementSetingViewController new] : ([contentStr isEqualToString:@"修改个人信息"] ? [EditViewController new]: [MyOrderViewController new]));
    
    
    UIViewController *vc = [contentStr isEqualToString:@"我的学币"] ? [MyCurrencyViewController new] :([contentStr isEqualToString:_myUndefined] ? [MyCreditViewController new] :([contentStr isEqualToString:@"我的证书"] ? [MyCertificateViewController new]: ([contentStr isEqualToString:@"设置"] ? [SystementSetingViewController new] : ([contentStr isEqualToString:@"修改个人信息"] ? [EditViewController new]: [MyOrderViewController new]))));
    
    
    [app.LeftSlideVC closeLeftView];
    [app.homeNav setNavigationBarHidden:NO animated:NO];
    [app.homeNav pushViewController:vc animated:YES];
    [app.LeftSlideVC setPanEnabled:NO];
    
    SideslipSingle *side = [SideslipSingle sharedInstance];
    side.isSideslip = YES;
    
   // if(indexPath.row)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//表头
-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160.0)];
        _headView.backgroundColor = [UIColor clearColor];
        
        headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15.0, 70.0, 70.0, 70.0)];
        headerImageView.layer.cornerRadius = 35.0;
        [headerImageView setClipsToBounds:YES];
        headerImageView.layer.borderColor = [UIColor colorFromHexString:@"84baed"].CGColor;
        headerImageView.layer.borderWidth = 1.0;
        headerImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [headerImageView addGestureRecognizer:tapGr];
        
        [_headView addSubview:headerImageView];
        nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewMaxX(headerImageView) + 10.0, headerImageView.center.y - 10.0, 120.0, 20.0)];
        nicknameLabel.textColor = [UIColor whiteColor];
        [_headView addSubview:nicknameLabel];
    }
    return _headView;
}

-(void)tapAction:(UITapGestureRecognizer *)gr{
    [self toChoosePhotoSucessBlock:^(UIImage *imageChoose) {
        headerImageView.image = imageChoose;
        NSDictionary *dict = @{@"newImage":imageChoose};
        [[NSNotificationCenter defaultCenter] postNotificationName:CHANGEPERSONICONSUCESS object:self userInfo:dict];
        
        NSData * data = UIImageJPEGRepresentation(imageChoose, 1.0);
        [[ZSUploader sharedInstance] uploadImage:data url:avaterimguploadurl token:gUserID userid:gUserID completeHandler:^(ZSUploaderRespModel *respModel) {
            if (respModel.url !=nil) {
                
            }else {
                [self showHint:respModel.msg];
            }
        }];

    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:NO];
    [self initUser];
}

@end
