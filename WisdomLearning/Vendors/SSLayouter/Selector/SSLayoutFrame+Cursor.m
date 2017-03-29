//
//  SSLayoutFrame+Cursor.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLayoutFrame+Cursor.h"
#import "SSLayoutLine.h"

@implementation SSLayoutFrame (Cursor)


- (NSInteger)closestCursorIndexToPoint:(CGPoint)point
{
    NSArray *lines = self.lines;
    
    if (![lines count])
    {
        return NSNotFound;
    }
    
    SSLayoutLine *firstLine = [lines objectAtIndex:0];
    if (point.y < CGRectGetMinY(firstLine.frame))
    {
        return 0;
    }
    
    SSLayoutLine *lastLine = [lines lastObject];
    if (point.y > CGRectGetMaxY(lastLine.frame))
    {
        NSRange stringRange = [self visibleStringRange];
        
        if (stringRange.length)
        {
            return NSMaxRange([self visibleStringRange])-1;
        }
    }
    
    // find closest line
    SSLayoutLine *closestLine = nil;
    CGFloat closestDistance = CGFLOAT_MAX;
    
    for (SSLayoutLine *oneLine in lines)
    {
        // line contains point
        if (CGRectGetMinY(oneLine.frame) <= point.y && CGRectGetMaxY(oneLine.frame) >= point.y)
        {
            closestLine = oneLine;
            break;
        }
        
        CGFloat top = CGRectGetMinY(oneLine.frame);
        CGFloat bottom = CGRectGetMaxY(oneLine.frame);
        
        CGFloat distance = CGFLOAT_MAX;
        
        if (top > point.y)
        {
            distance = top - point.y;
        }
        else if (bottom < point.y)
        {
            distance = point.y - bottom;
        }
        
        if (distance < closestDistance)
        {
            closestLine = oneLine;
            closestDistance = distance;
        }
    }
    
    if (!closestLine)
    {
        return NSNotFound;
    }
    
    NSInteger closestIndex = [closestLine stringIndexForPosition:point];
    
    NSInteger maxIndex = NSMaxRange([closestLine stringRange])-1;
    
    if (closestIndex > maxIndex)
    {
        closestIndex = maxIndex;
    }
    
    if (closestIndex>=0)
    {
        return closestIndex;
    }
    
    return NSNotFound;
}

- (CGRect)cursorRectAtIndex:(NSInteger)index
{
    SSLayoutLine *line = [self lineContainingIndex:index];
    
    if (!line)
    {
        return CGRectZero;
    }
    
    CGFloat offset = [line offsetForStringIndex:index];
    
    CGRect rect = line.frame;
    rect.size.width = 3.0;
    rect.origin.x += offset;
    
    return rect;
}

@end
