//
//  ZSFilterView.h
//  WisdomLearning
//
//  Created by Shane on 17/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZSFilterView ;

@protocol ZSFilterViewDelegate <NSObject>

-(void)sureDataInFileterView:(ZSFilterView *)filterView;
@end

@interface ZSFilterView : UIView

@property(nonatomic, weak) id<ZSFilterViewDelegate> theDelegate;
@property(nonatomic, copy) NSString *filterItems;
@property(nonatomic, copy) NSString *filterValues;

-(instancetype)initWithContentHeight:(CGFloat)contentHeight andData:(NSArray<FilterFieldModel *> *)datas;


@end
