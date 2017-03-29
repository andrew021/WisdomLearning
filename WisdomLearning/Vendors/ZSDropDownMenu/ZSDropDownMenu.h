//
//  ZSDropDownMenu.h
//  WisdomLearning
//
//  Created by Shane on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZSDropDownMenuDelegate <NSObject>

@optional
-(void)clickMenuItemInSection:(NSInteger)section andRow:(NSInteger)row;
-(void)clickMenuItemInRow:(NSInteger)row;


@end

@interface ZSDropDownMenu : UIView

-(instancetype)initWithFrame:(CGRect)frame andItemsArray:(NSArray *)itemsArray;

@property(nonatomic, weak) id<ZSDropDownMenuDelegate> theDelegate;

@end
