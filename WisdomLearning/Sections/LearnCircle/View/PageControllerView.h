//
//  PageControllerView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/22.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@protocol ClickHMSegmentedContol <NSObject>

-(void)clickHMSegmentedContolIndex:(NSInteger)index;

@end

@interface PageControllerView : UIView


@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property(nonatomic, strong) UIPageViewController *pageController;
@property(nonatomic, copy) NSArray *pages;
@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, strong)  HMSegmentedControl *segment;
@property (nonatomic,strong) id<ClickHMSegmentedContol>delegate;
-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andTitleFontSize:(CGFloat)fontSize andImages:(NSArray *)images  andPageControllers:(NSArray *)pages andSegmentColor:(UIColor*)color;

@end
