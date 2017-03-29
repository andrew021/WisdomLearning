//
//  GroupMsgListViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//群消息

#import "GroupMsgListViewController.h"
#import "ChatViewController.h"
#import "ZSIndividualDetailModel.h"
#import "LGAlertView.h"
#import "UIViewController+LoadLoginView.h"

@interface GroupMsgListViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@end

@implementation GroupMsgListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    [self tableViewDidTriggerHeaderRefresh];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRefreshMessage) name:@"refreshMessage" object:nil];
   [self removeEmptyConversationsFromDB];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    
    [self indirectLoginViewWithLoginSucessBlock:^{
        //self.navigationController.navigationBarHidden = NO;
        [self.tableView reloadData];
    } andLogoutBlock:^{
       // self.navigationController.navigationBarHidden = YES;
    }];
}

-(void)getRefreshMessage
{
    
    [self tableViewDidTriggerHeaderRefresh];
    
}
- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView
{
    UIImage* img = [ThemeInsteadTool imageWithImageName:@"Dia_NoContent"];;
    return img;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView
{
    return YES;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30.0f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -60.f;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无消息";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self tableViewDidTriggerHeaderRefresh];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    //[self refresh];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray* conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray* needRemoveConversations;
    for (EMConversation* conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController*)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    if (conversationModel) {
        EMConversation* conversation = conversationModel.conversation;
        if (conversation) {
           
            {
                if([gUsername isEqualToString:@"hy_px_demo"]){
                    return [self showHint:@"访客账号不能聊天!"];
                }
                
                ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                chatController.hidesBottomBarWhenPushed = YES;
                chatController.ID = conversation.conversationId;
                //chatController.accountStr = conversation.conversationId;
                  chatController.title = conversationModel.title;
                //  chatController.isMsg = YES;
                    chatController.avatar = conversation.ext[@"userAvatar"];
                    chatController.nickName = conversation.ext[@"nickName"];
                //                chatController.fromSpecificPage = YES;
                
                [self.navigationController pushViewController:chatController animated:YES];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController*)conversationListViewController
                                    modelForConversation:(EMConversation*)conversation
{
    
    EaseConversationModel* zmodel = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (zmodel.conversation.type == EMConversationTypeChat) {
        return nil;
    }
    else  {
        ZSMessageGroupModel* group = [[GroupsManager sharedGroupsManager] groupModelByGroupId:conversation.conversationId];
        if (group) {
            
            zmodel.title = group.GP_NAME;
        }
        zmodel.avatarImage = [ThemeInsteadTool imageWithImageName:@"group_icon"];
        
        return zmodel;
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - long press delegate
- (void)longPressAtIndexPath:(NSIndexPath*)indexPath
{
    LGAlertView* alertView = [[LGAlertView alloc] initWithTitle:nil
                                                        message:nil
                                                          style:LGAlertViewStyleActionSheet
                                                   buttonTitles:@[ @"删除该聊天" ]
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"置顶聊天"
                                                  actionHandler:^(LGAlertView* alertView, NSString* title, NSUInteger index) {
                                                      NSLog(@"删除该聊天");
                                                      
                                                      EaseConversationModel* model = [self.dataArray objectAtIndex:indexPath.row];
                                                      [[EMClient sharedClient].chatManager deleteConversation:model.conversation.conversationId deleteMessages:YES];
                                                      [self.dataArray removeObjectAtIndex:indexPath.row];
                                                      [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                      [self.tableView reloadData];
                                                  }
                                                  cancelHandler:nil
                                             destructiveHandler:^(LGAlertView* alertView) {
                                                 NSLog(@"置顶聊天");
                                                 
                                                 EaseConversationModel* model = [self.dataArray objectAtIndex:indexPath.row];
                                                 [self.dataArray removeObjectAtIndex:indexPath.row];
                                                 [self.dataArray insertObject:model atIndex:0];
                                                 
                                                 NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                                                 [user setObject:model.conversation.conversationId forKey:@"chatOnTop"];
                                                 [user synchronize];
                                                 [self.tableView reloadData];
                                                 
                                             }];
    
    alertView.coverColor = [UIColor colorWithWhite:0.85f alpha:0.9];
    alertView.layerShadowColor = [UIColor colorWithWhite:0.f alpha:0.3];
    alertView.layerShadowRadius = 4.f;
    alertView.layerCornerRadius = 0.f;
    alertView.layerBorderWidth = 2.f;
    alertView.layerBorderColor = [UIColor whiteColor];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.buttonsHeight = 56.f;
    alertView.buttonsFont = [UIFont systemFontOfSize:20.f];
    alertView.cancelButtonFont = [UIFont systemFontOfSize:20.f];
    alertView.destructiveButtonFont = [UIFont systemFontOfSize:20.f];
    alertView.buttonsTitleColor = [UIColor blackColor];
    alertView.destructiveButtonTitleColor = [UIColor blackColor];
    alertView.cancelButtonTitleColor = [UIColor redColor];
    alertView.width = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    alertView.offsetVertical = 16.f;
    alertView.cancelButtonOffsetY = 3.f;
    alertView.buttonsBackgroundColorHighlighted = [UIColor lightGrayColor];
    alertView.cancelButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
    alertView.destructiveButtonBackgroundColorHighlighted = [UIColor lightGrayColor];
    [alertView showAnimated:YES completionHandler:nil];
}

//获取最后一条消息的类型
- (NSString*)conversationListViewController:(EaseConversationListViewController*)conversationListViewController
     latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString* latestMessageTitle = @"";
    EMMessage* lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody* messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage: {
                latestMessageTitle = NSLocalizedString(@"[图片]", @"[image]");
                //                latestMessageTitle = @"[图片]";
            } break;
            case EMMessageBodyTypeText: {
                // 表情映射。
                NSString* didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody*)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice: {
                latestMessageTitle = NSLocalizedString(@"[语音]", @"[voice]");
                //              latestMessageTitle = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
                //               latestMessageTitle = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
                //               latestMessageTitle = @"[视频]";
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
                //               latestMessageTitle = @"[文件]";
            } break;
            default: {
            } break;
        }
    }
    
    return latestMessageTitle;
}

//获取最后一条消息的时间
- (NSString*)conversationListViewController:(EaseConversationListViewController*)conversationListViewController
      latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString* latestMessageTime = @"";
    EMMessage* lastMessage = [conversationModel.conversation latestMessage];
    ;
    if (lastMessage) {
       latestMessageTime = [NSDate formatLastMessageTime:lastMessage.timestamp];
       // latestMessageTime = @"179人";
    }
    
    return latestMessageTime;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
