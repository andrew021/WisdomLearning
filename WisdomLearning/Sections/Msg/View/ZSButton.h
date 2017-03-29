//
//  ZSButton.h
//  BigMovie
//
//  Created by Razi on 16/3/29.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZSButtonType) {
    ZSButtonTypeFlat = 0,
    ZSButtonTypeBorder,
    ZSButtonTypeDelete,
    ZSButtonTypeNormal
};

@interface ZSButton : UIButton

@property (nonatomic, assign) NSInteger sectionNum;
- (instancetype)initFlatButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block;
- (instancetype)initBorderButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block;
- (instancetype)initDeleteButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andTapBlock:(void (^)(ZSButton* btn))block;
- (instancetype)initNormalButtonWithFrame:(CGRect)frame andTitlt:(NSString*)title
    andTapBlock:(void (^)(ZSButton* btn))block;
- (instancetype)initBorderButtonWithFrame:(CGRect)frame
                                 andColor:(UIColor*)color
                                 andTitle:(NSString*)title
                              andTapBlock:(void (^)(ZSButton* btn))block;
@end
