//
//  CrowdFundingImageView.h
//  BigMovie
//
//  Created by DiorSama on 16/6/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "BRPlaceholderTextView.h"


@interface CrowdFundingImageView : UIView

@property (nonatomic, strong) NSArray* imageArrays;
@property (nonatomic, assign) BOOL isURL;



- (instancetype)initWithFrame:(CGRect)frame withWidth:(CGFloat)width;
//获取高度
+ (CGFloat)getImagesGirdViewHeight:(NSArray*)imgs withWidth:(CGFloat)width;

@end