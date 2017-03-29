//
//  MyNavigationController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)initialize
{
    // 设置导航栏主题
    [self setupNavBarTheme];
}
//
// 设置导航栏主题
+ (void)setupNavBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置标题属性
    NSMutableDictionary *textAttrs =[NSMutableDictionary dictionary];
    navBar.tintColor =[UIColor whiteColor];//[UIColor colorFromHexString:@"838383"];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    navBar.barTintColor = kMainThemeColor;
    textAttrs[NSFontAttributeName] = [UIFont fontWithName:@"Arial" size:17.0f];
    [navBar setTitleTextAttributes:textAttrs];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {// 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        [self setNavigationBarHidden:NO animated:NO];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        
        //设置导航栏的按钮
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"find_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
    [super pushViewController:viewController animated:animated];
}
- (void)back {
    [self popViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

 -(NSUInteger)supportedInterfaceOrientations {
        return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

 - (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
        return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}


@end
