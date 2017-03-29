//
//  AppDelegate+JPush.h
//  ElevatorUncle
//
//  Created by Shane on 16/6/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"

@interface AppDelegate (JPush)

- (void)jpushApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                    appkey:(NSString *)appkey
                   channel:(NSString *)channel
          apsForProduction:(BOOL)isProduction;

//@property (nonatomic,strong)  NSDictionary* userInfo;
@property (nonatomic,strong) NSString * str;
@property (nonatomic,assign)EMConversationType messageType;
@end
