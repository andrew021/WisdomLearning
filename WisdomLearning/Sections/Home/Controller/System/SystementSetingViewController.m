//
//  SystementSetingViewController.m
//  BigMovie
//
//  Created by ChenTao on 16/3/18.
//  Copyright © 2016年 zhisou. All rights reserved.
// 系统设置

#import "AboutUsViewController.h"
#import "AdviceBackViewController.h"
#import "FixPassWordViewController.h"
//#import "MineViewController.h"
#import "SystementSetingViewController.h"
#import "WebViewViewController.h"
//#import "ChatViewController.h"
#import "SysWebViewController.h"
#import "SuggestListController.h"

extern NSString * bindmanageurl;
extern NSString * useradviceurl;
extern NSString * aboutUs;
extern NSString * functionInfo;

@interface SystementSetingViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView* setTableView;
}
@property (nonatomic, assign) UISwitch* voiceAlertSwitch;

@end

@implementation SystementSetingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统设置";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor colorWithRed:231.0 / 255.0 green:231.0 / 255.0 blue:231.0 / 255.0 alpha:1];
    [self creatTableView];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
//    
//}
#pragma mark - Private
- (void)creatTableView
{
    setTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49) style:UITableViewStyleGrouped];
    setTableView.delegate = self;
    setTableView.dataSource = self;
    setTableView.scrollEnabled = NO;
    [self.view addSubview:setTableView];
}

#pragma mark - tableviewDelegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    else {
        return 2;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 47.5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
//    if (indexPath.section == 0) {
//        NSString* cellStr = @"celling";
//        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
//        }
//        UISwitch* voiceSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
//        self.voiceAlertSwitch = voiceSwitch;
//        [self.voiceAlertSwitch addTarget:self action:@selector(voiceOnOrOff) forControlEvents:UIControlEventValueChanged];
//        cell.textLabel.text = @"声音提醒";
//        cell.textLabel.font = [UIFont systemFontOfSize:17];
//        self.voiceAlertSwitch.on = YES;
//        cell.accessoryView = self.voiceAlertSwitch;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//
//        //        TitleAndSwitchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TitleAndSwitchTableViewCellIdentity"];
//        //        if (!cell) {
//        //            cell = (TitleAndSwitchTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TitleAndSwitchTableViewCellIdentity"];
//        //        }
//        //        cell.delegate = self;
//        //        cell.title.text = @"声音提醒";
//        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        //        return cell;
//    }
     if (indexPath.section == 0) {
         if(indexPath.row==0){
        NSString* cellStr = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        cell.textLabel.text = @"修改密码";
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
         }
        else {
            NSString* cellStr = @"cell";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.textLabel.text = @"社交账号绑定";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
         }
    }
    else if (indexPath.section == 1) {
        //        if (indexPath.row == 3) {
        //            NSString* cellStr = @"Cellse";
        //            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        //            if (!cell) {
        //                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        //            }
        //            cell.textLabel.text = @"版本更新";
        //            UILabel* upDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50), 18, 30, 15)];
        //            upDateLabel.text = @"v1.0";
        //            upDateLabel.font = [UIFont systemFontOfSize:13];
        //            upDateLabel.textColor = [UIColor colorWithRed:139.0 / 255.0 green:139.0 / 255.0 blue:139.0 / 255.0 alpha:1];
        //            [cell.contentView addSubview:upDateLabel];
        //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //            return cell;
        //        }
        //        else {
        NSString* cellStr = @"cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        NSArray* nameArr = @[ @"意见反馈", @"功能说明", @"关于我们", @"给我评分"];
        cell.textLabel.text = nameArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        //}
    }
    else {
        NSString* cellStr = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        UILabel* quitLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH / 2) - 30, 14, 200, 20)];
        quitLabel.text = @"退出登录";
        quitLabel.font = [UIFont systemFontOfSize:17];
        quitLabel.textColor = KLogoutButtonRed;
        [cell.contentView addSubview:quitLabel];
        [quitLabel sizeToFit];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 3) {
        //退出登录
        [self showHudInView:self.view hint:@"退出登录"];
        //环信退出登录
        __weak SystementSetingViewController* weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError* error = [[EMClient sharedClient] logout:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil) {
                    //  [weakSelf showHint:error.errorDescription];
                }
                else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                }
            });
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[Config Instance] clearUserData];
            [weakSelf hideHud];
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
//    else if (indexPath.section == 0) {
//        //声音设置
//    }
    else if (indexPath.section == 0) {
        //修改密码
        if(indexPath.row == 0){
          FixPassWordViewController* fixPassWordVC = [[FixPassWordViewController alloc] init];
          [self.navigationController pushViewController:fixPassWordVC animated:YES];
        }
        else{
            //功能说明
            SysWebViewController* vc = [[SysWebViewController alloc] init];
            vc.title = @"社交绑定账号";
            
            vc.urlStr = [NSString stringWithFormat:@"%@&userId=%@",bindmanageurl,gUserID];
            
            NSLog(@"++ %@",vc.urlStr);
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //意见反馈
//            SuggestListController * vc = [[SuggestListController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//            
            //功能说明
            SysWebViewController* vc = [[SysWebViewController alloc] init];
             vc.title = @"意见反馈";
            vc.urlStr = [NSString stringWithFormat:@"%@&userId=%@",useradviceurl,gUserID]
            ;
            
            NSLog(@"++ %@",vc.urlStr);
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if (indexPath.row == 2) {
            //关于我们
            SysWebViewController* vc = [[SysWebViewController alloc] init];
            vc.title = @"关于我们";
            vc.urlStr = [NSString stringWithFormat:@"%@&userId=%@",aboutUs,gUserID];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else if (indexPath.row == 1) {
            //功能说明
            SysWebViewController* vc = [[SysWebViewController alloc] init];
            vc.title = @"功能说明";
            vc.urlStr = [NSString stringWithFormat:@"%@&userId=%@",functionInfo,gUserID];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 3) {
            NSString *url = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",1214680220];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}

#pragma mark switch绑定的方法
- (void)voiceOnOrOff
{
    if ([self.voiceAlertSwitch isOn]) {
        self.voiceAlertSwitch.on = YES;
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        [defaults setValue:@"0" forKey:@"status3"];
    }
    else {
        self.voiceAlertSwitch.on = NO;

        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定关闭推送通知" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //        alert.tag = 1004;
        //        [alert show];
    }
}
- (void)didReceiveMemoryWarning
{
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
