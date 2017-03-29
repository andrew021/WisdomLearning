//
//  SSSlider.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSPlayerSlider;

@protocol SSPlayerSliderDelegate <NSObject>

@optional
- (void)playerSliderValueChanged:(SSPlayerSlider *)slider;
- (void)playerSliderDragging:(SSPlayerSlider *)slider;

@end

@interface SSPlayerSlider : UIView

@property(nonatomic, weak) id<SSPlayerSliderDelegate> delegate;

@property (nonatomic, assign) CGFloat value;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat middleValue;  /* From 0 to 1 */

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat sliderDiameter;
@property (nonatomic, strong) UIColor *sliderColor;
@property (nonatomic, strong) UIColor *maxColor;
@property (nonatomic, strong) UIColor *middleColor;
@property (nonatomic, strong) UIColor *minColor;

@end
