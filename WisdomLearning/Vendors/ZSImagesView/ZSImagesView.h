//
//  ZSImagesView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSImagesViewDelegate <NSObject>

-(void)clickImgaeView:(UIButton *)sender;

@end


@interface ZSImagesView : UIView


@property (nonatomic,strong) id<ZSImagesViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray andPadding:(float)padding andImageWidth:(float)width andImageHeight:(float)height andCorner:(BOOL)bCorner;

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray andPadding:(float)padding andImageWidth:(float)width andImageHeight:(float)height andCorner:(BOOL)bCorner andFixedGap:(float)fixedGap;


@end
