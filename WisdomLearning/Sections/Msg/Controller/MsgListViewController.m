//
//  MsgListViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MsgListViewController.h"

@interface MsgListViewController ()

@end

@implementation MsgListViewController

+(instancetype)initWithType:(MsgType)type
{
    MsgListViewController *vc = [MsgListViewController new];
    vc.type = type;
    switch (type) {
        case MsgGroup:
        {
            vc.title = @"群消息";
        }
            break;
        case MsgPersonal:
        {
            vc.title = @"个人消息";
        }
            break;
        case MsgSystem:
        {
            vc.title = @"系统消息";
        }
            break;
        default:
            break;
    }
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
