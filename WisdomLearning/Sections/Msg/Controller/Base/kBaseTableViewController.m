//
//  BaseTableViewController.m
//  BigMovie
//
//  Created by Shane on 16/4/14.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "kBaseTableViewController.h"

@interface kBaseTableViewController ()

@end

@implementation kBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
}


- (void)setupBackButtonItem
{
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.navigationItem setLeftBarButtonItem:addItem];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 0;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if(!cell){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//    }
//    return cell;
//}

-(UIView *)noBuddyView{
    if (!_noBuddyView) {
        _noBuddyView = [self viewWithNoDataHint:@"暂无新朋友"];
    }
    return _noBuddyView;
}


-(UIView *)viewWithNoDataHint:(NSString *)noDataHint{
    UIView *noDataView = [[UIView alloc] initWithFrame:self.view.frame];
    UIImageView *ivImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 100,80, 95)];
    ivImage.image = [UIImage imageNamed:@"no_data"];
    UILabel *lbHint = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 30)];
    lbHint.textColor = KMainBarGray;
    lbHint.textAlignment = NSTextAlignmentCenter;

    [noDataView addSubview:lbHint];
    lbHint.text = noDataHint;
    [noDataView addSubview:ivImage];
    
    return noDataView;
}


@end
