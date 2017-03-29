//
//  kBaseViewController.h
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHelper.h"
#import "kBaseViewControllerProtocol.h"
#import "UIScrollView+EmptyDataSet.h"

@interface kBaseViewController :UIViewController<UITableViewDelegate, UITableViewDataSource, kBaseViewControllerProtocol>


//property
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *noGroupView;
#pragma mark - UITableView
@property (copy, nonatomic) UITableViewCell *(^cellForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic) NSArray *(^sectionIndexTitlesForTableViewCompletion)(UITableView *tableView);
@property (strong, nonatomic) NSInteger (^numberOfSectionsInTableViewCompletion)(UITableView *tableView);
@property (copy, nonatomic) NSInteger (^numberOfRowsInSectionCompletion)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) NSString *(^titleForHeaderInSectionCompletion)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) NSInteger (^sectionForSectionIndexTitleCompletion)(UITableView *tableView, NSString *title, NSInteger index);
@property (copy, nonatomic) void (^didSelectRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic) UIView *(^viewForHeaderInSectionCompletion)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) CGFloat (^heightForRowAtIndexPathCompletion)(UITableView *tableView, NSIndexPath *indexPath);
@property (copy, nonatomic) CGFloat (^heightForHeaderInSectionCompletion)(UITableView *tableView, NSInteger section);
@property (copy, nonatomic) CGFloat (^heightForFooterInSectionCompletion)(UITableView *tableView, NSInteger section);

//method
- (void)setupBackButtonItem;
#pragma mark - UITableView
- (void)crateTableViewWithFrame:(CGRect) rect andStyle:(UITableViewStyle)style;



@end
