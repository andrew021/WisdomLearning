//
//  BaseTableViewController.h
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "UIHelper.h"
#import <UIKit/UIKit.h>

@interface kBaseTableViewController : UITableViewController {
}

@property (nonatomic, strong) UIView* noBuddyView;
-(UIView *)viewWithNoDataHint:(NSString *)noDataHint;
- (void)setupBackButtonItem;

@end
