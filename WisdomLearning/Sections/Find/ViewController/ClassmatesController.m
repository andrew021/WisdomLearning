//
//  ClassmatesController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassmatesController.h"
#import "ClassmatesCell.h"
#import "ChatViewController.h"
#import "IndividualHomepageController.h"

@interface ClassmatesController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *joinChatButton;


@end

@implementation ClassmatesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.joinChatButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIButton *)joinChatButton{
    if (!_joinChatButton) {
        _joinChatButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame)+5, SCREEN_WIDTH-20, 40)];
        [_joinChatButton setTitle:@"进入群聊" forState:UIControlStateNormal];
        [_joinChatButton setBackgroundColor:kMainThemeColor];
        [_joinChatButton addTarget:self action:@selector(clickChat:) forControlEvents:UIControlEventTouchUpInside];
        _joinChatButton.layer.cornerRadius = 4;
    }
    return _joinChatButton;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64.0-75-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ClassmatesCell" bundle:nil] forCellReuseIdentifier:@"ClassmatesCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}


#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassmatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassmatesCell" forIndexPath:indexPath];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IndividualHomepageController *destVc = [[IndividualHomepageController alloc] init];
    [self.navigationController pushViewController:destVc animated:YES];
}

-(void)clickChat:(UIButton *)sender{
    ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:@"254227801324913064"conversationType:EMConversationTypeGroupChat];
    [self.navigationController pushViewController:chatController animated:YES];
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
