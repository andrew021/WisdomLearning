//
//  HomeViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/9/30.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HomeViewController.h"
#import "StudyController.h"
#import "LXAlipayViewController.h"
#import "UserProfileManager.h"
#import "MyNavigationController.h"
#import "LoginController.h"
#import "FindsViewController.h"
#import "ChatViewController.h"

//两次提示的默认间隔
//static const CGFloat kDefaultPlaySoundInterval = 3.0;
//static NSString* kMessageType = @"MessageType";
//static NSString* kConversationChatter = @"ConversationChatter";
//static NSString* kGroupName = @"GroupName";
static NSInteger loginNum = 0;

static NSString* kMessageType = @"MessageType";
static NSString* kConversationChatter = @"ConversationChatter";
static NSString* kGroupName = @"GroupName";


@interface HomeViewController ()

@property (nonatomic, strong) StudyController *studyVC;
@property (nonatomic, strong) FindsViewController *findVC;
@property (nonatomic, strong) UIViewController *LearnCircleVC;
@property (nonatomic, strong) UIViewController *InformationVC;
@property (nonatomic, strong) LXAlipayViewController * lightApp;



@property (nonatomic,strong) NSArray * viewPages;
@property (strong, nonatomic) NSDate* lastPlaySoundDate;

@property (nonatomic, strong) NSArray *menuNameArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuNameArray = [NSArray arrayWithArray:[[Tool getAppMenuName] componentsSeparatedByString:@","]];
    
    //self.viewControllers = @[ self.studyVC, self.findVC, self.LearnCircleVC, self.InformationVC ,nav_homeVC];
    
    self.viewControllers = @[self.findVC, self.studyVC, self.InformationVC];
    self.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toIMLogin)
                                                 name:IMLOGOUT
                                               object:nil];
    
}

-(void)toIMLogin
{
    LoginController * login = [[LoginController alloc]init];
    login.isBack = YES;
    [self.navigationController presentViewController:login animated:YES completion:nil];
  
}


+(void)initialize
{
    UITabBar* tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBarTintColor:KMainBarGray];
    [tabBarAppearance setTintColor:kMainThemeColor];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter And Setter
- (UIViewController *)studyVC
{
    if (!_studyVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Study" bundle:[NSBundle mainBundle]];
        _studyVC = [storyboard instantiateInitialViewController];
        
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:[_menuNameArray objectAtIndex:1] image:[UIImage imageNamed:@"study_normal"] selectedImage:[UIImage imageNamed:@"study_select"]];
        _studyVC.tabBarItem = item;
    }
    return _studyVC;
}

- (UIViewController *)lightApp
{
    if (!_lightApp) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:[NSBundle mainBundle]];
        _lightApp = [storyboard instantiateInitialViewController];
        
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"discover_normal"] selectedImage:[UIImage imageNamed:@"discover_select"]];
        _lightApp.tabBarItem = item;
    }
    return _lightApp;
}

- (UIViewController *)findVC
{
    if (!_findVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Find" bundle:[NSBundle mainBundle]];
        _findVC = [storyboard instantiateInitialViewController];
//        _findVC =  [[UIStoryboard storyboardWithName:@"Find" bundle:nil] instantiateViewControllerWithIdentifier:@"findsVC"];
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:[_menuNameArray firstObject] image:[UIImage imageNamed:@"homepage_normal"] selectedImage:[UIImage imageNamed:@"homepage_select"]];
        _findVC.tabBarItem = item;
    }
    return _findVC;
}
- (UIViewController *)LearnCircleVC
{
    if (!_LearnCircleVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LearnCircle" bundle:[NSBundle mainBundle]];
        _LearnCircleVC = [storyboard instantiateInitialViewController];
        
        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"学习圈" image:[UIImage imageNamed:@"studys_normal"] selectedImage:[UIImage imageNamed:@"studys_select"]];
        _LearnCircleVC.tabBarItem = item;
    }
    return _LearnCircleVC;
}
- (UIViewController *)InformationVC
{
    if (!_InformationVC) {
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Information" bundle:[NSBundle mainBundle]];
        _InformationVC = [sb instantiateInitialViewController];
        
        UITabBarItem* tabItem = [[UITabBarItem alloc] initWithTitle:[_menuNameArray lastObject]
                                                              image:[UIImage imageNamed:@"message_normal"]
                                                      selectedImage:[UIImage imageNamed:@"message_select"]];
        _InformationVC.tabBarItem = tabItem;
    }
    return _InformationVC;
}

//- (UIViewController *)nav_homeVC
//{
//    if (!_lightApp) {
////        HomeViewController* homeVC = [[HomeViewController alloc] init];
////        UINavigationController* nav_homeVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
////        nav_homeVC.navigationBar.translucent = NO;
////        nav_homeVC.navigationBar.tintColor = [UIColor whiteColor];
//        _lightApp = [[LXAlipayViewController alloc]init];
//        UINavigationController* nav_homeVC = [[UINavigationController alloc] initWithRootViewController:_lightApp];
//        //        nav_homeVC.navigationBar.translucent = NO;
//        //        nav_homeVC.navigationBar.tintColor = [UIColor whiteColor];
//        
//        UITabBarItem *item = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"message_normal"] selectedImage:[UIImage imageNamed:@"message_select"]];
//        _lightApp.tabBarItem = item;
//    }
//    return nav_homeVC;
//}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                        chatViewController = [[RedPacketChatViewController alloc]
#else
                                              chatViewController = [[ChatViewController alloc]
#endif
                                                                    initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                                              switch (messageType) {
                                                  case EMChatTypeChat:
                                                  {
                                                      NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                                                      for (EMGroup *group in groupArray) {
                                                          if ([group.groupId isEqualToString:conversationChatter]) {
                                                              chatViewController.title = group.subject;
                                                              break;
                                                          }
                                                      }
                                                  }
                                                      break;
                                                  default:
                                                      chatViewController.title = conversationChatter;
                                                      break;
                                              }
                                              [self.navigationController pushViewController:chatViewController animated:NO];
                                              }
                                              *stop= YES;
                                              }
                                              }
                                              else
                                              {
                                                  ChatViewController *chatViewController = nil;
                                                  NSString *conversationChatter = userInfo[kConversationChatter];
                                                  EMChatType messageType = [userInfo[kMessageType] intValue];
#ifdef REDPACKET_AVALABLE
                                                  chatViewController = [[RedPacketChatViewController alloc]
#else
                                                                        chatViewController = [[ChatViewController alloc]
#endif
                                                                                              initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                                                                        switch (messageType) {
                                                                            case EMChatTypeGroupChat:
                                                                            {
                                                                                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                                                                                for (EMGroup *group in groupArray) {
                                                                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                                                                        chatViewController.title = group.subject;
                                                                                        break;
                                                                                    }
                                                                                }
                                                                            }
                                                                                break;
                                                                            default:
                                                                                chatViewController.title = conversationChatter;
                                                                                break;
                                                                        }
                                                                        [self.navigationController pushViewController:chatViewController animated:NO];
                                                                        }
                                                                        }];
                                              }
//                                              else if (_chatListVC)
//                                              {
//                                                  [self.navigationController popToViewController:self animated:NO];
//                                                  [self setSelectedViewController:_chatListVC];
//                                              }
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

@end
