//
//  SSGlyphRun.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <DTCoreText.h>

@class SSLayoutLine;
@interface SSGlyphRun : NSObject

{
    NSRange _stringRange;
}

- (id)initWithRun:(CTRunRef)run layoutLine:(SSLayoutLine *)layoutLine offset:(CGFloat)offset;

- (void)drawInContext:(CGContextRef)context;

/**
 Draws the receiver's decoration into the given context with the position that it derives from the layout line it belongs to. Decoration is background highlighting, underline and strike-through.
 @param context The graphics context to draw into
 */
- (void)drawDecorationInContext:(CGContextRef)context;



/**
 Creates a `CGPath` containing the shapes of all glyphs in the receiver
 */
- (CGPathRef)newPathWithGlyphs;


/**
 @name Getting Information
 */

/**
 Determines the frame of a specific glyph
 @param index The index of the glyph
 @return The frame of the glyph
 */
- (CGRect)frameOfGlyphAtIndex:(NSInteger)index;


/**
 The bounds of an image encompassing the entire run.
 @param context The graphics context used for the measurement
 @returns The rectangle containing the result
 */
- (CGRect)imageBoundsInContext:(CGContextRef)context;


/**
 The string range (of the attributed string) that is represented by the receiver
 @returns The range
 */
- (NSRange)stringRange;


/**
 The string indices of the receiver
 @returns An array of string indices
 */
- (NSArray *)stringIndices;

/**
 The frame rectangle of the glyph run, relative to the layout frame coordinate system
 */
@property (nonatomic, readonly) CGRect frame;

/**
 The number of glyphs that the receiver is made up of
 */
@property (nonatomic, readonly) NSInteger numberOfGlyphs;

/**
 The Core Text attributes that are shared by all gylphs of the receiver
 */
@property (nonatomic, readonly) NSDictionary *attributes;

/**
 Returns `YES` if the receiver is part of a hyperlink, `NO` otherwise
 */
@property (nonatomic, assign, readonly, getter=isHyperlink) BOOL hyperlink;

/**
 Returns `YES` if the receiver represents trailing whitespace in a line.
 
 This can be used to avoid drawing of background color, strikeout or underline for empty trailing white space glyph runs.
 */
- (BOOL)isTrailingWhitespace;

/**
 The ascent (height above the baseline) of the receiver
 */
@property (nonatomic, readonly) CGFloat ascent;

/**
 The descent (height below the baseline) of the receiver
 */
@property (nonatomic, readonly) CGFloat descent;

/**
 The leading (additional space above the ascent) of the receiver
 */
@property (nonatomic, readonly) CGFloat leading;

/**
 The width of the receiver
 */
@property (nonatomic, readonly) CGFloat width;

/**
 `YES` if the writing direction is Right-to-Left, otherwise `NO`
 */
@property (nonatomic, readonly) BOOL writingDirectionIsRightToLeft;

/**
 The text attachment of the receiver, or `nil` if there is none
 */
@property (nonatomic, readonly) DTTextAttachment *attachment;

@end
