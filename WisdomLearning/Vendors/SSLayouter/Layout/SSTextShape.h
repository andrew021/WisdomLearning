//
//  SSTextShape.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTextShape : NSObject

@property(nonatomic, assign) CGFloat width;				//宽度
@property(nonatomic, assign) CGFloat kerning;			//字距
@property(nonatomic, assign) CGFloat optimalKerning;	//最优字距
@property(nonatomic, assign) CGFloat fontSize;			//字体大小
@property(nonatomic, assign) NSRange range;				//位置（在整篇文章中的）
@property(nonatomic, strong) NSString *text;			//文本

+ (id) shapeWithText:(NSString *)text range:(NSRange)range;

@end
