//
//  GroupSetViewController.m
//  BigMovie
//
//  Created by hfcb001 on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//个人设置


#import "PersonalSetViewController.h"
#import "ChatDemoHelper.h"

@interface PersonalSetViewController () <UITableViewDelegate, UITableViewDataSource>{
   // ContactListViewController *_contactList;
}
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) UISwitch* voiceAlertSwitch;
@property (strong, nonatomic) EMConversation* conversation;
@property (assign,nonatomic) BOOL isChatTop;
@property (assign,nonatomic) BOOL isBlock;
@end

@implementation PersonalSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    _conversation = [[EMClient sharedClient].chatManager getConversation:_accountStr type:EMConversationTypeChat createIfNotExist:YES];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * chatId = [user objectForKey:@"chatOnTop"];
    if([_conversation.conversationId isEqualToString:chatId]){
        _isChatTop = YES;
    }
    else{
        _isChatTop = NO;
    }
    
    NSUserDefaults * block = [NSUserDefaults standardUserDefaults];
    NSString * isBlock = [block objectForKey:_conversation.conversationId];
    if([_conversation.conversationId isEqualToString:isBlock]){
        _isBlock = YES;
    }
    else{
        _isBlock = NO;
    }

    [self setupTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else {
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0){
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
            if(_isBlock){
                self.voiceAlertSwitch.on = YES;
            }else{
                self.voiceAlertSwitch.on = NO;
            }
            cell.accessoryView = self.voiceAlertSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else{
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
            if(_isChatTop){
                self.voiceAlertSwitch.on = YES;
            }
            else{
                self.voiceAlertSwitch.on = NO;
            }
            cell.accessoryView = self.voiceAlertSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
             return cell;
        }
    }
    else if (indexPath.section == 1) {
        
            NSString* cellStr = @"celling";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
            }

            cell.textLabel.text =@"清空聊天记录";
            cell.textLabel.font = [UIFont systemFontOfSize:17];
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
        quitLabel.text = @"删除好友";
        quitLabel.textAlignment = NSTextAlignmentCenter;
        if(_isFriend){
            quitLabel.textColor = kTextLightGray;
            
        }else{
            quitLabel.textColor = KLogoutButtonRed;
        }
        [cell.contentView addSubview:quitLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)voiceOnOrOff:(UISwitch*)sender
{
    if(sender.tag == 0){
        _isBlock = !_isBlock;
        if(_isBlock){
            //消息免打扰
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:_conversation.conversationId forKey:_conversation.conversationId];
            [user synchronize];
            
//            NSMutableArray * arr = [[NSMutableArray alloc]init];
//            NSUserDefaults * dior = [NSUserDefaults standardUserDefaults];
//            NSArray * diorArr = [dior objectForKey:@"personalMsgShield"];
//            [arr addObjectsFromArray:diorArr];
//            [arr addObject:_conversation.conversationId];
//            [dior setObject:arr forKey:@"personalMsgShield"];
//            [dior synchronize];
            
            
        }
        else{
            //
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"no" forKey:_conversation.conversationId];
            [user synchronize];
            
//            NSMutableArray * arr = [[NSMutableArray alloc]init];
//            NSUserDefaults * dior = [NSUserDefaults standardUserDefaults];
//            NSArray * diorArr = [dior objectForKey:@"personalMsgShield"];
//            [arr addObjectsFromArray:diorArr];
//            for (int i=0;i<arr.count;i++){
//                if([_conversation.conversationId isEqualToString:arr[i]]){
//                    [arr removeObjectAtIndex:i];
//                }
//            }
//            [dior setObject:arr forKey:@"personalMsgShield"];
//            [dior synchronize];
//
            
        }

        
    }else{
        _isChatTop = !_isChatTop;
        if(_isChatTop){
          //聊天消息置顶
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:_conversation.conversationId forKey:@"chatOnTop"];
            [user synchronize];
        }
        else{
          //聊天消息不置顶
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:@"no" forKey:@"chatOnTop"];
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
    
    if (indexPath.section == 1) {
     
            [self.conversation deleteAllMessages];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:self];
            [self showHint:@"聊天记录清空成功!"];
            
     
    }
    else if(indexPath.section == 2){
        // 删除好友
      //  if(!_isFriend){
        [self showHudInView:self.view hint:@"正在删除"];
        IMRequest * request = [[IMRequest alloc]init];
        [request requestDealFriend:_accountStr status:@"3" block:^(ZSModel *model, NSError *error) {
            if(model.isSuccess){
                [self showHint:model.message];
                [[EMClient sharedClient].chatManager deleteConversation:_conversation.conversationId deleteMessages:YES];
//                if(_isMsg){
//                    MsgViewController* vc = (MsgViewController*)[[self.navigationController viewControllers] objectAtIndex:0];
//                    [self.navigationController popToViewController:vc animated:YES];
//                }
//                else{
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
             //   }
                
            }
            else{
                [self showHint:model.message];
            }

        }];

       // }

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
