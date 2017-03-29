//
//  MsgManageViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//消息管理

#import "MsgManageViewController.h"
#import "GroupMsgListViewController.h"
#import "ChatViewController.h"
#import "ContactListViewController.h"
#import "PersonalMsgViewController.h"
#import "GroupListViewController.h"

#import "HMSegmentedControl.h"

#import "UIViewController+LoadLoginView.h"
#import "SystemMessageViewController.h"
#import "ContactListViewController.h"
#import "UserProfileManager.h"
#import "SearchBuddyViewController.h"


//两次提示的默认间隔

static NSInteger loginNum = 0;
static const CGFloat kDefaultPlaySoundInterval = 3.0;

@interface MsgManageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,EMContactManagerDelegate>
{
    GroupMsgListViewController* _chatListVC;
    ContactListViewController* _contactsVC;
    PersonalMsgViewController * per;
}

@property (nonatomic, strong) HMSegmentedControl* segmentedControl; //菜单控件
@property (nonatomic, copy) NSArray* vcArray; //控件的数组
@property (nonatomic, strong) UIView* containerView;

@property (strong, nonatomic) UIViewController* p_displayingViewController;
@property (strong, nonatomic) UIPageViewController* pages;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) GroupMsgListViewController * groupVC;
@property (nonatomic, strong) PersonalMsgViewController * personalVC;
@property (nonatomic, strong) SystemMessageViewController * sysMsgVC;

@property (nonatomic,strong) NSArray * viewPages;
@property (strong, nonatomic) NSDate* lastPlaySoundDate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *seachBarBtn;


@end

@implementation MsgManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self createPagesView];
        self.navigationItem.title = [[[Tool getAppMenuName] componentsSeparatedByString:@","] lastObject];

    [self indirectLoginViewWithLoginSucessBlock:^{
        self.navigationController.navigationBarHidden = NO;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:YES];
    } andLogoutBlock:^{
        self.navigationController.navigationBarHidden = YES;
         [self createPagesView];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.LeftSlideVC setPanEnabled:NO];
    }];
    
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    //移除好友回调
    //[[EMClient sharedClient].contactManager removeDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
  //  [ChatDemoHelper shareHelper].contactViewVC = _contactsVC;
  //  [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;
    
    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    //    [self didUnreadMessagesCountChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self setupUnreadMessageCount];
   // [self setupUntreatedApplyCount];
    
//    
//    UIApplication *application = [UIApplication sharedApplication];
//    application.applicationIconBadgeNumber = 0;
//    
//    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
//    {
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
}


- (void)viewWillAppear:(BOOL)animated
{
 //   [self setRedPointView];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    if ([[Config Instance] isLogin]) {
        [app.LeftSlideVC setPanEnabled:YES];
    } else {
        [app.LeftSlideVC setPanEnabled:NO
         ];
    }
    SideslipSingle *side = [SideslipSingle sharedInstance];
    if (side.isSideslip) {
        [app.LeftSlideVC openLeftView];
        side.isSideslip = NO;
    }
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.LeftSlideVC setPanEnabled:NO];
}

#pragma mark---  创建消息红点通知View
-(void)setRedPointView
{
   
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    int a =0;
    int b = 0;
    for(int i=0;i<conversations.count;i++){
        EMConversation *conversation = conversations[i];
        if(conversation.type == EMConversationTypeChat ){
            if(conversation.unreadMessagesCount !=0){
                a++;
            }
        }
        else if(conversation.type == EMConversationTypeGroupChat){
            if(conversation.unreadMessagesCount !=0){
                b++;
            }
        }
    }

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = KMainBarGray;
    
    self.leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.24,5, 10, 10)];
    [view addSubview:self.leftImage];
    if(b>0){
        self.leftImage.hidden = NO;
       // self.leftImage.image = [UIImage imageNamed:@"red_point"];
    }
    else{
        //self.leftImage.hidden = YES;
        self.leftImage.image = [UIImage imageNamed:@""];
    }
    
    self.midImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.58,5, 10, 10)];
    [view addSubview:self.midImage];
    if(a>0){
        self.midImage.hidden = NO;
       // self.midImage.image = [UIImage imageNamed:@"red_point"];
    }
    else{
       // self.midImage.hidden = YES;
        self.midImage.image = [UIImage imageNamed:@""];
    }
    
    self.rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.91,5, 10, 10)];
    [view addSubview:self.rightImage];
   // self.rightImage.image = [UIImage imageNamed:@"red_point"];
    [self.view addSubview:view];
}

#pragma mark--- 创建ViewControllers
-(void)createPagesView
{
    
    [self setupTopView];
    
    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, 64.0 , SCREEN_WIDTH,SCREEN_HEIGHT-64.0 ) andTitles:@[@"群消息", @"个人消息",@"系统消息"] andTitleFontSize:14 andImages:nil andPageControllers:self.viewPages andSegmentColor:KMainBarGray];
    [self.view addSubview:pagesView];
   // , @"系统消息"

    
}

#pragma mark---  containerView
-(NSArray *)viewPages{
    if (!_viewPages) {
        
        self.groupVC = [[GroupMsgListViewController alloc] init];
        self.personalVC = [[PersonalMsgViewController alloc] init];
        self.sysMsgVC = [[SystemMessageViewController alloc] init];
        self.sysMsgVC.tableViewHeight = 150;
        _viewPages = @[ self.groupVC, self.personalVC,self.sysMsgVC];
        
    }
    return _viewPages;
}



#pragma mark---  导航栏左边按钮点击方法
- (IBAction)leftBtnClick:(id)sender {
//        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:@"s6" conversationType:EMConversationTypeChat];
//        chatController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:chatController animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

#pragma mark--- 导航栏右边按钮点击方法 通讯录
- (IBAction)rightBtnClick:(id)sender {
    
    if([gUsername isEqualToString:@"hy_px_demo"]){
        return [self showHint:@"访客账号不能查看联系人和群组!"];
    }
    ContactListViewController * vc = [[ContactListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didAcceptedByBuddy:(NSString*)username
{
    NSString* message = [NSString stringWithFormat:@"%@ 同意了你的好友请求", username];
    // 提示
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
    //[self presentViewController:alert animated:YES completion:nil];
}

- (void)didRejectedByBuddy:(NSString*)username
{
    NSString* message = [NSString stringWithFormat:@"%@ 拒绝了你的好友请求", username];
    
    // 提示
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"好友添加消息" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil]];
   // [self presentViewController:alert animated:YES completion:nil];
}

// 统计未读消息数
- (void)setupUnreadMessageCount
{
    NSArray* conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation* conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    //    if (unreadCount > 0) {
    //        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    //
    //    }else{
    //        self.navigationController.tabBarItem.badgeValue = nil;
    //    }
    
    UIApplication* application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//统计未处理的请求
//- (void)setupUntreatedApplyCount
//{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", (int)unreadCount];
//        }
//        else {
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
//}

//- (void)networkChanged:(EMConnectionState)connectionState
//{
//    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
//}

#pragma mark - 自动登录回调

- (void)willAutoReconnect
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSNumber* showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError*)error
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSNumber* showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }
        else {
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

- (void)playSoundAndVibration
{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}



- (void)showNotificationWithMessage:(EMMessage*)message
{
    _lastPlaySoundDate = [NSDate dateWithTimeIntervalSinceNow:3];
    EMPushOptions* options = [[EMClient sharedClient] pushOptions];
    //发送本地推送
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody* messageBody = message.body;
        NSString* messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText: {
                messageStr = ((EMTextMessageBody*)messageBody).text;
            } break;
            case EMMessageBodyTypeImage: {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            } break;
            case EMMessageBodyTypeLocation: {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            } break;
            case EMMessageBodyTypeVoice: {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            } break;
            case EMMessageBodyTypeVideo: {
                messageStr = NSLocalizedString(@"message.video", @"Video");
            } break;
            default:
                break;
        }
        
        NSString* title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.chatType == EMChatTypeGroupChat) {
            NSArray* groupArray = [[EMClient sharedClient].groupManager getAllGroups];
            for (EMGroup* group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationId]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                    break;
                }
            }
        }
        else if (message.chatType == EMChatTypeChatRoom) {
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            NSString* key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
            NSMutableDictionary* chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString* chatroomName = [chatrooms objectForKey:message.conversationId];
            if (chatroomName) {
                title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else {
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"你有一条新消息");
    }
    
    notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"消息", @"消息");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    }
    else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
//    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber += 1;
}



- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

//搜索好友和群组
- (IBAction)searchGroupAndFriend:(id)sender {
    if([gUsername isEqualToString:@"hy_px_demo"]){
        return [self showHint:@"访客账号不能搜索联系人和群组!"];
    }
    SearchBuddyViewController* view = [[SearchBuddyViewController alloc] init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}


-(void)setupTopView
{
    UIView *navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64.0)];
    navigationView.backgroundColor = kMainThemeColor;
    [self.view addSubview:navigationView];
    
    UIButton *headerSender = [[UIButton alloc]initWithFrame:CGRectMake(10.0, 30.0, 30.0, 30.0)];
    [headerSender setImage:[UIImage imageNamed:@"personal_hearImage"] forState:UIControlStateNormal];
    [headerSender setImage:[UIImage imageNamed:@"personal_hearImage"] forState:UIControlStateHighlighted];
    [headerSender addTarget:self action:@selector(personalClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:headerSender];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - 30.0, 34.0, 60.0, 20.0)];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:17.0f];
    titleLabel.text = [NSArray arrayWithArray:[[Tool getAppMenuName] componentsSeparatedByString:@","]][2];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:titleLabel];
    
    UIButton *searchSender = [[UIButton alloc]initWithFrame:CGRectMake(navigationView.width - 80.0, 30.0, 30.0, 30.0)];
    [searchSender setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchSender setImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
    [searchSender addTarget:self action:@selector(searchGroupFriend) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:searchSender];
    
    UIButton *scanSender = [[UIButton alloc]initWithFrame:CGRectMake(navigationView.width - 40.0, 30.0, 30.0, 30.0)];
    [scanSender setImage:[UIImage imageNamed:@"address_list"] forState:UIControlStateNormal];
    [scanSender setImage:[UIImage imageNamed:@"address_list"] forState:UIControlStateHighlighted];
    [scanSender addTarget:self action:@selector(searchGroup) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:scanSender];
}

- (void)personalClick
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


- (void)searchGroup
{
    if([gUsername isEqualToString:@"hy_px_demo"]){
        return [self showHint:@"访客账号不能查看联系人和群组!"];
    }
    ContactListViewController * vc = [[ContactListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)searchGroupFriend
{
    if([gUsername isEqualToString:@"hy_px_demo"]){
        return [self showHint:@"访客账号不能搜索联系人和群组!"];
    }
    SearchBuddyViewController* view = [[SearchBuddyViewController alloc] init];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
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
    NSDate * date=[NSDate dateWithTimeIntervalSinceNow:3];
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
    noti.alertAction=[NSString stringWithFormat:@"%@: %@",message.ext[@"nickName"],messageStr];
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    NSString * converId = [user objectForKey:message.conversationId];
    
    
    if([message.conversationId isEqualToString:converId]){
        
    }
    else{
        noti.soundName = UILocalNotificationDefaultSoundName;
    }
//    
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//    noti.userInfo = userInfo;
//    //注册通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
    
    
}
@end
