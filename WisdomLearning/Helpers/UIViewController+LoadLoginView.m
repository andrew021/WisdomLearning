//
//  UIViewController+LoadLoginView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "UIViewController+LoadLoginView.h"
#import <objc/runtime.h>

static void *unloginKey = &unloginKey;
static void *loginSuccessKey = &loginSuccessKey;
static void *logoutKey = &logoutKey;
static void *loginKey = &loginKey;

@implementation UIViewController (LoadLoginView)

-(void)indirectLoginViewWithLoginSucessBlock:(void (^)())loginSucessBlock andLogoutBlock:(void (^)())logoutBlock {
    self.loginSucessBlock = loginSucessBlock;
    self.logoutBlock = logoutBlock;
//    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:LOGINSUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(indirectLogin)
                                                 name:LOGOUT
                                               object:nil];

    
    if (![[Config Instance] isLogin]) {
        [self indirectLogin];
    }
}

-(void)directLoginWithSucessBlock:(void (^)())loginSucessBlock{
    self.loginSucessBlock = loginSucessBlock;
//    self.logoutBlock = logoutBlock;
//    //    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(directLoginSucess)
                                                 name:LOGINSUCCESS
                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(indirectLogin)
//                                                 name:LOGOUT
//                                               object:nil];
    
    
    if (![[Config Instance] isLogin]) {
        LoginController *loginCtrl = [[LoginController alloc] init];
        MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginCtrl];
        [self presentViewController:nav animated:YES completion:nil];
    }

}

-(void)homepageLogoutWithBlock:(void (^)())logoutBlock {
    self.logoutBlock = logoutBlock;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toDo)
                                                 name:LOGOUT
                                               object:nil];
}

-(void)toDo{
    if (self.logoutBlock) {
        self.logoutBlock();
    }
}


- (void)directLoginSucess{
    if (self.loginSucessBlock) {
        self.loginSucessBlock();
    }
}


- (void)loginSuccess{
    if (self.unLoginController) {
        if (self.loginSucessBlock) {
            self.loginSucessBlock();
        }
        [self.unLoginController.view removeFromSuperview];
        [self.unLoginController removeFromParentViewController];
    }
    
    
    if (self.loginController) {
        if (self.loginSucessBlock) {
            self.loginSucessBlock();
        }
        [self.loginController.view removeFromSuperview];
        [self.loginController removeFromParentViewController];
    }
}
-(void)indirectLogin{
    if (!self.unLoginController) {
        self.unLoginController  = [[UnLoginController alloc]init];
    }
    
    if (self.logoutBlock) {
        self.logoutBlock();
    }
    [self addChildViewController:self.unLoginController];
    [self.unLoginController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.unLoginController.view];
}

//-(void)directLogin{
//    LoginController *loginCtrl = [[LoginController alloc] init];
//    MyNavigationController *nav = [[MyNavigationController alloc] initWithRootViewController:loginCtrl];
//    [self presentViewController:nav animated:YES completion:nil];
//}

-(void)toIMLogin
{
    if (!self.loginController) {
        self.loginController  = [[LoginController alloc]init];
    }
    
    if (self.logoutBlock) {
        self.logoutBlock();
    }
    [self addChildViewController:self.loginController];
    [self.unLoginController.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:self.loginController.view];
}

-(void)setLoginController:(LoginController *)loginController
{
     objc_setAssociatedObject(self, &loginKey, loginController, OBJC_ASSOCIATION_RETAIN);
}


-(LoginController*)loginController{
     return objc_getAssociatedObject(self, &loginKey);
}


-(void)setUnLoginController:(UnLoginController *)unLoginController{
    objc_setAssociatedObject(self, &unloginKey, unLoginController, OBJC_ASSOCIATION_RETAIN);
}

-(UnLoginController *)unLoginController{
    return objc_getAssociatedObject(self, &unloginKey);
}

-(void)setLoginSucessBlock:(LoginSucessBlock)loginSucessBlock{
    objc_setAssociatedObject(self, &loginSuccessKey, loginSucessBlock, OBJC_ASSOCIATION_COPY);
}

-(LoginSucessBlock)loginSucessBlock{
    return objc_getAssociatedObject(self, &loginSuccessKey);
}

-(void)setLogoutBlock:(LogoutBlock)logoutBlock{
    objc_setAssociatedObject(self, &logoutKey, logoutBlock, OBJC_ASSOCIATION_COPY);
}

-(LogoutBlock)logoutBlock{
    return objc_getAssociatedObject(self, &logoutKey);
}

@end
