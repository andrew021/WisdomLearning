//
//  ButtonWithIcon.m
//  
//
//  Created by e3mo on 16/4/26.
//  Copyright (c) 2016年 times. All rights reserved.
//

#import "ButtonWithIcon.h"

@implementation ButtonWithIcon

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBase];
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        _baseimage = [[UIImageView alloc] initWithFrame:CGRectMake(width / 2.0 - 0.5 *height + 25.0, 15.0, height - 50.0, height - 50.0)];
        [_baseimage setBackgroundColor:[UIColor clearColor]];
        [_baseimage setContentMode:UIViewContentModeScaleAspectFit];
        _baseimage.image = [UIImage imageNamed:imageName];
        [self addSubview:_baseimage];
        
        _downlabel = [UILabel new];
        _downlabel.center = CGPointMake(_baseimage.center.x, _baseimage.frame.origin.y + height - 35.0);
        [_downlabel sizeToFit];
        _downlabel.bounds =CGRectMake(0, 0, 80, 20);
        [_downlabel setText:@""];
        [_downlabel setTextColor:KMainGray];
        [_downlabel setTextAlignment:NSTextAlignmentCenter];
        [_downlabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_downlabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_downlabel];
        
        [self initIconLabel];
        [self setIconLabelMode];
    }
    return self;
}
- (void)initIconLabel
{
    _iconlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    _iconlabel.center = CGPointMake(_baseimage.frame.origin.x+_baseimage.frame.size.width, _baseimage.frame.origin.y);
    [_iconlabel setText:@""];
    [_iconlabel setTextColor:icon_label_normal_color];
    [_iconlabel setTextAlignment:NSTextAlignmentCenter];
    _iconlabel.font = [UIFont boldSystemFontOfSize:18.0];
    [_iconlabel setBackgroundColor:icon_bg_normal_color];
    //不能和加阴影同时使用
    _iconlabel.layer.masksToBounds = YES;
    _iconlabel.layer.cornerRadius = _iconlabel.frame.size.width / 2.0;//如果圆角为一半，则可以截成圆形
    _iconlabel.hidden = YES;
    [self addSubview:_iconlabel];
}
- (void)setIconLabelMode
{
    _iconlabel.frame = CGRectMake(0, 0, 30, 30);
    _iconlabel.center = CGPointMake(_baseimage.frame.origin.x+_baseimage.frame.size.width * 0.9, _baseimage.frame.origin.y + 6.0);
    _iconlabel.layer.cornerRadius = _iconlabel.frame.size.width/2;//如果圆角为一半，则可以截成圆形
    _iconlabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconlabel.layer.borderWidth = 2.0f;
}

- (void)setIconLabelText:(NSString*)str {
    if (str && str.length > 0) {
        _iconlabel.text = str;
        _iconlabel.hidden = NO;
        
        CGRect frame = _iconlabel.frame;
        [_iconlabel sizeToFit];
        
        if (frame.size.width < frame.size.height) {
            frame.size.width = frame.size.height;
            _iconlabel.adjustsFontSizeToFitWidth = NO;
        }else{
            _iconlabel.adjustsFontSizeToFitWidth = YES;
        }
        frame.origin.x = _iconlabel.frame.origin.x;
        frame.origin.y = _iconlabel.frame.origin.y;
        _iconlabel.frame = frame;
    } else {
        _iconlabel.text = nil;
        _iconlabel.hidden = YES;
        
        CGRect frame = _iconlabel.frame;
        frame.size.width = frame.size.height;
    }
}

- (void)initBase {
    icon_bg_normal_color = KMainRed;
    icon_bg_highlight_color = KMainRed;
    
    icon_label_normal_color = [UIColor whiteColor];
    icon_label_highlight_color = [UIColor whiteColor];
    
    [self addTarget:self action:@selector(btnHighlighted) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(btnNormal) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(btnNormal) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)setIconLabelColor:(UIColor*)color highlightColor:(UIColor*)highlightColor {
    icon_label_normal_color = color;
    icon_label_highlight_color = highlightColor;
    
    _iconlabel.textColor = icon_label_normal_color;
}

#pragma mark - btn base action
- (void)btnHighlighted {
    if (icon_label_highlight_color) {
        [_iconlabel setTextColor:icon_label_highlight_color];
    }
    if (icon_bg_highlight_color) {
        [_iconlabel setBackgroundColor:icon_bg_highlight_color];
    }
}

- (void)btnNormal {
    [_iconlabel setTextColor:icon_label_normal_color];
    [_iconlabel setBackgroundColor:icon_bg_normal_color];
}


@end
