//
//  SSLayoutFrame+Cursor.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLayoutFrame.h"

@interface SSLayoutFrame (Cursor)

/**
 Determines the closest string index to a point in the receiver's frame.
 
 This can be used to find the cursor position to position an input caret at.
 @param point The point
 @returns The resulting string index
 */
- (NSInteger)closestCursorIndexToPoint:(CGPoint)point;

/**
 The rectangle to draw a caret for a given index
 @param index The string index for which to determine a cursor frame
 @returns The cursor rectangle
 */
- (CGRect)cursorRectAtIndex:(NSInteger)index;

@end
