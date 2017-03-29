//
//  ZWTagListView.h
//  自定义流式标签
//
//  Created by zhangwei on 15/10/22.
//  Copyright (c) 2015年 zhangwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetClickBtnText <NSObject>

-(void)clickGetText:(NSString *)tagName;
-(void)clickGetBtnTag:(NSInteger)tag;

-(void)clickBtn:(UIButton *)btn;

@end

@interface ZWTagListView : UIView{
    
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

@property(nonatomic,weak) id<GetClickBtnText>delegate;
/**
 *  标签文本赋值
 */
-(void)setTagWithTagArray:(NSArray*)arr;

+(CGFloat)getTagViewHeight:(NSArray*)arr withWidth:(CGFloat)width;


-(void)setTagStatusByArray:(NSArray *)arr;
@end
