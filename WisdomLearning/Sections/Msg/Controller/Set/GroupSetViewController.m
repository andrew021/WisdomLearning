//
//  GroupSetViewController.m
//  BigMovie
//
//  Created by hfcb001 on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//群设置

#import "ContactListViewController.h"
#import "GroupListViewController.h"
#import "GroupMemberViewController.h"
#import "GroupSetViewController.h"
#import "LabelAndSelectCell.h"


@interface GroupSetViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EMGroupManagerDelegate>

@property (nonatomic) GroupOccupantType occupantType;
@property (strong, nonatomic) EMGroup* chatGroup;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) UISwitch* voiceAlertSwitch;
@property (strong, nonatomic) EMConversation* conversation;
@property (strong, nonatomic) UIView* backGroundViews;
@property (strong, nonatomic) UIView* tagViews;
@property (strong, nonatomic) UITextField* tagTextField;
@property (strong, nonatomic) NSString* nickName;
@property (strong, nonatomic) NSMutableArray* dataSource;
@property (assign, nonatomic) BOOL isChatTop;
@property (assign, nonatomic) BOOL isBlock;
@property (strong, nonatomic) ZSMessageGroupSettingModel* setModel;

@end

@implementation GroupSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"群组设置";

    _dataSource = [[NSMutableArray alloc] init];
    _conversation = [[EMClient sharedClient].chatManager getConversation:_accountStr type:EMConversationTypeGroupChat createIfNotExist:YES];
    [self setupTableView];
    _chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    // [self fetchGroupInfo];

    NSUserDefaults* groupMember = [NSUserDefaults standardUserDefaults];
    _memberCount = [groupMember objectForKey:@"groupMemberCount"];

    _dataArr = [[NSMutableArray alloc] init];
    // [_dataArr addObjectsFromArray:[TypeManager sharedAPI].groupMember];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];

    NSString* chatId = [user objectForKey:@"chatOnTop"];
    if ([_conversation.conversationId isEqualToString:chatId]) {
        _isChatTop = YES;
    }
    else {
        _isChatTop = NO;
    }

    NSUserDefaults* block = [NSUserDefaults standardUserDefaults];
    NSString* isBlock = [block objectForKey:_conversation.conversationId];
    if ([_conversation.conversationId isEqualToString:isBlock]) {
        _isBlock = YES;
    }
    else {
        _isBlock = NO;
    }
    [self createRefresh];
}


//刷新数据
- (void)createRefresh
{
    __weak GroupSetViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
        [weakSelf.tableView reloadData];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchData];
    self.navigationController.navigationBar.barTintColor = kMainThemeColor;
    [self preferredStatusBarStyle];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{

    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    return UIStatusBarStyleLightContent;
}

- (void)setupTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49) style:UITableViewStyleGrouped];
    self.tableView.autoresizesSubviews = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    else if (section == 3) {
        return 1;
    }
    else if(section==2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    // GroupMemberListModel * model = _dataArr[indexPath.row];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            LabelAndSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"labelAndSelect"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndSelectCell" owner:nil options:nil] lastObject];
            }
            cell.titleLabel.text = @"群组名称";
            cell.subLabel.text = _setModel.GP_NAME;
            cell.subLabel.textColor = kTextLightGray;
            cell.titleLabel.font = [UIFont systemFontOfSize:17];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setAccessoryType:UITableViewCellAccessoryNone]; 
            return cell;
        }
        else  {
            LabelAndSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"labelAndSelect"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LabelAndSelectCell" owner:nil options:nil] lastObject];
            }
//@"群昵称"
            NSArray* arr = @[@"全部群成员",@"群昵称" ];
            cell.titleLabel.text = arr[indexPath.row - 1];
            if (indexPath.row == 1) {
               
               // cell.subLabel.text = _setModel.GM_CARD;
                  cell.subLabel.text = _setModel.GM_SIZE;
                
            }
            else {

                cell.subLabel.text = _setModel.GM_CARD;
            }
            cell.subLabel.textColor = kTextLightGray;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
   
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString* cellStr = @"celling";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            UISwitch* voiceSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            self.voiceAlertSwitch = voiceSwitch;
            self.voiceAlertSwitch.tag = indexPath.row;
            [self.voiceAlertSwitch addTarget:self action:@selector(voiceOnOrOff:) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text = @" 消息免打扰";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            if (_isBlock) {
                self.voiceAlertSwitch.on = YES;
            }
            else {
                self.voiceAlertSwitch.on = NO;
            }

            cell.accessoryView = self.voiceAlertSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            NSString* cellStr = @"celling";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            UISwitch* voiceSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            self.voiceAlertSwitch = voiceSwitch;
            self.voiceAlertSwitch.tag = indexPath.row;
            [self.voiceAlertSwitch addTarget:self action:@selector(voiceOnOrOff:) forControlEvents:UIControlEventValueChanged];
            cell.textLabel.text = @" 聊天置顶";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            if (_isChatTop) {
                self.voiceAlertSwitch.on = YES;
            }
            else {
                self.voiceAlertSwitch.on = NO;
            }
            cell.accessoryView = self.voiceAlertSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section == 2) {
      
            NSString* cellStr = @"celling";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }
            cell.textLabel.text = @"清空聊天记录";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        
    }
    else {
        NSString* cellStr = @"Cell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        }
        UILabel* quitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        
        quitLabel.text = @"删除并退出该群组";
        quitLabel.textAlignment = NSTextAlignmentCenter;
        quitLabel.textColor = KLogoutButtonRed;        
        [cell.contentView addSubview:quitLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
}

- (void)voiceOnOrOff:(UISwitch*)sender
{
    if (sender.tag == 0) {
        //群消息免打扰
        NSLog(@"+++++  %@",_conversation.conversationId);
        _isBlock = !_isBlock;
        if (_isBlock) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                // [[EMClient sharedClient].groupManager blockGroup:_conversation.conversationId error:&error];
          
                EMError* error = [[EMClient sharedClient].groupManager ignoreGroupPush:_conversation.conversationId ignore:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                    }
                    else {
                        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                        [user setObject:_conversation.conversationId forKey:_conversation.conversationId];
                        [user synchronize];
                    }
                });

            });
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //                EMError *error;
                //                [[EMClient sharedClient].groupManager unblockGroup:_conversation.conversationId error:&error];
                EMError* error = [[EMClient sharedClient].groupManager ignoreGroupPush:_conversation.conversationId ignore:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                    }
                    else {
                        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                        [user setObject:@"" forKey:_conversation.conversationId];
                        [user synchronize];
                    }
                });
            });
        }
    }
    else {
        _isChatTop = !_isChatTop;
        if (_isChatTop) {
            //聊天消息置顶
            NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
            [user setObject:_conversation.conversationId forKey:@"chatOnTop"];
            [user synchronize];
        }
        else {
            //聊天消息不置顶
            NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"" forKey:@"chatOnTop"];
            [user synchronize];
        }
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {

            [self.conversation deleteAllMessages];
            [self showHint:@"聊天记录清空成功!"];
   
    }
    else if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           // [self creatTagView];
        }
        else if (indexPath.row == 1) {
            GroupMemberViewController* view = [[GroupMemberViewController alloc] init];
            view.conversation = _conversation;
            view.dataArray = _dataSource;
            view.owerId = self.chatGroup.owner;
            view.chatGroup = _chatGroup;
            view.groupId = _setModel.GP_ID;
            view.title = [NSString stringWithFormat:@"全部群成员(%@)", _setModel.GM_SIZE];
            if (self.occupantType == GroupOccupantTypeOwner) {
                view.occupantType = GroupTypeOwner;
            }
            else {
                view.occupantType = GroupTypeMember;
            }
            [self.navigationController pushViewController:view animated:YES];
        }
        else {
            [self creatTagView];
        }
    }
    else if (indexPath.section == 1) {
    }
    else {
        //群主解散群组
        if (_setModel.GM_TYPE == 1) {
            [self showHint:@"您是群主，不能退群!"];
        }
        else if(_setModel.GM_TYPE == 2){
            [self showHudInView:self.view hint:@"正在退群..."];
            IMRequest * request = [[IMRequest alloc]init];
            
            [request requestDeleteGroupMember:_setModel.GM_ID type:@"0" block:^(ZSModel* model, NSError* error) {
                [self hideHud];
                if (model.isSuccess) {
                    
                    [self showHint:model.message];
                    
                    [[EMClient sharedClient].chatManager deleteConversation:_conversation.conversationId deleteMessages:YES];
                    //                    if (_isMsg) {
                    //                        MsgViewController* vc = (MsgViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
                    //                        [self.navigationController popToViewController:vc animated:YES];
                    //                    }
                    //                    else {
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    //   }
                }
                else {
                    [self showHint:model.message];
                }
                
            }];

        }
        else {

            [self showHudInView:self.view hint:@"正在退群..."];
            IMRequest * request = [[IMRequest alloc]init];
            
            [request requestDeleteGroupMember:_setModel.GM_ID type:@"0" block:^(ZSModel* model, NSError* error) {
                [self hideHud];
                if (model.isSuccess) {
                   
                    [self showHint:model.message];
                    
                    [[EMClient sharedClient].chatManager deleteConversation:_conversation.conversationId deleteMessages:YES];
//                    if (_isMsg) {
//                        MsgViewController* vc = (MsgViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
//                        [self.navigationController popToViewController:vc animated:YES];
//                    }
//                    else {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                 //   }
                }
                else {
                    [self showHint:model.message];
                }

            }];
        }
    }
}

- (void)creatTagView
{
    _backGroundViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backGroundViews.backgroundColor = [UIColor blackColor];
    _backGroundViews.alpha = 0.4;
    [self.view addSubview:_backGroundViews];

    _tagViews = [[UIView alloc] initWithFrame:CGRectMake(15, 100, SCREEN_WIDTH - 30, 180)];
    _tagViews.clipsToBounds = YES;
    _tagViews.layer.cornerRadius = 5.0;
    _tagViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tagViews];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((_tagViews.width - 100) / 2, 10, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = @"修改群昵称";
    [_tagViews addSubview:titleLabel];

    _tagTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, _tagViews.width, 50)];
    _tagTextField.delegate = self;
    _tagTextField.backgroundColor = [UIColor colorWithRed:241.0 / 255.0 green:241.0 / 255.0 blue:241.0 / 255.0 alpha:1];
    _tagTextField.clearButtonMode = UITextFieldViewModeAlways;
    //原昵称
    _tagTextField.text = _nickName;
    [_tagViews addSubview:_tagTextField];
    UIView* paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    _tagTextField.leftView = paddingView1;
    _tagTextField.leftViewMode = UITextFieldViewModeAlways;

    UIButton* cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 125, (_tagViews.width - 45) / 2, 40)];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.clipsToBounds = YES;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = kLineLight.CGColor;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [_tagViews addSubview:cancelBtn];

    UIButton* sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(_tagViews.width - 15 - ((_tagViews.width - 45) / 2), 125, (_tagViews.width - 45) / 2, 40)];
    [sureBtn setBackgroundColor:[UIColor colorWithRed:26.0 / 255.0 green:188.0 / 255.0 blue:162.0 / 255.0 alpha:1]];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 5;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [_tagViews addSubview:sureBtn];
}

- (void)sureClick
{

    [self showHudInView:self.view hint:@"提交中..."];
    IMRequest * request = [[IMRequest alloc]init];
    [request requestEditGroupCard:_setModel.GM_ID group_card:_tagTextField.text block:^(ZSModel* model, NSError* error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self fetchData];
            _nickName = _tagTextField.text;
        }
        else {
            [self showHint:model.message];
        }
    }];

    [self.view endEditing:YES];
    _backGroundViews.hidden = YES;
    _tagViews.hidden = YES;
    [self.tableView reloadData];
}

- (void)cancelClick
{
    [self.view endEditing:YES];
    _backGroundViews.hidden = YES;
    _tagViews.hidden = YES;
}

//修改昵称刷新数据
- (void)fetchData
{
    IMRequest * request = [[IMRequest alloc]init];
    [request requestGroupSet:_accountStr block:^(ZSMessageGroupSetModel* model, NSError* error) {
        if (model.isSuccess) {
           // [self showHint:model.message];
            _setModel = model.data;
            [self.tableView reloadData];
        }
        else {
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
