//
//  ImageView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewDelegate <NSObject>

-(void)clickRepons:(UIButton *)sender;

@end

@interface ImageView : UIView

@property (nonatomic,strong) id<ImageViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray;

@end
