//
//  ContactListViewController.h
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupListViewController.h"
#import "kBaseViewController.h"
@interface ContactListViewController : kBaseViewController

//好友请求变化时，更新好友请求未处理的个数
- (void)reloadApplyView;
//加载好友列表
-(void)loadContactDataSource;


@end
