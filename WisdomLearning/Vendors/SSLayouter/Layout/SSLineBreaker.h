//
//  SSLineBreaker.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSLineBreaker : NSObject

+ (id) lineBreakerWithOptimalKerning:(CGFloat)optimalKerning;

- (NSArray *) linesBreakAndUpdate:(NSMutableAttributedString * __strong *)string lineWidth:(CGFloat)lineWidth paragraphRanges:(NSMutableArray *)paragraphRanges;

@end
