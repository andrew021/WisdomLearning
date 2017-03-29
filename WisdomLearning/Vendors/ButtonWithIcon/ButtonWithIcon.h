//
//  ButtonWithIcon.h
//
//
//  Created by e3mo on 16/4/26.
//  Copyright (c) 2016年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonWithIcon : UIButton {
    UIColor *icon_bg_normal_color;
    UIColor *icon_bg_highlight_color;
    
    UIColor *icon_label_normal_color;
    UIColor *icon_label_highlight_color;
}
@property (nonatomic, strong) UILabel *downlabel;
@property (nonatomic, strong) UIImageView *baseimage;
@property (nonatomic, strong) UILabel *iconlabel;

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imageName;

- (void)setIconLabelText:(NSString*)str;//显示有文字的角标

@end
