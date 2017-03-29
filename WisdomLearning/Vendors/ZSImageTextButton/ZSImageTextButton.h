//
//  ZSImageTextButton.h
//  WisdomLearning
//
//  Created by Shane on 16/12/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSImageTextButton : UIButton  //left image and right text

@property (nonatomic, assign) float gap;
@property (nonatomic, assign) float imageWidth;
@property (nonatomic, assign) float imageHeight;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) float xPos;
@property (nonatomic, assign) UIFont *titleFont;
@property (nonatomic, assign) UIColor *titleColor;
@property (nonatomic, assign) BOOL bImageLeft;

-(instancetype)initWithFrame:(CGRect)frame andImageLeft:(BOOL)bImageLeft andImage:(UIImage *)image andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont;

@end
