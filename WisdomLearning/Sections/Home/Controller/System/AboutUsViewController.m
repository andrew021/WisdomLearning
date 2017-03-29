//
//  AboutUsViewController.m
//  BigMovie
//
//  Created by ChenTao on 16/3/18.
//  Copyright © 2016年 zhisou. All rights reserved.
// 关于我们

#import "AboutUsViewController.h"
#import <Masonry.h>
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"关于我们";
//    [self creatUI];
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
//    
//}
- (void)creatUI{
    UIImage *iconImage = [UIImage imageNamed:@"login_logo"];
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = iconImage;
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(20);
    }];
    
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"大电影";
    [nameLabel setTextColor:[UIColor colorWithRed:8.0/255.0 green:8.0/255.0 blue:8.0/255.0 alpha:1]];
    nameLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(70);
        make.left.equalTo(iconImageView.mas_right).offset(10);
    }];
    
    UILabel *timeLabel = [UILabel new];
    [timeLabel setTextColor:[UIColor colorWithRed:63.0/255.0 green:63.0/255.0 blue:63.0/255.0 alpha:1]];
    timeLabel.text = @"1.0.0@2016 Dadianying Inc";
    timeLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(nameLabel.mas_bottom).offset(10);
        make.left.equalTo(nameLabel.mas_left).offset(0);
    }];

    //三个按钮
    UIButton *scoreBtn = [[UIButton alloc] init];

    [scoreBtn addTarget:self action:@selector(scoreClick) forControlEvents:UIControlEventTouchUpInside];
    [scoreBtn setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:187.0/255.0 blue:165.0/255.0 alpha:1]];
    [scoreBtn setTitle:@"去App Store 给大电影打分"forState:UIControlStateNormal];// 添加文字
    [scoreBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];

    [self.view addSubview:scoreBtn];
    [scoreBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(iconImageView.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-20);
    }];
    
    UIButton *founctiongBtn = [[UIButton alloc] init];
    [founctiongBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [founctiongBtn setBackgroundColor:[UIColor colorWithRed:25.0/255.0 green:187.0/255.0 blue:165.0/255.0 alpha:1]];
    [founctiongBtn addTarget:self action:@selector(founctionClick) forControlEvents:UIControlEventTouchUpInside];
    [founctiongBtn setTitle:@"功能说明"forState:UIControlStateNormal];// 添加文字
    [self.view addSubview:founctiongBtn];
    [founctiongBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(scoreBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-20);
    }];

    UIButton *aboutMoviceBtn = [[UIButton alloc] init];
    [aboutMoviceBtn setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];

    aboutMoviceBtn.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:187.0/255.0 blue:165.0/255.0 alpha:1];
    [aboutMoviceBtn addTarget:self action:@selector(aboutMoviceClick) forControlEvents:UIControlEventTouchUpInside];
    [aboutMoviceBtn setTitle:@"关于大电影"forState:UIControlStateNormal];// 添加文字
    [self.view addSubview:aboutMoviceBtn];
    [aboutMoviceBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(founctiongBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(-20);
    }];

    
}
- (void)scoreClick{

}
- (void)founctionClick{
    
}
- (void)aboutMoviceClick{
    
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
