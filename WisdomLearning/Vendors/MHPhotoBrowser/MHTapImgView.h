//
//  MHTapImgView.h
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHTapImgViewDelegate;

@interface MHTapImgView : UIImageView
@property (nonatomic, weak) id<MHTapImgViewDelegate> delegate;
@end

@protocol MHTapImgViewDelegate <NSObject>
@optional
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch;
- (void)imageView:(UIImageView *)imageView tripleTapDetected:(UITouch *)touch;
@end