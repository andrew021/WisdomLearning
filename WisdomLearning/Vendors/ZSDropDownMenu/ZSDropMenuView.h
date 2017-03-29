//
//  ZSDropMenuView.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSDropMenuViewDelegate <NSObject>

@optional
-(void)clickMenuItemInSection:(NSInteger)section andRow:(NSInteger)row;
-(void)clickMenuItemInRow:(NSInteger)row;


@end

@interface ZSDropMenuView : UIView

-(instancetype)initWithFrame:(CGRect)frame andItemsArray:(NSArray *)itemsArray;

@property(nonatomic, weak) id<ZSDropMenuViewDelegate> theDelegate;

@end
