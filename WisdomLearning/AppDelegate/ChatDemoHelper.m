/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatDemoHelper.h"

#import "AppDelegate.h"
//#import "ApplyViewController.h"
#import "MBProgressHUD.h"
#import "LoginController.h"

#ifdef REDPACKET_AVALABLE
#import "RedpacketOpenConst.h"
#import "RedPacketUserConfig.h"
#import "UserProfileManager.h"


//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString* kMessageType = @"MessageType";
static NSString* kConversationChatter = @"ConversationChatter";
static NSString* kGroupName = @"GroupName";
static NSInteger loginNum = 0;

#endif

#import "EaseSDKHelper.h"

#if DEMO_CALL == 1

#import "CallViewController.h"

@interface ChatDemoHelper()<EMCallManagerDelegate>
{
    NSTimer *_callTimer;
}



@end

#endif

static ChatDemoHelper *helper = nil;

@implementation ChatDemoHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatDemoHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
#if DEMO_CALL == 1
    [[EMClient sharedClient].callManager removeDelegate:self];
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

- (void)initHelper
{
#ifdef REDPACKET_AVALABLE
    [[RedPacketUserConfig sharedConfig] beginObserveMessage];
#endif
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
#if DEMO_CALL == 1
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
#endif
}

- (void)asyncPushOptions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    });
}

- (void)asyncGroupFromServer
{
     [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
    
   // __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient].groupManager getJoinedGroups];
        EMError *error = nil;
        [[EMClient sharedClient].groupManager getMyGroupsFromServerWithError:&error];
        if (!error) {
            //            if (weakself.contactViewVC) {
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    [weakself.contactViewVC reloadGroupView];
            //                });
            //            }
        }
    });
    
   
  
}

- (void)asyncConversationFromDB
{
    //  [[ContactsManager sharedContactsManager] getAllConversationCompletionBlock:nil];
    [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
    
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            //            if (weakself.conversationListVC) {
            //                [weakself.conversationListVC refreshDataSource];
            //            }
            //
            //            if (weakself.mainVC) {
            //                [weakself.mainVC setupUnreadMessageCount];
            //            }
        });
    });
}

#pragma mark - EMClientDelegate

//网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
   //  [self.mainVC networkChanged:connectionState];
}

- (void)didAutoLoginWithError:(EMError *)error
{
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
    } else if([[EMClient sharedClient] isConnected]){
        // UIView *view = self.mainVC.view;
        //[MBProgressHUD showHUDAddedTo:view animated:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            BOOL flag = [[EMClient sharedClient] migrateDatabaseToLatestSDK];
            if (flag) {
                [self asyncGroupFromServer];
                [self asyncConversationFromDB];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //     [MBProgressHUD hideAllHUDsForView:view animated:YES];
            });
        });
    }
}

- (void)didLoginFromOtherDevice
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"提示") message:NSLocalizedString(@"你的账号在异地登录", @"你的账号在异地登录") delegate:self cancelButtonTitle:NSLocalizedString(@"确定", @"确定") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC closeLeftView];
    SSEBaseUser *user = [[Config Instance] getThirtyPartyUserInfo];
    if (user) {  //第三方登录的退出
        BOOL isLogout = [SSEThirdPartyLoginHelper logout:user];
        if (isLogout) {
            NSLog(@"退出第三方登录成功");
        }
    }
    
  //  [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutLocation" object:nil];
    
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    
    [[Config Instance] clearUserData];
    
    
    
    
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

   //[[NSNotificationCenter defaultCenter] postNotificationName:LOGOUT object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutLocation" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMLOGOUT object:nil];
   
}



- (void)didRemovedFromServer
{
    [self _clearHelper];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didServersChanged
{
   [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
   [self _clearHelper];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - EMChatManagerDelegate

- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    //    if (self.mainVC) {
    //        [_mainVC setupUnreadMessageCount];
    //    }
    //
    //    if (self.conversationListVC) {
    //        [_conversationListVC refreshDataSource];
    //    }
    
    [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
  //  [[ContactsManager sharedContactsManager] getAllConversationCompletionBlock:nil];
     [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
}


- (void)didReceiveMessages:(NSArray *)aMessages
{
    BOOL isRefreshCons = YES;
   // [self.mainVC setRedPointView];
   
    for(EMMessage *message in aMessages){
     
     //   [self showWith:message];
        
        NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
        NSString * converId = [user objectForKey:message.conversationId];
       
        if(message.chatType == EMChatTypeChat){
            
            self.mainVC.midImage.image = [UIImage imageNamed:@"red_point"];
//            if([message.conversationId isEqualToString:converId]){
//                NSLog(@"+++%@",message.conversationId);
//            }
//            else{
//                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//                switch (state) {
//                    case UIApplicationStateActive:
//                        [self.mainVC playSoundAndVibration];
//                        break;
//                    case UIApplicationStateInactive:
//                        [self.mainVC playSoundAndVibration];
//                        break;
//                    case UIApplicationStateBackground:
//                        //[self.mainVC showNotificationWithMessage:message];
//                        [self showWith:message];
//
//                        break;
//                    default:
//                        break;
//                }
//                
//            }
            
            
            
            
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                switch (state) {
                case UIApplicationStateActive:
                        if([message.conversationId isEqualToString:converId]){
                           
                        }
                        else{
                            [self.mainVC playSoundAndVibration];
                        }
                                    break;
                case UIApplicationStateInactive:
                        if([message.conversationId isEqualToString:converId]){
                          
                        }
                        else{
                            [self.mainVC playSoundAndVibration];
                        }
                        
                                    break;
                case UIApplicationStateBackground:
                                    //[self.mainVC showNotificationWithMessage:message];
                    [self showWith:message];
                       // [self.mainVC showWith:message];
            
                    break;
                    default:
                    break;
            }
                            
            

        }
        else {
            self.mainVC.leftImage.image = [UIImage imageNamed:@"red_point"];
            BOOL needShowNotification = [self _needShowNotification:message.conversationId];
            
            if(needShowNotification){
                UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                switch (state) {
                    case UIApplicationStateActive:
                        [self.mainVC playSoundAndVibration];
                        break;
                    case UIApplicationStateInactive:
                        [self.mainVC playSoundAndVibration];
                        break;
                    case UIApplicationStateBackground:
                       // [self.mainVC showNotificationWithMessage:message];
                        
                       // [self.mainVC showWith:message];
                        [self showWith:message];
                        
                         

                        break;
                    default:
                        break;
                }
            
            }
        }

    //    for(EMMessage *message in aMessages){
    //        BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
    //
    //#ifdef REDPACKET_AVALABLE
    //        /**
    //         *  屏蔽红包被抢消息的提示
    //         */
    //        NSDictionary *dict = message.ext;
    //        needShowNotification = (dict && [dict valueForKey:RedpacketKeyRedpacketTakenMessageSign]) ? NO : needShowNotification;
    //#endif
    //
    //        if (needShowNotification) {
    //#if !TARGET_IPHONE_SIMULATOR
    //            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    //            switch (state) {
    //                case UIApplicationStateActive:
    //                    [self.mainVC playSoundAndVibration];
    //                    break;
    //                case UIApplicationStateInactive:
    //                    [self.mainVC playSoundAndVibration];
    //                    break;
    //                case UIApplicationStateBackground:
    //                    [self.mainVC showNotificationWithMessage:message];
    //                    break;
    //                default:
    //                    break;
    //            }
    //#endif
    //        }
        
    [_mainVC setupUnreadMessageCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:self];
        
        [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
        [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
        
    
    //  [_groupMsgVC refresh];
    
    //        if (_chatVC == nil) {
    //            _chatVC = [self _getCurrentChatView];
    //        }
    //        BOOL isChatting = NO;
    //        if (_chatVC) {
    //            isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
    //        }
    //        if (_chatVC == nil || !isChatting) {
    //            [self _handleReceivedAtMessage:message];
    //
    //            if (self.conversationListVC) {
    //                [_conversationListVC refresh];
    //            }
    //
    //            if (self.mainVC) {
    //                [_mainVC setupUnreadMessageCount];
    //            }
    //            return;
    //        }
    //
    //        if (isChatting) {
    //            isRefreshCons = NO;
    //        }
    //    }
    //
    //    if (isRefreshCons) {
    //        if (self.conversationListVC) {
    //            [_conversationListVC refresh];
    //        }
    //
    //        if (self.mainVC) {
    //            [_mainVC setupUnreadMessageCount];
    //        }
    //    }
}
}



-(void)showWith:(EMMessage*)message
{
    EMPushOptions* options = [[EMClient sharedClient] pushOptions];
                UIApplication * application=[UIApplication sharedApplication];
                            //如果当前应用程序没有注册本地通知，需要注册
    if([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
        
        
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            
            UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [application registerUserNotificationSettings:setting];

         
        }

    }
    else{
        
        if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
            //设置提示支持的提示方式
        
            UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [application registerUserNotificationSettings:setting];
        }
 

    }
    //删除之前的重复通知
   // [application cancelAllLocalNotifications];
                            //添加本地通知
    NSDate * date=[NSDate dateWithTimeIntervalSinceNow:1];
                          //  [ self LocalNotificationSleep :date];
    
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    //设置开始时间
    noti.fireDate=date;
     NSString* messageStr = nil;
 //   if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody* messageBody = message.body;
       
        switch (messageBody.type) {
            case EMMessageBodyTypeText: {
               
                messageStr = ((EMTextMessageBody*)messageBody).text;
            } break;
            case EMMessageBodyTypeImage: {
                messageStr = @"发来一张图片";
                //NSLocalizedString(@"message.image", @"Image");
            } break;
            case EMMessageBodyTypeLocation: {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            } break;
            case EMMessageBodyTypeVoice: {
                messageStr = @"发来一条语音";
                //NSLocalizedString(@"message.voice", @"Voice");
            } break;
            case EMMessageBodyTypeVideo: {
                messageStr = NSLocalizedString(@"message.video", @"Video");
            } break;
            default:
                break;
        }
   // }
    
    NSLog(@"+++ %@",messageStr);
    //设置body
    noti.alertBody= [NSString stringWithFormat:@"%@: %@",message.ext[@"nickName"],messageStr];
    //设置action
    noti.alertAction=@"解锁";
    noti.hasAction = NO;
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * converId = [user objectForKey:message.conversationId];
    
    
    if([message.conversationId isEqualToString:converId]){
        
    }
    else{
        noti.soundName = UILocalNotificationDefaultSoundName;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:@"MessageType"];
        [userInfo setObject:message.conversationId forKey:@"ConversationChatter"];
    NSString * title;
    if(message.chatType == EMConversationTypeGroupChat){
         ZSMessageGroupModel* group = [[GroupsManager sharedGroupsManager] groupModelByGroupId:message.conversationId];
         if (group) {
        
           title = group.GP_NAME;
         
          }
         else{
            title = @"群聊";
         }
    }
    else{
        NSString * str = message.ext[@"nickName"];
        if(str!=nil && str.length>0 ){
            title =str;
        }
        else{
            title = @"单聊";
        }
        
    }
        [userInfo setObject:title forKey:@"notiNickName"];
  

        noti.userInfo = userInfo;
    //注册通知
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
  //  UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
    
}



#pragma mark - 添加本地通知
//- (void) LocalNotificationSleep:(NSDate *) date {
//   
//}


#pragma mark - EMGroupManagerDelegate

- (void)didReceiveLeavedGroup:(EMGroup *)aGroup
                       reason:(EMGroupLeaveReason)aReason
{
    NSString *str = nil;
    if (aReason == EMGroupLeaveReasonBeRemoved) {
        str = [NSString stringWithFormat:@"你已从群:%@移除", aGroup.subject];
    } else if (aReason == EMGroupLeaveReasonDestroyed) {
        str = [NSString stringWithFormat:@"群:%@已被解散", aGroup.subject];
    }
    
    
    if (str.length > 0) {
        //  TTAlertNoTitle(str);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:str
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    //    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainVC.navigationController.viewControllers];
    //    ChatViewController *chatViewContrller = nil;
    //    for (id viewController in viewControllers)
    //    {
    //        if ([viewController isKindOfClass:[ChatViewController class]] && [aGroup.groupId isEqualToString:[(ChatViewController *)viewController conversation].conversationId])
    //        {
    //            chatViewContrller = viewController;
    //            break;
    //        }
    //    }
    //    if (chatViewContrller)
    //    {
    //        [viewControllers removeObject:chatViewContrller];
    //        if ([viewControllers count] > 0) {
    //            [_mainVC.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
    //        } else {
    //            [_mainVC.navigationController setViewControllers:viewControllers animated:YES];
    //        }
    //    }
}

- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason
{
    if (!aGroup || !aApplicant) {
        return;
    }
    
    if (!aReason || aReason.length == 0) {
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoin", @"%@ apply to join groups\'%@\'"), aApplicant, aGroup.subject];
    }
    else{
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.applyJoinWithName", @"%@ apply to join groups\'%@\'：%@"), aApplicant, aGroup.subject, aReason];
    }
    
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroup.subject, @"groupId":aGroup.groupId, @"username":aApplicant, @"groupname":aGroup.subject, @"applyMessage":aReason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
    //    [[ApplyViewController shareController] addNewApply:dic];
    //    if (self.mainVC) {
    //        [self.mainVC setupUntreatedApplyCount];
    //#if !TARGET_IPHONE_SIMULATOR
    //        [self.mainVC playSoundAndVibration];
    //#endif
    //    }
    //
    //    if (self.contactViewVC) {
    //        [self.contactViewVC reloadApplyView];
    //    }
}

- (void)didJoinedGroup:(EMGroup *)aGroup
               inviter:(NSString *)aInviter
               message:(NSString *)aMessage
{
    if(![aInviter isEqualToString:gUserID]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"提示") message:[NSString stringWithFormat:@"你已加入群: %@",aGroup.subject] delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", @"确定") otherButtonTitles:nil, nil];
        [alertView show];
    }

}

- (void)didReceiveDeclinedJoinGroup:(NSString *)aGroupId
                             reason:(NSString *)aReason
{
    if (!aReason || aReason.length == 0) {
        aReason = [NSString stringWithFormat:NSLocalizedString(@"group.beRefusedToJoin", @"be refused to join the group\'%@\'"), aGroupId];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:aReason delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), aGroup.subject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage
{
    if (!aGroupId || !aInviter) {
        return;
    }
    
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":@"", @"groupId":aGroupId, @"username":aInviter, @"groupname":@"", @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];
    //    [[ApplyViewController shareController] addNewApply:dic];
    //    if (self.mainVC) {
    //        [self.mainVC setupUntreatedApplyCount];
    //#if !TARGET_IPHONE_SIMULATOR
    //        [self.mainVC playSoundAndVibration];
    //#endif
    //    }
    //
    //    if (self.contactViewVC) {
    //        [self.contactViewVC reloadApplyView];
    //    }
}

#pragma mark - EMContactManagerDelegate
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
   // [alertView show];
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    NSString *msgstr = [NSString stringWithFormat:@"%@拒绝了加好友申请", aUsername];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  //  [alertView show];
}

- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    //    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainVC.navigationController.viewControllers];
    //    ChatViewController *chatViewContrller = nil;
    //    for (id viewController in viewControllers)
    //    {
    //        if ([viewController isKindOfClass:[ChatViewController class]] && [aUsername isEqualToString:[(ChatViewController *)viewController conversation].conversationId])
    //        {
    //            chatViewContrller = viewController;
    //            break;
    //        }
    //    }
    //    if (chatViewContrller)
    //    {
    //        [viewControllers removeObject:chatViewContrller];
    //        if ([viewControllers count] > 0) {
    //            [_mainVC.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
    //        } else {
    //            [_mainVC.navigationController setViewControllers:viewControllers animated:YES];
    //        }
    //    }
    //    [_mainVC showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), aUsername]];
    //    [_contactViewVC reloadDataSource];
}

- (void)didReceiveAddedFromUsername:(NSString *)aUsername
{
    //[_contactViewVC reloadDataSource];
}

- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    if (!aUsername) {
        return;
    }
    
//    if (!aMessage) {
//        aMessage = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
//    }
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
//        [[ApplyViewController shareController] addNewApply:dic];
//        if (self.mainVC) {
//            [self.mainVC setupUntreatedApplyCount];
//    #if !TARGET_IPHONE_SIMULATOR
//            [self.mainVC playSoundAndVibration];
//    
//            BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
//            if (!isAppActivity) {
//                //发送本地推送
//                UILocalNotification *notification = [[UILocalNotification alloc] init];
//                notification.fireDate = [NSDate date]; //触发通知的时间
//                notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
//                notification.alertAction = NSLocalizedString(@"open", @"Open");
//                notification.timeZone = [NSTimeZone defaultTimeZone];
//            }
//    #endif
//        }
//        [_contactViewVC reloadApplyView];
}

#pragma mark - EMChatroomManagerDelegate

- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom
                            username:(NSString *)aUsername
{
    
}

- (void)didReceiveKickedFromChatroom:(EMChatroom *)aChatroom
                              reason:(EMChatroomBeKickedReason)aReason
{
    
}

#pragma mark - EMCallManagerDelegate

#if DEMO_CALL == 1

- (void)didReceiveCallIncoming:(EMCallSession *)aSession
{
    if(_callSession && _callSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonBusy];
    }
    
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    _callSession = aSession;
    if(_callSession){
        [self _startCallTimer];
        
        _callController = [[CallViewController alloc] initWithSession:_callSession isCaller:NO status:NSLocalizedString(@"call.finished", "Establish call finished")];
        _callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [_mainVC presentViewController:_callController animated:NO completion:nil];
    }
}

- (void)didReceiveCallConnected:(EMCallSession *)aSession
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        _callController.statusLabel.text = NSLocalizedString(@"call.finished", "Establish call finished");
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
}

- (void)didReceiveCallAccepted:(EMCallSession *)aSession
{
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonFailed];
    }
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self _stopCallTimer];
        
        NSString *connectStr = aSession.connectType == EMCallConnectTypeRelay ? @"Relay" : @"Direct";
        _callController.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
        _callController.timeLabel.hidden = NO;
        [_callController startTimer];
        [_callController startShowInfo];
        _callController.cancelButton.hidden = NO;
        _callController.rejectButton.hidden = YES;
        _callController.answerButton.hidden = YES;
    }
}

- (void)didReceiveCallTerminated:(EMCallSession *)aSession
                          reason:(EMCallEndReason)aReason
                           error:(EMError *)aError
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [self _stopCallTimer];
        
        _callSession = nil;
        
        [_callController close];
        _callController = nil;
        
        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"call.noResponse", @"NO response");
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    reasonStr = NSLocalizedString(@"call.rejected", @"Reject the call");
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"call.in", @"In the call...");
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"call.connectFailed", @"Connect failed");
                }
                    break;
                default:
                    break;
            }
            
            if (aError) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
    }
}

- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession status:(EMCallNetworkStatus)aStatus
{
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        [_callController setNetwork:aStatus];
    }
}

#endif

#pragma mark - public

#if DEMO_CALL == 1

- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] isVideo:[[notify.object objectForKey:@"type"] boolValue]];
    }
}

- (void)_startCallTimer
{
    _callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_cancelCall) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (_callTimer == nil) {
        return;
    }
    
    [_callTimer invalidate];
    _callTimer = nil;
}

- (void)_cancelCall
{
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.autoHangup", @"No response and Hang up") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo
{
    if ([aUsername length] == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
        ChatDemoHelper *strongSelf = weakSelf;
        if (strongSelf) {
            if (!aError && aCallSession) {
                strongSelf.callSession = aCallSession;
                [strongSelf _startCallTimer];
                strongSelf.callController = [[CallViewController alloc] initWithSession:self.callSession isCaller:YES status:NSLocalizedString(@"call.connecting", @"Connecting...")];
                [strongSelf.mainVC presentViewController:self.callController animated:NO completion:nil];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.initFailed", @"Failed to establish the call") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else {
            [[EMClient sharedClient].callManager endCall:aCallSession.sessionId reason:EMCallEndReasonNoResponse];
        }
    };
    if (aIsVideo) {
        [[EMClient sharedClient].callManager startVideoCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            completionBlock(aCallSession, aError);
        }];
    }
    else {
        [[EMClient sharedClient].callManager startVoiceCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            completionBlock(aCallSession, aError);
        }];
    }
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    if (_callSession) {
        [[EMClient sharedClient].callManager endCall:_callSession.sessionId reason:aReason];
    }
    
    _callSession = nil;
    [_callController close];
    _callController = nil;
}

- (void)answerCall
{
    if (_callSession) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:self.callSession.sessionId];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.code == EMErrorNetworkUnavailable) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                        [alertView show];
                    }
                    else{
                        [self hangupCallWithReason:EMCallEndReasonFailed];
                    }
                });
            }
        });
    }
}

#endif

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

//- (ChatViewController*)_getCurrentChatView
//{
//    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:_mainVC.navigationController.viewControllers];
//    ChatViewController *chatViewContrller = nil;
//    for (id viewController in viewControllers)
//    {
//        if ([viewController isKindOfClass:[ChatViewController class]])
//        {
//            chatViewContrller = viewController;
//            break;
//        }
//    }
//    return chatViewContrller;
//}
    
    - (void)_clearHelper
    {
        //    self.mainVC = nil;
        //    self.conversationListVC = nil;
        //    self.chatVC = nil;
        //    self.contactViewVC = nil;
        
        [[EMClient sharedClient] logout:NO];
        
#if DEMO_CALL == 1
        [self hangupCallWithReason:EMCallEndReasonFailed];
#endif
    }

- (void)_handleReceivedAtMessage:(EMMessage*)aMessage
{
    if (aMessage.chatType != EMChatTypeGroupChat || aMessage.direction != EMMessageDirectionReceive) {
        return;
    }
    
    NSString *loginUser = [EMClient sharedClient].currentUsername;
    NSDictionary *ext = aMessage.ext;
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:aMessage.conversationId type:EMConversationTypeGroupChat createIfNotExist:NO];
    if (loginUser && conversation && ext && [ext objectForKey:kGroupMessageAtList]) {
        id target = [ext objectForKey:kGroupMessageAtList];
        if ([target isKindOfClass:[NSString class]] && [(NSString*)target compare:kGroupMessageAtAll options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            NSNumber *atAll = conversation.ext[kHaveUnreadAtMessage];
            if ([atAll intValue] != kAtAllMessage) {
                NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                [conversationExt removeObjectForKey:kHaveUnreadAtMessage];
                [conversationExt setObject:@kAtAllMessage forKey:kHaveUnreadAtMessage];
                conversation.ext = conversationExt;
            }
        }
        else if ([target isKindOfClass:[NSArray class]]) {
            if ([target containsObject:loginUser]) {
                if (conversation.ext[kHaveUnreadAtMessage] == nil) {
                    NSMutableDictionary *conversationExt = conversation.ext ? [conversation.ext mutableCopy] : [NSMutableDictionary dictionary];
                    [conversationExt setObject:@kAtYouMessage forKey:kHaveUnreadAtMessage];
                    conversation.ext = conversationExt;
                }
            }
        }
    }
}



@end


