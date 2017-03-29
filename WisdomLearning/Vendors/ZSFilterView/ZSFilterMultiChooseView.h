//
//  ZSFilterMultiChooseView.h
//  WisdomLearning
//
//  Created by Shane on 17/2/9.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSFilterMultiChooseViewDelegate <NSObject>

-(void)clickGetText:(NSString *)tagName;
-(void)clickGetBtnTag:(NSInteger)tag;

-(void)clickBtn:(UIButton *)btn;

@end

@interface ZSFilterMultiChooseView : UIView{
    CGRect previousFrame ;
    int totalHeight ;
}

/**
 * 整个view的背景色
 */
@property(nonatomic,retain)UIColor*GBbackgroundColor;
/**
 *  设置单一颜色
 */
@property(nonatomic)UIColor*signalTagColor;

@property(nonatomic, copy) NSString *retCode;
@property(nonatomic, copy) NSString *retVal;

@property(nonatomic,weak) id<ZSFilterMultiChooseViewDelegate>delegate;
/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;

+(CGFloat)getTagViewHeight:(NSArray*)arr withWidth:(CGFloat)width;


-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCode:(NSString *)code andAllVals:(NSArray *)allVals;
-(void)clearSelected;
//-(void)showHint;

@end
