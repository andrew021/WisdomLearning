//
//  SSTextShapeParser.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSTextShapeParser.h"
#import "SSFunctions.h"
#import "SSTextShape.h"
#import "SSLayoutLine.h"

#define SHOW_DEBUG

@implementation SSTextShapeParser
{
    NSMutableArray *_shapes;
    NSAttributedString *_attributedString;
    CGFloat _lineWidth;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        if (SSiPad)
        {
            self.optimalKerning = 0.05;
        }
        else
        {
            self.optimalKerning = 0.08;
        }
        
    }
    return self;
}

- (void) parseAttributedStringShape:(NSAttributedString *)attributedString lineWidth:(CGFloat)lineWidth
{
    if (!attributedString) {
        return;
    }
    _attributedString = attributedString;
    _lineWidth = lineWidth;
    [self _createShapesAndSetRange];
    [self _parseShapesAttributes];
}


- (void) _createShapesAndSetRange
{
#ifdef SHOW_DEBUG
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
#endif
    NSString *plainString = [_attributedString string];
    if (!_shapes)
    {
        _shapes = [NSMutableArray array];
    }
    else
    {
        [_shapes removeAllObjects];
    }
    //匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。
    NSRegularExpression *regSpace = [NSRegularExpression regularExpressionWithPattern:@"^\\s+" options:0 error:NULL];
    //字母和英文
    NSRegularExpression *regLatin = [NSRegularExpression regularExpressionWithPattern:@"^[^\\s\\u0100-\\uffff]+" options:0 error:NULL];
    NSInteger index = 0;
    while (index < plainString.length)
    {
        NSTextCheckingResult *firstMatch = [regSpace firstMatchInString:plainString options:0 range:NSMakeRange(index, plainString.length-index)];
        if (firstMatch)
        {
            NSRange r = firstMatch.range;
            SSTextShape *shape = [SSTextShape shapeWithText:[plainString substringWithRange:r] range:r];
            [_shapes addObject:shape];
            index = r.location + r.length;
            continue;
        }
        
        firstMatch = [regLatin firstMatchInString:plainString options:0 range:NSMakeRange(index, plainString.length-index)];
        if (firstMatch)
        {
            NSRange r = firstMatch.range;
            SSTextShape *shape = [SSTextShape shapeWithText:[plainString substringWithRange:r] range:r];
            [_shapes addObject:shape];
            index = r.location + r.length;
            continue;
        }
        NSRange r = NSMakeRange(index, 1);
        SSTextShape *shape = [SSTextShape shapeWithText:[plainString substringWithRange:r] range:r];
        [_shapes addObject:shape];
        index = r.location + r.length;
    }
#ifdef SHOW_DEBUG
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"拆分字符串花%f毫秒：", endTime - startTime);
#endif
}

- (void) _parseShapesAttributes
{
#ifdef SHOW_DEBUG
    NSTimeInterval startTime = [[NSDate date] timeIntervalSince1970];
#endif
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedString);
    SSLayoutLine *layoutLine = [[SSLayoutLine alloc] initWithLine:line];
    
    NSArray *glyphIndexs = [layoutLine stringIndices];
    
    NSInteger glyphIndex = 0;
    NSInteger shapeIndex = 0;
    
    for (NSNumber *obj in glyphIndexs)
    {
        CGRect rect = [layoutLine frameOfGlyphAtIndex:glyphIndex];
        
        NSInteger glyphStart = [obj integerValue];
        
        SSTextShape *shape = [_shapes objectAtIndex:shapeIndex];
        NSRange range = shape.range;
        while (glyphStart >= range.location + range.length && shapeIndex < _shapes.count)
        {
            shapeIndex ++;
            shape = [_shapes objectAtIndex:shapeIndex];
            range = shape.range;
        }
        if (shapeIndex < _shapes.count)
        {
            //如果单个shape比视图宽度还宽，则拆分
            SSTextShape *shape = [_shapes objectAtIndex:shapeIndex];
            if (shape.width + rect.size.width <= _lineWidth) {
                shape.width += rect.size.width;
            } else {
                NSString *longText = shape.text;
                shape.text = [longText substringToIndex:glyphIndex - shape.range.location];
                shape.range = NSMakeRange(shape.range.location, shape.text.length);
                SSTextShape *newShape = [SSTextShape shapeWithText:[longText substringFromIndex:glyphIndex - shape.range.location]
                                                     range:NSMakeRange(glyphIndex, longText.length - (glyphIndex - shape.range.location))];
                [_shapes insertObject:newShape atIndex:shapeIndex + 1];
                newShape.width += rect.size.width;
            }
        }
        glyphIndex ++;
    }
    CFRelease(line);
    
    for (int i = 0; i < _shapes.count; i++)
    {
        SSTextShape *shape = [_shapes objectAtIndex:i];
        NSRange range = shape.range;
        NSDictionary *attributes = [_attributedString attributesAtIndex:range.location effectiveRange:&range];
        CTFontRef fontRef = (__bridge CTFontRef)[attributes objectForKey:(NSString *)kCTFontAttributeName];
        CGFloat fontSize = CTFontGetSize(fontRef);
        shape.fontSize = fontSize;
        shape.optimalKerning = self.optimalKerning * shape.fontSize;
    }
#ifdef SHOW_DEBUG
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"获取字符属性花%f毫秒：", endTime - startTime);
#endif
}


#pragma mark - properties


@synthesize shapes = _shapes;

@end
