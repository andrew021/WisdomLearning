//
//  SSTextShapeParser.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  字符属性的解析器
 *  主要是拆分字符串、然后分别计算字符的属性（见SSTextShape类）
 */
@interface SSTextShapeParser : NSObject

@property(nonatomic, assign) CGFloat optimalKerning;
@property(nonatomic, strong) NSArray *shapes;

- (void) parseAttributedStringShape:(NSAttributedString *)attributedString lineWidth:(CGFloat)lineWidth;

@end
