//
//  PageControllerView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/22.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "PageControllerView.h"
@interface PageControllerView ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation PageControllerView

-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andTitleFontSize:(CGFloat)fontSize andImages:(NSArray *)images  andPageControllers:(NSArray *)pages andSegmentColor:(UIColor*)color{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.pages = pages;
        UIView *pagesView = [[UIView alloc] initWithFrame:frame];
        CGFloat frameHeight = 35;
        if (images.count != 0) {
            frameHeight = 75;
        }
        CGRect segmentFrame = CGRectMake(0, 0 , CGRectGetWidth(frame), frameHeight);
        float containerHeight = CGRectGetHeight(frame)-frameHeight;
        
        NSMutableArray<UIImage *> *theImages = @[].mutableCopy;
        if (images != nil) {
            //segment view
            for (NSString *sss in images) {
                UIImage *image = [UIImage imageNamed:sss];
                CGFloat height = 35, width = 35;
                UIGraphicsBeginImageContext(CGSizeMake(width, height));
                
                [image drawInRect:CGRectMake(0, 0, width, height)];
                UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [theImages addObject: scaledImage];
            }
        }
        
        self.segment = [self createSegmentWithFrame:segmentFrame andImages:theImages andTitles:titles andTitleFontSize:fontSize];
        self.segment.backgroundColor = color;
        
        [pagesView addSubview:self.segment];
        
        //container view
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, ViewMaxY(self.segment), CGRectGetWidth(frame), containerHeight)];
        
        [pagesView addSubview:container];
        
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        
        [self.pageController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), ViewHeight(container))];
        
        [self.pageController setViewControllers:@[ [pages objectAtIndex:0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
       // [self addChildViewController:self.pageController];
        [container addSubview:self.pageController.view];
        [self addSubview:pagesView];

    }
    return self;
}


-(HMSegmentedControl *)createSegmentWithFrame:(CGRect)frame andImages:(NSArray *)images andTitles:(NSArray *)titles andTitleFontSize:(CGFloat)fontSize{
    HMSegmentedControl *segment = nil;
    if (images.count != 0) {
        segment = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:images titlesForSections:titles];
    }else{
        segment = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    }
    
    
    segment.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segment.frame = frame;
    segment.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segment.verticalDividerEnabled = NO;
    segment.selectionIndicatorHeight = 1.0f;
    segment.selectionIndicatorColor = kMainThemeColor;
    if (images.count != 0) {
        segment.type = HMSegmentedControlTypeTextImages;
    }
    
    [segment setTitleFormatter:^NSAttributedString*(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? kMainThemeColor : [UIColor darkGrayColor],NSFontAttributeName : font }];
        return attString;
    }];
    [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    return segment;
}

#pragma mark -- segment's value change
-(void)segmentValueChange:(HMSegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *diict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",index],@"selectedSegmentIndex", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CENTERCHANGE" object:nil userInfo:diict];
    
    
    if (index > self.currentPageIndex) {
        [self.pageController setViewControllers:@[ [self.pages objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
            if(weakSelf.delegate){
                [weakSelf.delegate clickHMSegmentedContolIndex:weakSelf.currentPageIndex];
            }
        }];
    }else {
        [self.pageController setViewControllers:@[ [self.pages objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
            if(weakSelf.delegate){
                [weakSelf.delegate clickHMSegmentedContolIndex:weakSelf.currentPageIndex];
            }
        }];
    }
    
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    return [self.pages objectAtIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfController:viewController];
    if (index == NSNotFound || index >= self.pages.count-1) {
        return nil;
    }
    
    return [self.pages objectAtIndex:index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        if(_delegate){
            [self.delegate clickHMSegmentedContolIndex:self.currentPageIndex];
        }
        [self.segment setSelectedSegmentIndex:self.currentPageIndex animated:YES];
        
        [self.pages enumerateObjectsUsingBlock:^(UIViewController* obj, NSUInteger idx, BOOL* stop) {
            for (UIView* aView in [obj.view subviews]) {
                if ([aView isKindOfClass:[UIScrollView class]]) {
                    [(UIScrollView*)aView setScrollsToTop:idx == self.currentPageIndex];
                }
            }
        }];
    }
}



- (NSInteger)indexOfController:(UIViewController *)viewController{
    __block NSInteger index = NSNotFound;
    [self.pages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (viewController == (UIViewController *)obj) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

@end
