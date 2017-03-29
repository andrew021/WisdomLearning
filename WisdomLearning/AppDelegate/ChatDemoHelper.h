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


#import <Foundation/Foundation.h>
#import "GroupMsgListViewController.h"
#import "PersonalMsgViewController.h"
#import "MsgManageViewController.h"
//#import "ConversationListController.h"
//#import "ContactListViewController.h"
//#import "MainViewController.h"
//#import "ChatViewController.h"

#define kHaveUnreadAtMessage    @"kHaveAtMessage"
#define kAtYouMessage           1
#define kAtAllMessage           2

#if DEMO_CALL == 1

#import "CallViewController.h"

#import "HomeViewController.h"


@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate,EMCallManagerDelegate>

#else

@interface ChatDemoHelper : NSObject <EMClientDelegate,EMChatManagerDelegate,EMContactManagerDelegate,EMGroupManagerDelegate,EMChatroomManagerDelegate>

#endif

//@property (nonatomic, weak) ContactListViewController *contactViewVC;
//
//@property (nonatomic, weak) ConversationListController *conversationListVC;
//
//@property (nonatomic, weak) MainViewController *mainVC;
//
//@property (nonatomic, weak) ChatViewController *chatVC;

@property (nonatomic, weak) GroupMsgListViewController *groupMsgVC;

@property (nonatomic, weak) PersonalMsgViewController *rersonalMsgVC;

@property (nonatomic, weak) MsgManageViewController * mainVC;
@property (nonatomic,strong) HomeViewController * homeVC;

@property (nonatomic, strong) UIWindow *window;

#if DEMO_CALL == 1

@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;
@property (strong, nonatomic) UIView * view;

#endif

+ (instancetype)shareHelper;

- (void)asyncPushOptions;

- (void)asyncGroupFromServer;

- (void)asyncConversationFromDB;

#if DEMO_CALL == 1

- (void)makeCallWithUsername:(NSString *)aUsername
                     isVideo:(BOOL)aIsVideo;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall;

#endif

@end