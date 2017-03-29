//
//  UIViewController+LoadLoginView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnLoginController.h"
#import "LoginController.h"

typedef void (^LoginSucessBlock)();
typedef void (^LogoutBlock)();

@interface UIViewController (LoadLoginView)

@property (nonatomic, strong) UnLoginController *unLoginController;
@property (nonatomic, strong) LoginController * loginController;
@property (nonatomic, copy) LoginSucessBlock loginSucessBlock;
@property (nonatomic, copy) LogoutBlock logoutBlock;

-(void)indirectLoginViewWithLoginSucessBlock:(void (^)())loginSucessBlock andLogoutBlock:(void (^)())logoutBlock;
-(void)directLoginWithSucessBlock:(void (^)())loginSucessBlock;
-(void)homepageLogoutWithBlock:(void (^)())logoutBlock;
@end
