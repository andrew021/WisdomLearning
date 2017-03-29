//
//  ZSFilterSegmentView.h
//  WisdomLearning
//
//  Created by Shane on 17/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSFilterSegmentView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *minVal;
@property (nonatomic, copy) NSString *maxVal;
@property (nonatomic, copy) NSString *retCode;
@property (nonatomic, copy) NSString *retVal;


-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCode:(NSString *)code andMinHint:(NSString *)minHint andMaxHint:(NSString *)maxHint;

-(void)clearText;
-(void)modifyVal;

+(CGFloat)getHeight;

@end
