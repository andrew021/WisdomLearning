//
//  SSLayouter.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class SSLayoutFrame;
@interface SSLayouter : NSObject

/**
 @name Creating a Layouter
 */

/**
 Designated Initializer. Creates a new Layouter with an attributed string
 @param attributedString The `NSAttributedString` to layout for
 @returns An initialized layouter
 */
- (id)initWithAttributedString:(NSAttributedString *)attributedString;

- (id)initWithAttributedString:(NSAttributedString *)attributedString frame:(CGRect)frame;

/**
 @name Creating Layout Frames
 */

/**
 Creates a layout frame with a given rectangle and string range. The layouter fills the layout frame with as many lines as fit. You can query [DTCoreTextLayoutFrame visibleStringRange] for the range the fits and create another layout frame that continues the text from there to create multiple pages, for example for an e-book.
 @param frame The rectangle to fill with text
 @param range The string range to fill, pass {0,0} for the entire string (as much as fits)
 */
- (SSLayoutFrame *)layoutFrameWithRect:(CGRect)frame range:(NSRange)range;

/**
 If set to `YES` then the receiver will cache layout frames generated with layoutFrameWithRect:range: for a given rect
 */
@property (nonatomic, assign) BOOL shouldCacheLayoutFrames;


/**
 @name Getting Information
 */

/**
 The attributed string that the layouter currently owns
 */
@property (nonatomic, strong) NSAttributedString *attributedString;

/**
 The internal framesetter of the receiver
 */
@property (nonatomic, readonly) CTFramesetterRef framesetter;

@property(nonatomic, strong, readonly) NSArray *lines;

@end
