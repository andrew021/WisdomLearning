//
//  kBaseViewControllerProtocol.h
//  BigMovie
//
//  Created by Shane on 16/4/21.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol kBaseViewControllerProtocol <NSObject>

//下拉刷新
- (void)pullDown;
//tableViewBlocks
- (void)tableViewBlocks;
//选中cell
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView;
//cell
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath forTableView:(UITableView *)tableView;

@end
