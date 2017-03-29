//
//  MyCurriculumViewController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyCurriculumViewController.h"
#import "CurriculumViewController.h"
#import "ZSSegmentControlView.h"

@interface MyCurriculumViewController ()

@property (nonatomic, copy) NSArray *pages;

@end

@implementation MyCurriculumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的课表";
    self.view.backgroundColor = [UIColor whiteColor];
    

    UIView *pagesView = [self pagesViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andTitles:@[@"在学课程", @"学完课程"] andTitleFontSize:15 andImages:nil andPageControllers:self.pages andSegmentColor:[UIColor whiteColor]];
    [self.view addSubview: pagesView];
    
    ZSSegmentControlView *segmentView = [[ZSSegmentControlView alloc] initViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) andController:self andTitles:@[@"在学课程", @"学完课程"].mutableCopy andTitleFontSize:15.0f andImages:nil andPageControllers:self.pages andSegmentColor:[UIColor whiteColor] PagesSlidingType:PagesSlidingTypeOnlyMove isNeedMore:NO];
    [self.view addSubview: segmentView];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

-(NSArray *)pages{
    if (!_pages) {
        CurriculumViewController *v1 = [[CurriculumViewController alloc] init];
        v1.listType = @"1";
        CurriculumViewController *v2 = [[CurriculumViewController alloc] init];
        v2.listType = @"3";
        _pages = @[v1, v2];
    }
    return _pages;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
