//
//  BaseSegmentController.m
//  SegmentController
//
//  Created by Razi on 16/2/19.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import "BaseSegmentController.h"
#import "HMSegmentedControl.h"
#import "THSegmentedPageViewControllerDelegate.h"

#import "Colours.h"

@interface BaseSegmentController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) HMSegmentedControl* pageControl;
@property (strong, nonatomic) UIView* contentContainer;

@property (strong, nonatomic) UIPageViewController* pageViewController;

@end

@implementation BaseSegmentController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)initWithPages:(NSArray*)pages
{
    self = [super init];
    if (self) {
        self.pages = [pages mutableCopy];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSegControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.pages count] > 0) {
        [self.pageViewController setViewControllers:@[self.selectedController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
    [self updateTitleLabels];
}

#pragma mark -
#pragma mark - Init
- (void)initSegControl
{
    //Init SegmentControl
    self.pageControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.pageControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
   
    self.pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.pageControl.verticalDividerEnabled = NO;
    self.pageControl.selectionIndicatorHeight = 1.5f;
  ;
    //划线颜色
    self.pageControl.selectionIndicatorColor = kMainThemeColor;
    [self.pageControl setTitleFormatter:^NSAttributedString*(HMSegmentedControl* segmentedControl, NSString* title, NSUInteger index, BOOL selected) {
        NSAttributedString* attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? kMainThemeColor: [UIColor darkGrayColor], NSFontAttributeName : !(kDevice_Is_iPhone5 || kDevice_Is_iPhone4) ? [UIFont systemFontOfSize:15] : [UIFont systemFontOfSize:13] }];
        return attString;
    }];
    [self.pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    //[self.pageControl addLineUp:NO andDown:YES];
    [self.view addSubview:self.pageControl];

    //Init Container View
    self.contentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageControl.frame), self.view.frame.size.width, self.view.frame.size.height - 40)];
    [self.view addSubview:self.contentContainer];

    //Init PageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
    [self.pageViewController setDataSource:self];
    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];

    [self.contentContainer addSubview:self.pageViewController.view];
}

#pragma mark - Setup
- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
   
}

- (NSArray*)titleLabels
{
    NSMutableArray* titles = [NSMutableArray new];
    for (UIViewController* vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate>*)vc)viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate>*)vc)viewControllerTitle]];
        }
        else {
            [titles addObject:vc.title ? vc.title : NSLocalizedString(@"NoTitle", @"")];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        }
        else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController*)selectedController
{
 
  //我修改的
//    NSUserDefaults * userType = [NSUserDefaults standardUserDefaults];
//    NSString * str = [userType objectForKey:@"searchType"];
//    
//    if([str isEqualToString:@""]|| str == nil){
//       
//        return self.pages[[self.pageControl selectedSegmentIndex]];
//    }
//    else{
//        self.pageControl.selectedSegmentIndex = [str integerValue];
//        return self.pages[self.pageControl.selectedSegmentIndex];
//    }
    return self.pages[[self.pageControl selectedSegmentIndex]];

}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[ self.pages[index] ]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerBeforeViewController:(UIViewController*)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];

    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }

    return self.pages[--index];
}

- (UIViewController*)pageViewController:(UIPageViewController*)pageViewController viewControllerAfterViewController:(UIViewController*)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];

    if ((index == NSNotFound) || (index + 1 >= [self.pages count])) {
        return nil;
    }

    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController*)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray*)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        return;
    }

    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[ [self selectedController] ]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
}

#pragma mark -
#pragma mark - Setter Getter
- (NSMutableArray*)pages
{
    if (!_pages)
        _pages = [NSMutableArray new];
    return _pages;
}

@end
