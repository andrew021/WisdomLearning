//
//  UIViewController+SegmentControl.h
//  WisdomLearning
//
//  Created by Shane on 16/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
//#import "ZSImagesView.h"

@interface UIViewController (PagesControl)<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

-(UIView *)pagesViewWithFrame:(CGRect)frame andTitles:(NSArray *)titles andTitleFontSize:(CGFloat)fontSize andImages:(NSArray *)images  andPageControllers:(NSArray *)pages andSegmentColor:(UIColor*)color;


@property(nonatomic, strong) UIPageViewController *pageController;
@property(nonatomic, copy) NSArray *pages;
@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, strong)  HMSegmentedControl *hmSegment;

@end
