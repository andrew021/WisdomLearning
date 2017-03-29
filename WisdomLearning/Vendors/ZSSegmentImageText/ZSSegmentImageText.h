//
//  ZSSegmentImageText.h
//  WisdomLearning
//
//  Created by Shane on 16/11/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSSegmentImageTextDelegate <NSObject>

-(void)clickImageText:(NSInteger)index;

@end

@interface ZSSegmentImageText : UIView

-(instancetype)initWithFrame:(CGRect)frame andImages:(NSArray *)imageNames andImageWidth:(CGFloat)imageWidth andImgHeight:(CGFloat)imageHeight andTitles:(NSArray *)titles andTitleSize:(CGFloat)titleSize;

@property (nonatomic, weak) id<ZSSegmentImageTextDelegate> theDelegate;

@end
