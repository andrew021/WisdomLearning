//
//  HeaderView.h
//  ElevatorUncleManage
//
//  Created by Shane on 16/7/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+EnlargeEdge.h"

@protocol HeaderViewDelegate <NSObject>

-(void)clickRepons:(UIButton *)sender;
//-(void)selectTimeButton:(NSString *)time;
@end

@interface HeaderView : UIView

-(instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray*)titleArr withImageArr:(NSArray*)imageArr;
@property (nonatomic,strong) id<HeaderViewDelegate> delegate;
@property (nonatomic,assign) NSInteger  selectIndex;

-(void)changeTitles:(NSArray *)titles;
-(void)changeSelectedImages:(NSArray *)selectedImages;

-(void)reloadData;


@end
