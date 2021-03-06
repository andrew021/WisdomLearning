//
//  SSLayoutFrame+Selector.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLayoutFrame+Selector.h"
#import <DTRichTextEditor/DTTextPosition.h>
#import <DTRichTextEditor/DTTextRange.h>
#import <DTRichTextEditor/DTTextSelectionRect.h>
#import "SSLayoutFrame+Cursor.h"
#import "SSLayoutLine.h"


@implementation SSLayoutFrame (Selector)


- (CGRect)firstRectForRange:(NSRange)range
{
    NSArray *tmpRects = [self selectionRectsForRange:range];
    
    if (![tmpRects count])
    {
        return CGRectZero;
    }
    
    DTTextSelectionRect *firstRect = [tmpRects objectAtIndex:0];
    
    return firstRect.rect;
}

- (NSArray *)selectionRectsForRange:(NSRange)range
{
    NSInteger fromIndex = range.location;
    NSInteger toIndex = range.location + range.length;
    
    CGFloat fromCaretOffset = 0.0;
    CGFloat toCaretOffset = 0.0;
    
    BOOL haveStart = NO;
    BOOL haveEnd = NO;
    
    NSMutableArray *retArray = [NSMutableArray arrayWithCapacity:[self.lines count]];
    
    for (SSLayoutLine *oneLine in self.lines)
    {
        BOOL lineContainsStart = NO;
        BOOL lineContainsEnd = NO;
        
        if (NSLocationInRange(fromIndex, [oneLine stringRange]))
        {
            lineContainsStart = YES;
            haveStart = YES;
            
            fromCaretOffset = [oneLine offsetForStringIndex:fromIndex] + oneLine.frame.origin.x;
        }
        
        if (NSLocationInRange(toIndex, [oneLine stringRange]))
        {
            lineContainsEnd = YES;;
            haveEnd = YES;
            
            toCaretOffset = [oneLine offsetForStringIndex:toIndex] + oneLine.frame.origin.x;
        }
        
        CGRect rectToAddForThisLine = oneLine.frame;
        
        // continue looping through lines until we find the start
        if (!haveStart)
        {
            continue;
        }
        
        if (lineContainsStart)
        {
            if (lineContainsEnd)
            {
                rectToAddForThisLine = CGRectStandardize(CGRectMake(fromCaretOffset, oneLine.frame.origin.y, toCaretOffset - fromCaretOffset, oneLine.frame.size.height));
            }
            else
            {
                // ending after this line
                
                if (oneLine.writingDirectionIsRightToLeft)
                {
                    // extend to left side of line
                    rectToAddForThisLine = CGRectMake(oneLine.frame.origin.x, oneLine.frame.origin.y, fromCaretOffset - oneLine.frame.origin.x, oneLine.frame.size.height);
                }
                else
                {
                    // extend to right side of line
                    rectToAddForThisLine = CGRectMake(fromCaretOffset, oneLine.frame.origin.y, oneLine.frame.origin.x + self.frame.size.width - fromCaretOffset, oneLine.frame.size.height);
                }
            }
        }
        else
        {
            if (lineContainsEnd)
            {
                if (oneLine.writingDirectionIsRightToLeft)
                {
                    // extend to right side of line
                    rectToAddForThisLine = CGRectMake(toCaretOffset, oneLine.frame.origin.y, oneLine.frame.origin.x + self.frame.size.width - toCaretOffset, oneLine.frame.size.height);
                }
                else
                {
                    // extend to left side of line
                    rectToAddForThisLine = CGRectMake(oneLine.frame.origin.x, oneLine.frame.origin.y, toCaretOffset - oneLine.frame.origin.x, oneLine.frame.size.height);
                }
            }
        }
        
        // make new DTTextSelectionRect, was NSValue with CGRect before
        DTTextSelectionRect *selectionRect = [DTTextSelectionRect textSelectionRectWithRect:CGRectIntegral(rectToAddForThisLine)];
        
        selectionRect.containsStart = lineContainsStart;
        selectionRect.containsEnd = lineContainsEnd;
        
        [retArray addObject:selectionRect];
        
        if (haveStart && haveEnd)
        {
            // we're done
            break;
        }
    }
    
    if ([retArray count])
    {
        return retArray;
    }
    
    return nil;
}

- (NSInteger)indexForPositionUpwardsFromIndex:(NSInteger)index offset:(NSInteger)offset
{
    NSInteger lineIndex = [self lineIndexForGlyphIndex:index];
    NSInteger newLineIndex = lineIndex - offset;
    
    
    if (newLineIndex<0)
    {
        return NSNotFound;
    }
    
    CGRect currentRect = [self cursorRectAtIndex:index];
    
    SSLayoutLine *line = [self.lines objectAtIndex:newLineIndex];
    NSInteger closestIndex = [line stringIndexForPosition:CGPointMake(currentRect.origin.x, line.frame.origin.y)];
    
    // make sure that the index is inside the line
    if (!NSLocationInRange(closestIndex, line.stringRange))
    {
        closestIndex = MAX(0,NSMaxRange(line.stringRange)-1);
    }
    
    return closestIndex;
}

- (NSInteger)indexForPositionDownwardsFromIndex:(NSInteger)index offset:(NSInteger)offset
{
    NSInteger lineIndex = [self lineIndexForGlyphIndex:index];
    NSInteger newLineIndex = lineIndex + offset;
    
    if (newLineIndex >= [self.lines count])
    {
        return NSNotFound;
    }
    
    CGRect currentRect = [self cursorRectAtIndex:index];
    
    SSLayoutLine *line = [self.lines objectAtIndex:newLineIndex];
    NSInteger closestIndex = [line stringIndexForPosition:CGPointMake(currentRect.origin.x, line.frame.origin.y)];
    
    // make sure that the index is inside the line
    if (!NSLocationInRange(closestIndex, line.stringRange))
    {
        closestIndex = MAX(0,NSMaxRange(line.stringRange)-1);
    }
    
    return closestIndex;
}

@end
