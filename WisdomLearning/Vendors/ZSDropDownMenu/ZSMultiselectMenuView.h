//
//  ZSMultiselectMenuView.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSMultiselectMenuViewDelegate <NSObject>

@optional
-(void)clickMenuItemInSelectItemArray:(NSArray *)selectItemArray;

@end

@interface ZSMultiselectMenuView : UIView

-(instancetype)initWithFrame:(CGRect)frame andItemsArray:(NSArray *)itemsArray selectItemsArray:(NSArray *)selectItemsArray;
@property(nonatomic, weak) id<ZSMultiselectMenuViewDelegate> theDelegate;

@end
