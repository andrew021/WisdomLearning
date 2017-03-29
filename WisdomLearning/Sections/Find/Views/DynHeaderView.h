//
//  DynHeaderView.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+EnlargeEdge.h"

@protocol DynHeaderViewDelegate <NSObject>
-(void)clickRepons:(UIButton *)sender asc:(NSInteger)asc;
@end

@interface DynHeaderView : UIView

@property (nonatomic,strong) id<DynHeaderViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray;

@end
