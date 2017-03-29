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
//聊天界面

#import "ChatViewController.h"
#import "UserProfileManager.h"
#import "ChatDemoHelper.h"
#import "PersonalSetViewController.h"
#import "ZSButton.h"
#import "GroupSetViewController.h"
#import "IndividualHomepageController.h"

extern NSString *gIMAvatarHost;

@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property (nonatomic, strong) UIImageView* operationBg;
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    [self.view addGestureRecognizer:tap];
    _dataArr = [[NSMutableArray alloc]init];
    
    //[self _setupBarButtonItem];
   
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"sender_chat"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receive"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[ [UIImage imageNamed:@"send_voice_1"], [UIImage imageNamed:@"send_voice_2"], [UIImage imageNamed:@"send_voice_3"] ]];
    
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[ [UIImage imageNamed:@"receive_voice_1"], [UIImage imageNamed:@"receive_voice_2"], [UIImage imageNamed:@"receive_voice_3"] ]];
    
    [[EaseBaseMessageCell appearance] setAvatarSize:40.f];
    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:20.f];
    
    [[EaseChatBarMoreView appearance] setMoreViewBackgroundColor:[UIColor colorWithRed:240 / 255.0 green:242 / 255.0 blue:247 / 255.0 alpha:1.0]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
   
//    if(self.conversation.type == EMConversationTypeChat){
//        IMRequest * request = [[IMRequest alloc]init];
//        [request requestWhetherShielding:_ID gp_id:@"" block:^(ZSIsFriendOrShieldModel *model, NSError *error) {
//            if(model.isSuccess){
//                ZSIsFriendModel * zsModel = model.data;
//                if(!zsModel.FRIEND_STATUS){
//                    [self createBtn:NO];
//                    if(self.isFromSpecifcPage){
//                        NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:self.conversation.ext];
//                        ext[@"nickName"] = _nickName;
//                        ext[@"userAvatar"] = _avatar;
//                        self.conversation.ext  = ext;
//                        [self.conversation updateConversationExtToDB];
//                    }
//                    else{
//                       
//                    }
//                    
//                }
//                else{
//                    [self createBtn:YES];
//                }
//            }
//            else{
//                [self createBtn:YES];
//            }
//        }];
//
//}
//    else{
        [self createSetBtn];
 //   }
}

- (void)viewWillAppear:(BOOL)animated
{
   
    
    
    [super viewWillAppear:animated];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
//    if (self.conversation.type == EMConversationTypeGroupChat) {
//        if ([[self.conversation.ext objectForKey:@"subject"] length]) {
//            self.title = [self.conversation.ext objectForKey:@"subject"];
//        }
//    }
    
    if(self.conversation.type == EMConversationTypeGroupChat){
        [self fetchData];
    }
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
    
    
}

-(void)fetchData
{
    [_dataArr removeAllObjects];
    IMRequest * request = [[IMRequest alloc]init];
    [request requestGroupMember:_ID block:^(ZSMessageGroupMemberListModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [_dataArr addObjectsFromArray:model.data];
        }
        else{
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}


#pragma mark - setup subviews

-(void)createBtn:(BOOL)isFriend{
    if(isFriend){
       UIImage*  image = [UIImage imageNamed:@"personal_set"];
        UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
        addItem.tag = 0;
        [self.navigationItem setRightBarButtonItem:addItem];
    }else{
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"加为好友" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1.0f;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        [btn addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, 45, 23);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        
    }
}

-(void)uploadClick
{
    [self showHudInView:self.view hint:@"正在发送申请..."];
    IMRequest * request = [[IMRequest alloc]init];
    [request requestDealFriend:_ID status:@"0" block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
        }
        else {
            [self showHint:model.message];
        }
    }];

}

- (void)createSetBtn
{
    UIImage* image;
    NSInteger tag = 123;
    if (self.conversation.type == EMConversationTypeChat) {
        image = [UIImage imageNamed:@"personal_set"];
        tag = 0;
    }
    else if (self.conversation.type == EMConversationTypeGroupChat) {
        image = [UIImage imageNamed:@"group_set"];
        tag = 1;
    }
    else {
    }
    UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(addAction:)];
    
    addItem.tag = tag;
    [self.navigationItem setRightBarButtonItem:addItem];
}


//设置
- (void)addAction:(UIButton*)sender
{
    UIButton* btn = (UIButton*)sender;
    if (btn.tag == 0) {
        PersonalSetViewController* view = [[PersonalSetViewController alloc] init];

        view.accountStr = _ID;
        [self.navigationController pushViewController:view animated:YES];
    }
    else {
        GroupSetViewController* view = [[GroupSetViewController alloc] init];
        view.accountStr = _ID;

        [self.navigationController pushViewController:view animated:YES];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        //[self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
        
        [self _showMenuViewController:cell.bubbleView contentView:cell.contentView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
 //   if(!messageModel.isSender){
        if (self.conversation.type == EMConversationTypeGroupChat) {
    
            
            EMMessage * model = messageModel.message;
            IndividualHomepageController * view = [[IndividualHomepageController alloc]init];
          
            view.userID = model.ext[@"groupUserId"];
            view.nickName = model.ext[@"nickName"];
            [self.navigationController pushViewController:view animated:YES];

        }
        else{
            EMMessage * model = messageModel.message;
            IndividualHomepageController * view = [[IndividualHomepageController alloc]init];

           view.userID = model.ext[@"groupUserId"];
            view.nickName = model.ext[@"nickName"];
            [self.navigationController pushViewController:view animated:YES];
            
            //个人主页
            
        }
 //   }
}


//发送图片
- (void)sendImageMessageWithData:(NSData *)imageData
{
    
    id progress = nil;
    progress = self;
    NSDictionary * ext = [[NSDictionary alloc]init];
   //  ext = @{@"nickName":gUserName,@"userAvatar":gUserPic};
  //  NSString * str = gUserPic;
    NSString * picUrl = [gUserPic stringToUserPic];
    if(self.conversation.type == EMConversationTypeChat){
        ext = @{@"nickName":gUserNickname,@"userAvatar":picUrl,@"groupUserId":gUserID};
    }
    else{
        for(int i = 0;i<_dataArr.count;i++){
            ZSMessageGroupMemberModel * model = _dataArr[i];
            if([model.USER_ID isEqualToString:gUserID]){
                NSString * nick = nil;
                if(model.GM_CARD.length == 0){
                    nick = model.USER_SHORTNAME;
                }
                else{
                    nick = model.GM_CARD;
                }
               
                ext = @{@"nickName":nick,@"userAvatar":picUrl,@"groupUserId":model.USER_ID};
            }
        }
        
    }
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImageData:imageData
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:ext];
    [self _sendMessage:message];
    
}

//发送拍照图片
- (void)sendImageMessage:(UIImage *)image
{
    id progress = nil;
    progress = self;
    
    NSDictionary * ext = [[NSDictionary alloc]init];
    //  ext = @{@"nickName":gUserName,@"userAvatar":gUserPic};
    
    
    NSString * picUrl = [gUserPic stringToUserPic];
    
    if(self.conversation.type == EMConversationTypeChat){
        ext = @{@"nickName":gUserNickname,@"userAvatar":picUrl,@"groupUserId":gUserID};
    }
    else{
        for(int i = 0;i<_dataArr.count;i++){
            ZSMessageGroupMemberModel * model = _dataArr[i];
            
            if([model.USER_ID isEqualToString:gUserID]){
                NSString * nick = nil;
                if(model.GM_CARD.length == 0){
                    nick = model.USER_SHORTNAME;
                }
                else{
                    nick = model.GM_CARD;
                }
                ext = @{@"nickName":nick,@"userAvatar":picUrl,@"groupUserId":model.USER_ID};
            }
        }
        
    }
    
    EMMessage *message = [EaseSDKHelper sendImageMessageWithImage:image
                                                               to:self.conversation.conversationId
                                                      messageType:[self _messageTypeFromConversationType]
                                                       messageExt:ext];
    [self _sendMessage:message];
}


//发送文字
- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
  
    NSDictionary * groupExt = [[NSDictionary alloc]init];
    
     NSString * picUrl = [gUserPic stringToUserPic];
    if(self.conversation.type == EMConversationTypeChat){
    
        groupExt = @{@"nickName":gUserNickname,@"userAvatar":picUrl,@"groupUserId":gUserID};
    }
    else{
        for(int i = 0;i<_dataArr.count;i++){
   
            ZSMessageGroupMemberModel * model = _dataArr[i];
            if([model.USER_ID isEqualToString:gUserID]){
                NSString * nick = nil;
                if(model.GM_CARD.length == 0){
                    nick = model.USER_SHORTNAME;
                }
                else{
                    nick = model.GM_CARD;
                }
               
                groupExt = @{@"nickName":nick,@"userAvatar":picUrl,@"groupUserId":model.USER_ID};
            }
        }
        
    }
    
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:self.conversation.conversationId
                                            messageType:[self _messageTypeFromConversationType]
                                             messageExt:groupExt];
    
    [self _sendMessage:message];
}

//发送语音
- (void)sendVoiceMessageWithLocalPath:(NSString *)localPath
                             duration:(NSInteger)duration
{
    id progress = nil;
    progress = self;
    
    NSDictionary * ext = [[NSDictionary alloc]init];
  //  ext = @{@"nickName":gUserName,@"userAvatar":gUserPic};
    
    
      NSString * picUrl = [gUserPic stringToUserPic];
    if(self.conversation.type == EMConversationTypeChat){
        ext = @{@"nickName":gUserNickname,@"userAvatar":picUrl,@"groupUserId":gUserID};
    }
    else{
        for(int i = 0;i<_dataArr.count;i++){
            ZSMessageGroupMemberModel * model = _dataArr[i];
            
            if([model.USER_ID isEqualToString:gUserID]){
                NSString * nick = nil;
                if(model.GM_CARD.length == 0){
                    nick = model.USER_SHORTNAME;
                }
                else{
                    nick = model.GM_CARD;
                }
                ext = @{@"nickName":nick,@"userAvatar":picUrl,@"groupUserId":model.USER_ID};
            }
        }
        
    }
    
    EMMessage *message = [EaseSDKHelper sendVoiceMessageWithLocalPath:localPath
                                                             duration:duration
                                                                   to:self.conversation.conversationId
                                                          messageType:[self _messageTypeFromConversationType]
                                                           messageExt:ext];
    [self _sendMessage:message];
}

- (EMChatType)_messageTypeFromConversationType
{
    EMChatType type = EMChatTypeChat;
    switch (self.conversation.type) {
        case EMConversationTypeChat:
            type = EMChatTypeChat;
            break;
        case EMConversationTypeGroupChat:
            type = EMChatTypeGroupChat;
            break;
        case EMConversationTypeChatRoom:
            type = EMChatTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - send message

- (void)_sendMessage:(EMMessage*)message
{
    if (self.conversation.type == EMConversationTypeGroupChat) {
        message.chatType = EMChatTypeGroupChat;
    }
    else if (self.conversation.type == EMConversationTypeChatRoom) {
        message.chatType = EMChatTypeChatRoom;
    }
    
    [self addMessageToDataSource:message
                        progress:nil];
    
    __weak typeof(self) weakself = self;
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage* aMessage, EMError* aError) {
//        if(_isFriend){
//            [UIView animateWithDuration:0.0f animations:^{
//                self.tableView.frame = CGRectMake(0,43,SCREEN_WIDTH, SCREEN_HEIGHT-43-64-self.chatToolbar.frame.size.height);
//            }];
//            _height = 43;
//        }
        [weakself.tableView reloadData];
        
    }];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:chatGroup.groupId includeMembersList:YES error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
//                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
//                            selectController.mulChoice = NO;
//                            selectController.delegate = self;
//                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
//            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
//            selectController.mulChoice = NO;
//            selectController.delegate = self;
//            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
//    id<IMessageModel> model = nil;
//    model = [[EaseMessageModel alloc] initWithMessage:message];
//    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
//    if (profileEntity) {
//        model.avatarURLPath = profileEntity.imageUrl;
//        model.nickname = profileEntity.nickname;
//         NSLog(@"+++%@",profileEntity.nickname);
//    }
//    
//    if(self.conversation.type == EMConversationTypeChat){
//        model.nickname = @"";
//    }
//    else{
//      
//      //  model.nickname = profileEntity.nickname;
//       // model.nickname = model.message.ext[@"nickName"];
//    }
//
//    model.failImageName = @"imageDownloadFail";
//    return model;
    
    
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    NSString * avatar = model.message.ext[@"userAvatar"];
    if(avatar.length>0){
        model.avatarURLPath =model.message.ext[@"userAvatar"];
        // model.avatarImage = KPlaceHeaderImage;
    }
    else{
        model.avatarImage = KPlaceHeaderImage;
    }
  
    if(self.conversation.type == EMConversationTypeChat){
        model.nickname = @"";
    }
    else{
        model.nickname = model.message.ext[@"nickName"];
    }
    
   // model.failImageName = @"imageDownloadFail";
    
    
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
   // [[ChatDemoHelper shareHelper] setChatVC:nil];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)showGroupDetailAction
//{
//    [self.view endEditing:YES];
//    if (self.conversation.type == EMConversationTypeGroupChat) {
//        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:self.conversation.conversationId];
//        [self.navigationController pushViewController:detailController animated:YES];
//    }
//    else if (self.conversation.type == EMConversationTypeChatRoom)
//    {
//        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
//        [self.navigationController pushViewController:detailController animated:YES];
//    }
//}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

//- (void)transpondMenuAction:(id)sender
//{
//    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
//        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
//        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
//        listViewController.messageModel = model;
//        [listViewController tableViewDidTriggerHeaderRefresh];
//        [self.navigationController pushViewController:listViewController animated:YES];
//    }
//    self.menuIndexPath = nil;
//}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}



#pragma mark - private

- (void)showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}


#pragma mark - EMChooseViewDelegate

//- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
//{
//    if ([selectedSources count]) {
//        EaseAtTarget *target = [[EaseAtTarget alloc] init];
//        target.userId = selectedSources.firstObject;
//        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:target.userId];
//        if (profileEntity) {
//            target.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
//        }
//        if (_selectedCallback) {
//            _selectedCallback(target);
//        }
//    }
//    else {
//        if (_selectedCallback) {
//            _selectedCallback(nil);
//        }
//    }
//    return YES;
//}
//
//- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController
//{
//    if (_selectedCallback) {
//        _selectedCallback(nil);
//    }
//}
//

#pragma mark - private
//创建复制删除操作视图
- (void)_showMenuViewController:(UIView*)showInView
                    contentView:(UIView*)contentView
                   andIndexPath:(NSIndexPath*)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (_operationBg) {
        [_operationBg removeFromSuperview];
    }
    
    _operationBg = [[UIImageView alloc] init];
    _operationBg.image = [UIImage imageNamed:@"operation_bg"];
    _operationBg.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = NO;
    [self.view addSubview:_operationBg];
    [_operationBg mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(showInView.mas_top).offset(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(140);
        make.left.equalTo(showInView.mas_left).offset(showInView.frame.size.width / 2 - 70);
    }];
    
    ZSButton* copyBtn = [[ZSButton alloc] initNormalButtonWithFrame:CGRectMake(0, 0, 70, 28) andTitlt:@"复制" andTapBlock:^(ZSButton* btn) {
        [self copyMenuAction];
        [_operationBg removeFromSuperview];
    }];
    
    [_operationBg addSubview:copyBtn];
    
    ZSButton* deleteBtn = [[ZSButton alloc] initNormalButtonWithFrame:CGRectMake(70, 0, 70, 28) andTitlt:@"删除" andTapBlock:^(ZSButton* btn) {
        [self deleteMenuAction];
        [_operationBg removeFromSuperview];
    }];
    
    [_operationBg addSubview:deleteBtn];
    
    if (messageType != EMMessageBodyTypeText) {
        [copyBtn setTitleColor:kLineStrong forState:UIControlStateNormal];
        copyBtn.enabled = NO;
    }
}


//复制消息
- (void)copyMenuAction
{
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
     self.tableView.userInteractionEnabled = YES;
}

//删除消息
- (void)deleteMenuAction
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet* indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray* indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
     self.tableView.userInteractionEnabled = YES;
}


//隐藏键盘和复制删除操作
- (void)tapToHide:(UITapGestureRecognizer*)tap{
    [_operationBg removeFromSuperview];
    [self.view endEditing:YES];
//    if(_isFriend){
//        [UIView animateWithDuration:0.0f animations:^{
//            self.tableView.frame = CGRectMake(0,43,SCREEN_WIDTH, SCREEN_HEIGHT-43-64-self.chatToolbar.frame.size.height);
//        }];
//        _height = 0;
//    }
    [self.tableView reloadData];
    self.tableView.userInteractionEnabled = YES;
}



@end
