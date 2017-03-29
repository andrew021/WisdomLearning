//
//  ProjectFilterView.h
//  WisdomLearning
//
//  Created by DiorSama on 2017/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SendPriceAndProgram <NSObject>

-(void)sendDownPrice:(NSString*)downStr withHighPrice:(NSString*)highStr withDownHour:(NSString*)downHour whitHighHour:(NSString*)highHour;


@end

@interface ProjectFilterView : UIView

- (instancetype) initWithFrame:(CGRect)frame withNSArray:(NSArray*)arr;
@property(nonatomic,strong) id<SendPriceAndProgram>delegate;

@property (nonatomic, copy) NSString *priceRange;
@property (nonatomic, strong) NSMutableArray *selectTags;

@property (nonatomic,strong) NSString * downString;
@property (nonatomic,strong) NSString * highString;

@property (nonatomic,strong) NSString * downStudy;
@property (nonatomic,strong) NSString * highStudy;

@property (nonatomic,strong) NSMutableArray * selectCodeArr;

@property (nonatomic, copy) NSString *studyHourRange;

@end
