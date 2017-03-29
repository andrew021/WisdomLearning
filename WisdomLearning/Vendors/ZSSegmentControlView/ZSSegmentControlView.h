//
//  ZSSegmentControlView.h
//  LogisticsCloud
//
//  Created by Shane on 17/1/14.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
@class ZSSegmentControlView;

@protocol ZSSegmentControlViewDelegate <NSObject>

- (void)segmentControlView:(ZSSegmentControlView *)segmentControlView needMoreButton:(UIButton *)moreButton;

@end

typedef NS_ENUM(NSInteger, PagesSlidingType) {
    PagesSlidingTypeSlidingMovable = 0,//可滑动可点动
    PagesSlidingTypeOnlyMove,//仅点动
    PagesSlidingTypeNoPullOver,//滑动条靠边
    PagesSlidingTypeNoPullOverAndNoTitle,//不能滑动没有title
    PagesSlidingTypeCenter,//三个居中
    PagesSlidingTypeBlueArrow,//蓝色三角形
};




@interface ZSSegmentControlView : UIView

-(ZSSegmentControlView *)initViewWithFrame:(CGRect)frame andController:(UIViewController *)controller andTitles:(NSMutableArray *)titles andTitleFontSize:(CGFloat)fontSize andImages:(NSMutableArray *)images  andPageControllers:(NSArray *)pages andSegmentColor:(UIColor*)color PagesSlidingType:(PagesSlidingType)type isNeedMore:(BOOL)isNeedMore;

@property(nonatomic, strong) UIPageViewController *pageController;
@property(nonatomic, copy) NSArray *pages;
@property(nonatomic, assign) NSInteger currentPageIndex;
@property(nonatomic, strong)  HMSegmentedControl *segment;
@property(nonatomic, strong) UIColor *segmentSelectedIndicatorColor;
@property(nonatomic, assign) HMSegmentedControlSelectionStyle segmentSelectedStyle;
@property (nonatomic, weak) id <ZSSegmentControlViewDelegate> delegate;



@end
