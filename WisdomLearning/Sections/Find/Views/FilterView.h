//
//  FilterView.h
//  WisdomLearning
//
//  Created by DiorSama on 2017/1/9.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView ;

@protocol SendPriceAndCourse <NSObject>

-(void)sendDownPrice:(NSString*)downStr withHighPrice:(NSString*)highStr withCodeArr:(NSArray*)codeArr;

-(void)clickSureInFilterView:(FilterView *)view;

@end

@interface FilterView : UIView

- (instancetype) initWithFrame:(CGRect)frame withNSArray:(NSArray*)arr;
@property(nonatomic,strong) id<SendPriceAndCourse>delegate;

@property (nonatomic, copy) NSString *priceRange;
@property (nonatomic, strong) NSMutableArray *selectTags;

@property (nonatomic, copy) NSString *filter0;
@property (nonatomic, copy) NSString *filter1;

@property (nonatomic,strong) NSString * downString;
@property (nonatomic,strong) NSString * highString;
@property (nonatomic,strong) NSMutableArray * selectCodeArr;

@end
