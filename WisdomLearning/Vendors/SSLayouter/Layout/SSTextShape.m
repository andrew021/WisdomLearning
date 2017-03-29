//
//  SSTextShape.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSTextShape.h"

@implementation SSTextShape

+ (id) shapeWithText:(NSString *)text range:(NSRange)range
{
    SSTextShape *s = [[SSTextShape alloc] init];
    s.text = text;
    s.range = range;
    return s;
}

@end
