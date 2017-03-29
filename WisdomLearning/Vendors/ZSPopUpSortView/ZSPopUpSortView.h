//
//  ZSPopUpSortView.h
//  WisdomLearning
//
//  Created by Shane on 17/1/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSPopUpSortViewDelegate <NSObject>

-(void)clickSortViewIndex:(NSInteger) index;

@end

@interface ZSPopUpSortView : UIView

- (instancetype) initWithFrame:(CGRect)frame withTitles:(NSArray*)titles;



@property(nonatomic, assign) BOOL bSortUp;
@property(nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<ZSPopUpSortViewDelegate> theDelegate;

@end
