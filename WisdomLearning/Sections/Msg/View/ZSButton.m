//
//  ZSButton.m
//  BigMovie
//
//  Created by Razi on 16/3/29.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "ZSButton.h"

@interface ZSButton ()

@property (nonatomic, copy) void (^tapblock)(ZSButton* btn);
@property (nonatomic, assign) ZSButtonType zsType;

@end

@implementation ZSButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }

    return self;
}

- (instancetype)initFlatButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zsType = ZSButtonTypeFlat;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [self setBackgroundImage:[self imageWithColor:kMainGreen] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:kMainDarkGreen] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[self imageWithColor:kAppGray] forState:UIControlStateDisabled];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];

        self.tapblock = block;
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (instancetype)initBorderButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block;
{
   
    self = [super initWithFrame:frame];
    if (self) {
        self.zsType = ZSButtonTypeBorder;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:kButtonHightGray] forState:UIControlStateHighlighted];
        [self setTitleColor:kButtonLightblue forState:UIControlStateSelected];
        
        [self.layer setBorderColor:kButtonBorderGray.CGColor];
        [self.layer setBorderWidth:0.5];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
        
        self.tapblock = block;
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }


    return self;
}

- (instancetype)initBorderButtonWithFrame:(CGRect)frame
                                 andColor:(UIColor*)color
                                 andTitle:(NSString*)title
                              andTapBlock:(void (^)(ZSButton* btn))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zsType = ZSButtonTypeBorder;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        [self setTitleColor:kButtonLightblue forState:UIControlStateSelected];
        
        [self.layer setBorderColor:color.CGColor];
        [self.layer setBorderWidth:0.5];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
        
        self.tapblock = block;
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return self;

}
- (instancetype)initDeleteButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zsType = ZSButtonTypeBorder;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithColor:kButtonHightGray] forState:UIControlStateHighlighted];
        
        [self.layer setBorderColor:kButtonBorderGray.CGColor];
        [self.layer setBorderWidth:0.5];
        [self.layer setCornerRadius:5.0];
        [self.layer setMasksToBounds:YES];
        self.tapblock = block;
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

- (instancetype)initNormalButtonWithFrame:(CGRect)frame andTitlt:(NSString*)title
                              andTapBlock:(void (^)(ZSButton* btn))block
{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.zsType = ZSButtonTypeNormal;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.tapblock = block;
        [self addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self.layer setBorderColor:kButtonLightblue.CGColor];
    }
    else {
        [self.layer setBorderColor:kButtonBorderGray.CGColor];
    }
}

- (void)tap:(ZSButton*)button
{
    if (self.tapblock) {
        self.tapblock(button);
    }
}

- (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
