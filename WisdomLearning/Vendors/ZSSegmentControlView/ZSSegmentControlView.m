//
//  ZSSegmentControlView.m
//  LogisticsCloud
//
//  Created by Shane on 17/1/14.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSSegmentControlView.h"

@interface ZSSegmentControlView()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation ZSSegmentControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(ZSSegmentControlView *)initViewWithFrame:(CGRect)frame andController:(UIViewController *)controller andTitles:(NSMutableArray *)titles andTitleFontSize:(CGFloat)fontSize andImages:(NSMutableArray *)images  andPageControllers:(NSArray *)pages andSegmentColor:(UIColor*)color PagesSlidingType:(PagesSlidingType)type isNeedMore:(BOOL)isNeedMore
{
    if (self = [super initWithFrame:frame]) {
        _pages = pages;
        
        CGFloat frameHeight = 40;
        if (images.count != 0) {
            frameHeight = 75;
        }
        CGRect segmentFrame;
        switch (type) {
            case PagesSlidingTypeSlidingMovable:{
                segmentFrame = CGRectMake(0, 0 , CGRectGetWidth(frame), frameHeight);
            } break;
            case PagesSlidingTypeOnlyMove:{
                segmentFrame = CGRectMake(0, 0 , CGRectGetWidth(frame), frameHeight);
            } break;
            case PagesSlidingTypeNoPullOver:{
                segmentFrame = CGRectMake(10.0, 0 , CGRectGetWidth(frame) -20, frameHeight);
            } break;
            case PagesSlidingTypeNoPullOverAndNoTitle:{
                segmentFrame = CGRectMake(0, 0 , 0, 0);
            } break;
            case PagesSlidingTypeCenter:{
                segmentFrame = CGRectMake(45.0, 0 , CGRectGetWidth(frame) - 90.0, frameHeight);
            } break;
            case PagesSlidingTypeBlueArrow:{
                 segmentFrame = CGRectMake(10.0, 0 , CGRectGetWidth(frame) -20, frameHeight);
            } break;
            default:
                break;
        }
        
        float containerHeight = CGRectGetHeight(frame)-frameHeight;
        
        NSMutableArray<UIImage *> *theImages = @[].mutableCopy;
        if (images != nil) {
            //segment view
            if (isNeedMore) {
                [images removeLastObject];
            }
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
        
        //container view
        UIView *container = [UIView new];
        
        if (isNeedMore) {
            UIView * v= [[UIView alloc]initWithFrame:segmentFrame];
            v.backgroundColor = color;
            [self addSubview:v];
            NSString * titleLast = [titles lastObject];
            [titles removeLastObject];
            
            
            self.segment = [self createSegmentWithFrame:CGRectMake(0, 0 , ViewWidth(v) - 60.0, frameHeight) andImages:theImages andTitles:titles andTitleFontSize:fontSize PagesSlidingType:type];
            if (type == PagesSlidingTypeNoPullOver) {
                v.layer.cornerRadius = 5.0f;
                v.clipsToBounds = YES;
            }
            
            self.segment.backgroundColor = color;
            
            [v addSubview:self.segment];
            
            UIButton *moreButton = [[UIButton alloc]initWithFrame:CGRectMake( ViewMaxX(self.segment), 0, 60.0, frameHeight)];
            moreButton.backgroundColor = color;
            [moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
            [moreButton setTitle:titleLast forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            
            [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//             if (type == PagesSlidingTypeNoPullOver) {
//                 [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//             } else {
//                 [moreButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
//             }
            
            [v addSubview:moreButton];
            container.frame = CGRectMake(0, ViewMaxY(v), CGRectGetWidth(frame), containerHeight);
        } else {
            self.segment = [self createSegmentWithFrame:segmentFrame andImages:theImages andTitles:titles andTitleFontSize:fontSize PagesSlidingType:type];
            if (type == PagesSlidingTypeNoPullOver) {
                self.segment.layer.cornerRadius = 5.0f;
                self.segment.clipsToBounds = YES;
            }
            
            self.segment.backgroundColor = color;
            
            [self addSubview:self.segment];
            container.frame = CGRectMake(0, ViewMaxY(self.segment), CGRectGetWidth(frame), containerHeight);
        }
        
        [self addSubview:container];
        
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        if (type == PagesSlidingTypeSlidingMovable || type == PagesSlidingTypeNoPullOver || type == PagesSlidingTypeCenter) {
            _pageController.dataSource = self;
            _pageController.delegate = self;
        }
        
        [self.pageController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(frame), ViewHeight(container))];
        
        [self.pageController setViewControllers:@[ [pages objectAtIndex:0] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        [controller addChildViewController:self.pageController];
        [container addSubview:self.pageController.view];
    }
    return self;
}

-(HMSegmentedControl *)createSegmentWithFrame:(CGRect)frame andImages:(NSArray *)images andTitles:(NSArray *)titles andTitleFontSize:(CGFloat)fontSize PagesSlidingType:(PagesSlidingType)type;
{
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

//    if (type == PagesSlidingTypeNoPullOver) {
//        
//        segment.selectionIndicatorHeight = 3.0f;
////
////        segment.selectionIndicatorColor = kMainBlueColor;
////        segment.fixedStringWidth = 15.0f;
//    }
//   else if (type == PagesSlidingTypeBlueArrow) {
//      
//        segment.selectionIndicatorHeight = 5.0f;
//        
////        segment.selectionIndicatorColor = kMainBlueColor;
////        segment.fixedStringWidth = 15.0f;
//    }
//        else {
//        segment.selectionIndicatorHeight = 1.0f;
//        segment.selectionIndicatorColor = kMainThemeColor;
////        segment.fixedStringWidth = 6.0f;
////        segment.selectionIndicatorStripLayer.cornerRadius = 6.0/2;
//    }
    
    if (images.count != 0) {
        segment.type = HMSegmentedControlTypeTextImages;
    }
    
    [segment setTitleFormatter:^NSAttributedString*(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        
        UIFont *font = [UIFont systemFontOfSize:fontSize];
        NSAttributedString *attString;
        if (type == PagesSlidingTypeNoPullOver) {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? kMainThemeColor : kMainThemeColor,NSFontAttributeName : font }];
        }
        else if(type == PagesSlidingTypeBlueArrow){
             attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? kMainThemeColor : kMainThemeColor,NSFontAttributeName : font }];
        }
        
        else {
            attString = [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName : selected ? [UIColor blackColor] : [UIColor blackColor],NSFontAttributeName : font }];
        }
        return attString;
    }];
    [segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    return segment;
}

#pragma mark -- segment's value change
-(void)segmentValueChange:(HMSegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    
    if (index > self.currentPageIndex) {
        [self.pageController setViewControllers:@[ [_pages objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
        }];
    }else {
        [self.pageController setViewControllers:@[ [_pages objectAtIndex:segmentedControl.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            weakSelf.currentPageIndex = index;
        }];
    }
}


#pragma mark - Page View Controller Data Source
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    return [_pages objectAtIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfController:viewController];
    if (index == NSNotFound || index >= _pages.count-1) {
        return nil;
    }
    
    return [_pages objectAtIndex:index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
        
        [self.segment setSelectedSegmentIndex:self.currentPageIndex animated:YES];
        
        [_pages enumerateObjectsUsingBlock:^(UIViewController* obj, NSUInteger idx, BOOL* stop) {
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
    [_pages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (viewController == (UIViewController *)obj) {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}



-(void)setSegmentSelectedIndicatorColor:(UIColor *)segmentSelectedIndicatorColor{
    _segmentSelectedIndicatorColor = segmentSelectedIndicatorColor;
    _segment.selectionIndicatorColor = segmentSelectedIndicatorColor;
}

-(void)setSegmentSelectedStyle:(HMSegmentedControlSelectionStyle)segmentSelectedStyle{
    _segmentSelectedStyle = segmentSelectedStyle;
    _segment.selectionStyle = _segmentSelectedStyle;
}


-(void)moreClick:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControlView:needMoreButton:)]) {
        [self.delegate segmentControlView:self needMoreButton:sender];
    }
}

-(void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    __weak typeof(self) wSelf = self;
    [self.segment setSelectedSegmentIndex:currentPageIndex animated:YES];
    [self.pageController setViewControllers:@[ [self.pages objectAtIndex:self.segment.selectedSegmentIndex] ] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        wSelf.currentPageIndex = currentPageIndex;
    }];
}

@end
