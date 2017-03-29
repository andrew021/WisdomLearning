//
//  SSLayoutFrame.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <DTCoreText.h>

@class SSLayoutLine;
@class SSLayouter;

typedef void (^SSLayoutFrameTextBlockHandler)(DTTextBlock *textBlock, CGRect frame, CGContextRef context, BOOL * shouldDrawDefaultBackground);

typedef NS_ENUM(NSUInteger, SSLayoutFrameDrawingOptions){
    SSLayoutFrameDrawingOptionsDefault = 1<<0,
    SSLayoutFrameDrawingOptionsOmitLinks = 1<<1,
    SSLayoutFrameDrawingOptionsOmitAttachments = 1<<2,
    SSLayoutFrameDrawingOptionsDrawLinksHighlighted = 1<<3
};

@interface SSLayoutFrame : NSObject

{
    CGRect _frame;
    
    NSMutableArray *_lines;
    NSArray *_paragraphRanges;
    
    NSArray *_textAttachments;
    NSMutableAttributedString *_attributedStringFragment;
}

@property(nonatomic, assign, readonly) CGRect frame;
@property (nonatomic, copy) SSLayoutFrameTextBlockHandler textBlockHandler;
@property (nonatomic, strong, readonly) NSArray *lines;
@property (nonatomic, readwrite) CGFloat justifyRatio;
@property (nonatomic, strong, readonly) NSArray *paragraphRanges;
@property(nonatomic, assign) NSInteger numberOfLines;
@property(nonatomic, assign) NSLineBreakMode lineBreakMode;
@property(nonatomic, strong) NSAttributedString *truncationString;


- (id)initWithFrame:(CGRect)frame layouter:(SSLayouter *)layouter;

- (id)initWithFrame:(CGRect)frame layouter:(SSLayouter *)layouter range:(NSRange)range;

- (NSRange)visibleStringRange;

- (NSMutableAttributedString *)attributedStringFragment;

- (NSArray *)stringIndices;

- (CGRect) intrinsicContentFrame;

- (void)drawInContext:(CGContextRef)context options:(SSLayoutFrameDrawingOptions)options;



#pragma mark - Working with Glyphs
- (NSInteger)lineIndexForGlyphIndex:(NSInteger)index;

- (CGRect)frameOfGlyphAtIndex:(NSInteger)index;

/**
 The text lines that are visible inside the given rectangle. Also incomplete lines are included.
 
 @param rect The rectangle
 @returns An array, sorted from top to bottom, of lines at least partially visible
 */
- (NSArray *)linesVisibleInRect:(CGRect)rect;

/**
 The text lines that are visible inside the given rectangle. Only fully visible lines are included.
 
 @param rect The rectangle
 @returns An array, sorted from top to bottom, of lines fully visible
 */
- (NSArray *)linesContainedInRect:(CGRect)rect;

/**
 The layout line that contains the given string index.
 
 @param index The string index
 @returns The layout line that this index belongs to
 */
- (SSLayoutLine *)lineContainingIndex:(NSUInteger)index;

/**
 Determins if the given line is the first in a paragraph.
 
 This is needed for example to determine whether paragraphSpaceBefore needs to be applied before it.
 @param line The Line
 @returns `YES` if the given line is the first in a paragraph
 */
- (BOOL)isLineFirstInParagraph:(SSLayoutLine *)line;

/**
 Determins if the given line is the last in a paragraph.
 
 This is needed for example to determine whether paragraph spacing needs to be applied after it.
 @param line The Line
 @returns `YES` if the given line is the last in a paragraph
 */
- (BOOL)isLineLastInParagraph:(SSLayoutLine *)line;

- (NSArray *)textAttachments;
- (NSArray *)textAttachmentsWithPredicate:(NSPredicate *)predicate;
- (NSUInteger)paragraphIndexContainingStringIndex:(NSUInteger)stringIndex;
- (NSRange)paragraphRangeContainingStringRange:(NSRange)stringRange;

#pragma mark - Debugging
/**
 Switches on the debug drawing mode where individual glph runs, baselines, et ceter get individually marked.
 
 @param debugFrames if the debug drawing should occur
 */
+ (void)setShouldDrawDebugFrames:(BOOL)debugFrames;


/**
 @returns the current value of the debug frame drawing
 */
+ (BOOL)shouldDrawDebugFrames;

@end
