//
//  ZSIntelligentSegment.h
//  WisdomLearning
//
//  Created by Shane on 17/1/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZSImageTextButton;

@protocol ZSIntelligentSegmentDelegate <NSObject>

-(void)clickTheSegmentIndex:(NSInteger)index;

@end

@interface ZSIntelligentSegment : UIView

-(instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andImages:(NSArray *)images andSelectedImages:(NSArray *)selectedImages andTitleFont:(UIFont *)titleFont;
-(void)changeTitles:(NSArray *)titles;
-(void)changeSelectedImages:(NSArray *)selectedImages;
-(void)reloadData;

@property(nonatomic, weak) id<ZSIntelligentSegmentDelegate> theDelegate;
@property(nonatomic, assign) NSInteger selectedIndex;

@end
