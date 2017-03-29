//
//  LearnCircleViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//我的圈子

#import "LearnCircleViewController.h"
#import "LearnCircleCell.h"
#import "FindCircleController.h"

@interface LearnCircleViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LearnCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 112;
    _tableView.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
        static NSString* cellIdentifier = @"LearnCircleCellIdentity";
        LearnCircleCell* cell = (LearnCircleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LearnCircleCell" owner:nil options:nil] lastObject];
        }

        return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FindCircleController* view = (FindCircleController*)[[UIStoryboard storyboardWithName:@"LearnCircle" bundle:nil] instantiateViewControllerWithIdentifier:@"FindCircle"];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
