//
//  BuddyApplyViewController.h
//  BigMovie
//
//  Created by Shane on 16/4/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewController.h"

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;



@interface ApplyViewController : kBaseTableViewController
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

+ (instancetype)shareController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)clear;
@end
