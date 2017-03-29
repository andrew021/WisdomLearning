//
//  ZSHorThreeImagesView.h
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSHorThreeImagesView : UIView

//@property (nonatomic, strong) NSArray* imageArrays;
@property (nonatomic, assign) BOOL isURL;
@property (nonatomic, copy) NSArray *images;



- (instancetype)initWithFrame:(CGRect)frame withPadding:(CGFloat)padding withHorizontalSpacing:(CGFloat)horizontalSpacing withVerticalSpacing:(CGFloat)verticalSpacing;
//获取高度
+ (CGFloat)getHorThreeImagesViewHeight:(NSArray*)imgs withWidth:(CGFloat)width withVerticalSpacing:(CGFloat)verticalSpacing;

//+(UIImage *)imageWithUrl:(NSString *)url;

@end
