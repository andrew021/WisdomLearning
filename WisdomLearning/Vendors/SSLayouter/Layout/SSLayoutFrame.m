//
//  SSLayoutFrame.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLayoutFrame.h"
#import "SSLayouter.h"
#import "SSLayoutLine.h"
#import "SSLineBreaker.h"
#import "SSGlyphRun.h"
#import "SSLayouterConfig.h"

static BOOL _SSLayoutFramesShouldDrawDebugFrames = NO;

@implementation SSLayoutFrame
{
    CTFrameRef _textFrame;
    CTFramesetterRef _framesetter;
    
    NSRange _requestedStringRange;
    NSRange _stringRange;
    
    CGFloat _additionalPaddingAtBottom;		// when last line in a text block with padding
    
    NSInteger _numberLinesFitInFrame;
    SSLayoutFrameTextBlockHandler _textBlockHandler;
    
    CGFloat _longestLayoutLineWidth;
    
    
    //add
    SSLineBreaker *_slb;
}


// makes a frame for a specific part of the attributed string of the layouter
- (id)initWithFrame:(CGRect)frame layouter:(SSLayouter *)layouter range:(NSRange)range
{
    self = [super init];
    
    if (self)
    {
        _frame = frame;
        
        _attributedStringFragment = [layouter.attributedString mutableCopy];
        
        // determine correct target range
        _requestedStringRange = range;
        NSUInteger stringLength = [_attributedStringFragment length];
        
        if (_requestedStringRange.location >= stringLength)
        {
            return nil;
        }
        
        if (_requestedStringRange.length==0 || NSMaxRange(_requestedStringRange) > stringLength)
        {
            _requestedStringRange.length = stringLength - _requestedStringRange.location;
        }
        
        CFRange cfRange = CFRangeMake(_requestedStringRange.location, _requestedStringRange.length);
        _framesetter = layouter.framesetter;
        
        if (_framesetter)
        {
            CFRetain(_framesetter);
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddRect(path, NULL, frame);
            
            _textFrame = CTFramesetterCreateFrame(_framesetter, cfRange, path, NULL);
            
            CGPathRelease(path);
        }
        else
        {
            // Strange, should have gotten a valid framesetter
            return nil;
        }
        
        _justifyRatio = 0.6f;
    }
    
    return self;
}

// makes a frame for the entire attributed string of the layouter
- (id)initWithFrame:(CGRect)frame layouter:(SSLayouter *)layouter
{
    return [self initWithFrame:frame layouter:layouter range:NSMakeRange(0, 0)];
}

- (void)dealloc
{
    if (_textFrame)
    {
        CFRelease(_textFrame);
    }
    
    if (_framesetter)
    {
        CFRelease(_framesetter);
    }
}

#pragma mark - Positioning Lines

// determins the "half leading"
- (CGFloat)_algorithmWebKit_halfLeadingOfLine:(SSLayoutLine *)line
{
    CGFloat maxFontSize = [line lineHeight];
    
    DTCoreTextParagraphStyle *paragraphStyle = [line paragraphStyle];
    
    if (paragraphStyle.minimumLineHeight && paragraphStyle.minimumLineHeight > maxFontSize)
    {
        maxFontSize = paragraphStyle.minimumLineHeight;
    }
    
    if (paragraphStyle.maximumLineHeight && paragraphStyle.maximumLineHeight < maxFontSize)
    {
        maxFontSize = paragraphStyle.maximumLineHeight;
    }
    
    CGFloat leading;
    
    if (paragraphStyle.lineHeightMultiple > 0)
    {
        leading = maxFontSize * paragraphStyle.lineHeightMultiple;
    }
    else
    {
        // reasonable "normal"
        leading = maxFontSize * 1.1f;
    }
    
    // subtract inline box height
    CGFloat inlineBoxHeight = line.ascent + line.descent;
    
    return (leading - inlineBoxHeight)/2.0f;
}


- (CGPoint)_algorithmWebKit_BaselineOriginToPositionLine:(SSLayoutLine *)line afterLine:(SSLayoutLine *)previousLine
{
    CGPoint baselineOrigin = previousLine.baselineOrigin;
    
    if (previousLine)
    {
        baselineOrigin.y = CGRectGetMaxY(previousLine.frame);
        
        CGFloat halfLeadingFromText = [self _algorithmWebKit_halfLeadingOfLine:previousLine];
        
        if (previousLine.attachments)
        {
            // only add half leading if there are no attachments, this prevents line from being shifted up due to negative half leading
            if (halfLeadingFromText>0)
            {
                baselineOrigin.y += halfLeadingFromText;
            }
        }
        else
        {
            baselineOrigin.y += halfLeadingFromText;
        }
        
        // add previous line's after paragraph spacing
        if ([self isLineLastInParagraph:previousLine])
        {
            DTCoreTextParagraphStyle *paragraphStyle = [previousLine paragraphStyle];
            baselineOrigin.y += paragraphStyle.paragraphSpacing;
        }
    }
    else
    {
        // first line in frame
        baselineOrigin = _frame.origin;
    }
    
    baselineOrigin.y += line.ascent;
    
    CGFloat halfLeadingFromText = [self _algorithmWebKit_halfLeadingOfLine:line];
    
    if (line.attachments)
    {
        // only add half leading if there are no attachments, this prevents line from being shifted up due to negative half leading
        if (halfLeadingFromText>0)
        {
            baselineOrigin.y += halfLeadingFromText;
        }
    }
    else
    {
        baselineOrigin.y += halfLeadingFromText;
    }
    
    DTCoreTextParagraphStyle *paragraphStyle = [line paragraphStyle];
    
    // add current line's before paragraph spacing
    if ([self isLineFirstInParagraph:line])
    {
        baselineOrigin.y += paragraphStyle.paragraphSpacingBefore;
    }
    
    // add padding for closed text blocks
    for (DTTextBlock *previousTextBlock in previousLine.textBlocks)
    {
        if (![line.textBlocks containsObject:previousTextBlock])
        {
            baselineOrigin.y  += previousTextBlock.padding.bottom;
        }
    }
    
    // add padding for newly opened text blocks
    for (DTTextBlock *currentTextBlock in line.textBlocks)
    {
        if (![previousLine.textBlocks containsObject:currentTextBlock])
        {
            baselineOrigin.y  += currentTextBlock.padding.top;
        }
    }
    
    // origins are rounded
    baselineOrigin.y = ceil(baselineOrigin.y);
    
    return baselineOrigin;
}


#pragma mark - Building the Lines

/*
 Builds the array of lines with the internal typesetter of our framesetter. No need to correct line origins in this case because they are placed correctly in the first place. This version supports text boxes.
 */
- (void)_buildLinesWithTypesetter
{
    if (!_slb) {
        _slb = [SSLineBreaker lineBreakerWithOptimalKerning:[[SSLayouterConfig shared] getKerning]];
    }
    
    SSLayoutLine *previousLine = nil;
    CGFloat lineBottom;
    
    NSMutableArray *paragraphRanges = [[self paragraphRanges] mutableCopy];
    NSRange currentParagraphRange = [[paragraphRanges objectAtIndex:0] rangeValue];
    
    NSArray *linesRangeArray = [_slb linesBreakAndUpdate:&_attributedStringFragment
                                               lineWidth:_frame.size.width
                                         paragraphRanges:[self.paragraphRanges mutableCopy]];
    
    _lines = [[NSMutableArray alloc] init];
    
    for (NSValue *v in linesRangeArray) {
        
        NSRange lineRange = [v rangeValue];
        CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)[_attributedStringFragment attributedSubstringFromRange:lineRange]);
        
        if (!line)
        {
            continue;
        }
        
        SSLayoutLine *newLine = [[SSLayoutLine alloc] initWithLine:line stringLocationOffset:lineRange.location];
        
        while (lineRange.location >= (currentParagraphRange.location+currentParagraphRange.length))
        {
            // we are outside of this paragraph, so we go to the next
            [paragraphRanges removeObjectAtIndex:0];
            
            currentParagraphRange = [[paragraphRanges objectAtIndex:0] rangeValue];
        }
        
        BOOL isAtBeginOfParagraph = (currentParagraphRange.location == lineRange.location);
        
        CGFloat headIndent = 0;
        CGFloat tailIndent = 0;
        
        // get the paragraph style at this index
        CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[_attributedStringFragment attribute:(id)kCTParagraphStyleAttributeName atIndex:lineRange.location effectiveRange:NULL];
        
        if (isAtBeginOfParagraph)
        {
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(headIndent), &headIndent);
        }
        else
        {
            CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierHeadIndent, sizeof(headIndent), &headIndent);
        }
        
        CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierTailIndent, sizeof(tailIndent), &tailIndent);
        
        // add left padding to offset
        CGFloat lineOriginX;
        CGFloat availableSpace;
        
        NSArray *textBlocks = [_attributedStringFragment attribute:DTTextBlocksAttribute atIndex:lineRange.location effectiveRange:NULL];
        CGFloat totalLeftPadding = 0;
        CGFloat totalRightPadding = 0;
        
        for (DTTextBlock *oneTextBlock in textBlocks)
        {
            totalLeftPadding += oneTextBlock.padding.left;
            totalRightPadding += oneTextBlock.padding.right;
            
        }
        
        
        if (tailIndent <= 0)
        {
            // negative tail indent is measured from trailing margin (we assume LTR here)
            availableSpace = _frame.size.width - headIndent - totalRightPadding + tailIndent - totalLeftPadding;
        }
        else
        {
            availableSpace = tailIndent - headIndent - totalLeftPadding - totalRightPadding;
        }
        
        
        CGFloat offset = totalLeftPadding;
        
        // if first character is a tab, then it is positioned without the indentation
        if (![[[_attributedStringFragment string] substringWithRange:NSMakeRange(lineRange.location, 1)] isEqualToString:@"\t"])
        {
            offset += headIndent;
        }
        
        // adjust lineOrigin based on paragraph text alignment
        CTTextAlignment textAlignment;
        
        CGFloat currentLineWidth = (CGFloat)CTLineGetTypographicBounds(line, NULL, NULL, NULL);
        
        if (!CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierAlignment, sizeof(textAlignment), &textAlignment))
        {
            textAlignment = kCTNaturalTextAlignment;
        }
        
        // determine writing direction
        BOOL isRTL = NO;
        CTWritingDirection baseWritingDirection;
        
        if (CTParagraphStyleGetValueForSpecifier(paragraphStyle, kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(baseWritingDirection), &baseWritingDirection))
        {
            isRTL = (baseWritingDirection == kCTWritingDirectionRightToLeft);
        }
        else
        {
            baseWritingDirection = kCTWritingDirectionNatural;
        }
        
        switch (textAlignment)
        {
            case kCTLeftTextAlignment:
            {
                lineOriginX = _frame.origin.x + offset;
                // nothing to do
                break;
            }
                
            case kCTNaturalTextAlignment:
            {
                lineOriginX = _frame.origin.x + offset;
                
                if (baseWritingDirection != kCTWritingDirectionRightToLeft)
                {
                    break;
                }
                
                // right alignment falls through
            }
                
            case kCTRightTextAlignment:
            {
                lineOriginX = _frame.origin.x + offset + (CGFloat)CTLineGetPenOffsetForFlush(line, 1.0, availableSpace);
                
                break;
            }
                
            case kCTCenterTextAlignment:
            {
                CGFloat penOffset =  (CGFloat)CTLineGetPenOffsetForFlush(line, 0.5, availableSpace);
                if(penOffset>0 && offset>0) {
                    penOffset += offset/2;
                }
                lineOriginX = _frame.origin.x + offset + penOffset;
                
                break;
            }
                
            case kCTJustifiedTextAlignment:
            {
                BOOL isAtEndOfParagraph  = (currentParagraphRange.location+currentParagraphRange.length <= lineRange.location+lineRange.length ||
                                            [[_attributedStringFragment string] characterAtIndex:lineRange.location+lineRange.length-1]==0x2028);
                
                // only justify if not last line, not <br>, and if the line width is longer than _justifyRatio of the frame
                // avoids over-stretching
                if( !isAtEndOfParagraph && (currentLineWidth > _justifyRatio * _frame.size.width) )
                {
                    // create a justified line and replace the current one with it
                    CTLineRef justifiedLine = CTLineCreateJustifiedLine(line, 1.0f, availableSpace);
                    
                    // CTLineCreateJustifiedLine sometimes fails if the line ends with 0x00AD (soft hyphen) and contains cyrillic chars
                    if (justifiedLine)
                    {
                        CFRelease(line);
                        line = justifiedLine;
                    }
                }
                
                if (isRTL)
                {
                    // align line with right margin
                    lineOriginX = _frame.origin.x + offset + (CGFloat)CTLineGetPenOffsetForFlush(line, 1.0, availableSpace);
                }
                else
                {
                    // align line with left margin
                    lineOriginX = _frame.origin.x + offset;
                }
                break;
            }
        }
        CFRelease(line);
        
        if (newLine.attachments && newLine.attachments.count > 0) {
            lineOriginX -= headIndent;
        }
        
        
        newLine.writingDirectionIsRightToLeft = isRTL;
        // determine position of line based on line before it
        
        CGPoint newLineBaselineOrigin = [self _algorithmWebKit_BaselineOriginToPositionLine:newLine afterLine:previousLine];
        
        newLineBaselineOrigin.x = lineOriginX;
        //		NSLog(@"origin: %@", NSStringFromCGPoint(newLineBaselineOrigin));
        newLine.baselineOrigin = newLineBaselineOrigin;
        
        // abort layout if we left the configured frame
        //		lineBottom = CGRectGetMaxY(newLine.frame);
        
        [_lines addObject:newLine];
        
        previousLine = newLine;
        
    }
    
    SSLayoutLine *lastLine = [_lines lastObject];
    
    lineBottom = CGRectGetMaxY(lastLine.frame);
    
    _frame.size.height = lineBottom;
    
    
}


- (void)_buildLines
{
    // only build lines if frame is legal
    if (_frame.size.width<=0)
    {
        return;
    }
    
    // note: building line by line with typesetter
    [self _buildLinesWithTypesetter];
    
    //[self _buildLinesWithStandardFramesetter];
}

- (NSArray *)lines
{
    if (!_lines)
    {
        [self _buildLines];
    }
    
    return _lines;
}

- (NSArray *)linesVisibleInRect:(CGRect)rect
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self.lines count]];
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    for (SSLayoutLine *oneLine in self.lines)
    {
        CGRect lineFrame = oneLine.frame;
        
        // lines before the rect
        if (CGRectGetMaxY(lineFrame) < minY)
        {
            // skip
            continue;
        }
        
        // line is after the rect
        if (lineFrame.origin.y > maxY)
        {
            break;
        }
        
        // CGRectIntersectsRect returns false if the frame has 0 width, which
        // lines that consist only of line-breaks have. Set the min-width
        // to one to work-around.
        lineFrame.size.width = lineFrame.size.width > 1 ? lineFrame.size.width : 1;
        
        if (CGRectIntersectsRect(rect, lineFrame))
        {
            [tmpArray addObject:oneLine];
        }
    }
    
    return tmpArray;
}

- (NSArray *)linesContainedInRect:(CGRect)rect
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:[self.lines count]];
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    for (SSLayoutLine *oneLine in self.lines)
    {
        CGRect lineFrame = oneLine.frame;
        
        // lines before the rect
        if (CGRectGetMaxY(lineFrame)<minY)
        {
            // skip
            continue;
        }
        
        // line is after the rect
        if (lineFrame.origin.y > maxY)
        {
            break;
        }
        
        if (CGRectContainsRect(rect, lineFrame))
        {
            [tmpArray addObject:oneLine];
        }
    }
    
    return tmpArray;
}



#pragma mark - Text Block Helpers

// determines the frame to use for a text block with a given effect range at a specific block level
- (CGRect)_blockFrameForEffectiveRange:(NSRange)effectiveRange level:(NSUInteger)level
{
    CGRect blockFrame;
    
    // we know extent of block, get frame
    SSLayoutLine *firstBlockLine = [self lineContainingIndex:effectiveRange.location];
    SSLayoutLine *lastBlockLine = [self lineContainingIndex:NSMaxRange(effectiveRange)-1];
    
    // start with frame spanned from these lines
    blockFrame.origin = firstBlockLine.frame.origin;
    blockFrame.origin.x = _frame.origin.x;
    blockFrame.size.width = _frame.size.width;
    blockFrame.size.height = CGRectGetMaxY(lastBlockLine.frame) - blockFrame.origin.y;
    
    // top paddings we get from first line
    for (NSInteger i = [firstBlockLine.textBlocks count]-1; i>=level;i--)
    {
        if (i < 0)
        {
            break;
        }
        
        DTTextBlock *oneTextBlock = [firstBlockLine.textBlocks objectAtIndex:i];
        
        blockFrame.origin.y -= oneTextBlock.padding.top;
        blockFrame.size.height += oneTextBlock.padding.top;
    }
    
    // top padding we get from last line
    for (NSInteger i = [lastBlockLine.textBlocks count]-1; i>=level;i--)
    {
        if (i<0)
        {
            break;
        }
        
        DTTextBlock *oneTextBlock = [lastBlockLine.textBlocks objectAtIndex:i];
        
        blockFrame.size.height += oneTextBlock.padding.bottom;
    }
    
    // adjust left and right margins with block stack padding
    for (int i=0; i<level; i++)
    {
        DTTextBlock *textBlock = [firstBlockLine.textBlocks objectAtIndex:i];
        
        blockFrame.origin.x += textBlock.padding.left;
        blockFrame.size.width -= (textBlock.padding.left + textBlock.padding.right);
    }
    
    return CGRectIntegral(blockFrame);
}

// only enumerate blocks at a given level
// returns YES if there was at least one block enumerated at this level
- (BOOL)_enumerateTextBlocksAtLevel:(NSUInteger)level inRange:(NSRange)range usingBlock:(void (^)(DTTextBlock *textBlock, CGRect frame, NSRange effectiveRange, BOOL *stop))block
{
    NSParameterAssert(block);
    
    // synchronize globally to work around crashing bug in iOS accessing attributes concurrently in 2 separate layout frames, with separate attributed strings, but coming from same layouter.
    @synchronized((__bridge id)_framesetter)
    {
        NSUInteger length = [_attributedStringFragment length];
        NSUInteger index = range.location;
        
        BOOL foundBlockAtLevel = NO;
        
        while (index<NSMaxRange(range))
        {
            NSRange textBlocksArrayRange;
            NSArray *textBlocks = [_attributedStringFragment attribute:DTTextBlocksAttribute atIndex:index longestEffectiveRange:&textBlocksArrayRange inRange:range];
            
            index += textBlocksArrayRange.length;
            
            if ([textBlocks count] <= level)
            {
                // has no blocks at this level
                continue;
            }
            
            foundBlockAtLevel = YES;
            
            // find extent of outermost block
            DTTextBlock *blockAtLevelToHandle = [textBlocks objectAtIndex:level];
            
            NSUInteger searchIndex = NSMaxRange(textBlocksArrayRange);
            
            NSRange currentBlockEffectiveRange = textBlocksArrayRange;
            
            // search forward for actual end of block
            while (searchIndex < length && searchIndex < NSMaxRange(range))
            {
                NSRange laterBlocksRange;
                NSArray *laterBlocks = [_attributedStringFragment attribute:DTTextBlocksAttribute atIndex:searchIndex longestEffectiveRange:&laterBlocksRange inRange:range];
                
                if (![laterBlocks containsObject:blockAtLevelToHandle])
                {
                    break;
                }
                
                currentBlockEffectiveRange = NSUnionRange(currentBlockEffectiveRange, laterBlocksRange);
                
                searchIndex = NSMaxRange(laterBlocksRange);
            }
            
            index = searchIndex;
            CGRect blockFrame = [self _blockFrameForEffectiveRange:currentBlockEffectiveRange level:level];
            
            BOOL shouldStop = NO;
            
            block(blockAtLevelToHandle, blockFrame, currentBlockEffectiveRange, &shouldStop);
            
            if (shouldStop)
            {
                return YES;
            }
        }
        
        return foundBlockAtLevel;
    }
}


// enumerates the text blocks in effect for a given string range
- (void)_enumerateTextBlocksInRange:(NSRange)range usingBlock:(void (^)(DTTextBlock *textBlock, CGRect frame, NSRange effectiveRange, BOOL *stop))block
{
    __block NSUInteger level = 0;
    
    while ([self _enumerateTextBlocksAtLevel:level inRange:range usingBlock:block])
    {
        level++;
    }
}

#pragma mark - Drawing

// draw and individual text block to a graphics context and frame
- (void)_drawTextBlock:(DTTextBlock *)textBlock inContext:(CGContextRef)context frame:(CGRect)frame
{
    BOOL shouldDrawStandardBackground = YES;
    if (_textBlockHandler)
    {
        _textBlockHandler(textBlock, frame, context, &shouldDrawStandardBackground);
    }
    
    // draw standard background if necessary
    if (shouldDrawStandardBackground)
    {
        if (textBlock.backgroundColor)
        {
            CGColorRef color = [textBlock.backgroundColor CGColor];
            CGContextSetFillColorWithColor(context, color);
            CGContextFillRect(context, frame);
        }
    }
    
    if (_SSLayoutFramesShouldDrawDebugFrames)
    {
        CGContextSaveGState(context);
        
        // draw line bounds
        CGContextSetRGBStrokeColor(context, 0.5, 0, 0.5f, 1.0f);
        CGContextSetLineWidth(context, 2);
        CGContextStrokeRect(context, CGRectInset(frame, 2, 2));
        
        CGContextRestoreGState(context);
    }
}

// draws the text blocks that should be visible within the mentioned range and inside the clipping rect of the context
- (void)_drawTextBlocksInContext:(CGContextRef)context inRange:(NSRange)range
{
    CGRect clipRect = CGContextGetClipBoundingBox(context);
    
    [self _enumerateTextBlocksInRange:range usingBlock:^(DTTextBlock *textBlock, CGRect frame, NSRange effectiveRange, BOOL *stop) {
        
        CGRect visiblePart = CGRectIntersection(frame, clipRect);
        
        // do not draw boxes which are not in the current clip rect
        if (!CGRectIsInfinite(visiblePart))
        {
            [self _drawTextBlock:textBlock inContext:context frame:frame];
        }
    }];
}

- (void)_setShadowInContext:(CGContextRef)context fromDictionary:(NSDictionary *)dictionary additionalOffset:(CGSize)additionalOffset
{
    DTColor *color = [dictionary objectForKey:@"Color"];
    CGSize offset = [[dictionary objectForKey:@"Offset"] CGSizeValue];
    CGFloat blur = [[dictionary objectForKey:@"Blur"] floatValue];
    
    // add extra offset
    offset.width += additionalOffset.width;
    offset.height += additionalOffset.height;
    
    CGFloat scaleFactor = 1.0;
    
#if TARGET_OS_IPHONE
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        scaleFactor = [[UIScreen mainScreen] scale];
    }
#endif
    
    
    // workaround for scale 1: strangely offset (1,1) with blur 0 does not draw any shadow, (1.01,1.01) does
    if (scaleFactor==1.0)
    {
        if (fabs(offset.width)==1.0)
        {
            offset.width *= 1.50;
        }
        
        if (fabs(offset.height)==1.0)
        {
            offset.height *= 1.50;
        }
    }
    
    CGContextSetShadowWithColor(context, offset, blur, color.CGColor);
}

// draws the HR represented by the layout line
- (void)_drawHorizontalRuleFromLine:(DTCoreTextLayoutLine *)line inContext:(CGContextRef)context
{
    // HR has only a single glyph run with a \n, but that has all the attributes
    DTCoreTextGlyphRun *oneRun = [line.glyphRuns lastObject];
    
    NSDictionary *ruleStyle = [oneRun.attributes objectForKey:DTHorizontalRuleStyleAttribute];
    
    if (!ruleStyle)
    {
        return;
    }
    
    DTColor *color = [oneRun.attributes foregroundColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    
    CGRect nrect = self.frame;
    nrect.origin = line.frame.origin;
    nrect.size.height = oneRun.frame.size.height;
    nrect.origin.y = round(nrect.origin.y + oneRun.frame.size.height/2.0f)+0.5f;
    
    DTTextBlock *textBlock = [[oneRun.attributes objectForKey:DTTextBlocksAttribute] lastObject];
    
    if (textBlock)
    {
        // apply horizontal padding
        nrect.size.width = _frame.size.width - textBlock.padding.left - textBlock.padding.right;
    }
    
    CGContextMoveToPoint(context, nrect.origin.x, nrect.origin.y);
    CGContextAddLineToPoint(context, nrect.origin.x + nrect.size.width, nrect.origin.y);
    
    CGContextStrokePath(context);
}

- (void)drawInContext:(CGContextRef)context drawImages:(BOOL)drawImages drawLinks:(BOOL)drawLinks
{
    SSLayoutFrameDrawingOptions options = SSLayoutFrameDrawingOptionsDefault;
    
    if (!drawImages)
    {
        options |= SSLayoutFrameDrawingOptionsOmitAttachments;
    }
    
    if (!drawLinks)
    {
        options |= SSLayoutFrameDrawingOptionsOmitLinks;
    }
    
    [self drawInContext:context options:options];
}

// sets the text foreground color based on the glyph run and drawing options
- (void)_setForgroundColorInContext:(CGContextRef)context forGlyphRun:(SSGlyphRun *)glyphRun options:(SSLayoutFrameDrawingOptions)options
{
    UIColor *color = nil;
    
    BOOL needsToSetFillColor = [[glyphRun.attributes objectForKey:(id)kCTForegroundColorFromContextAttributeName] boolValue];
    
    if (glyphRun.isHyperlink)
    {
        if (options & SSLayoutFrameDrawingOptionsDrawLinksHighlighted)
        {
            color = [glyphRun.attributes objectForKey:DTLinkHighlightColorAttribute];
        }
    }
    
    if (!color)
    {
        // get text color or use black
        color = [glyphRun.attributes foregroundColor];
    }
    
    // set fill for text that uses kCTForegroundColorFromContextAttributeName
    if (needsToSetFillColor)
    {
        CGContextSetFillColorWithColor(context, color.CGColor);
    }
    
    // set stroke for lines
    CGContextSetStrokeColorWithColor(context, color.CGColor);
}


#pragma mark - 绘制
- (void)drawInContext:(CGContextRef)context options:(SSLayoutFrameDrawingOptions)options
{
    BOOL drawLinks = !(options & DTCoreTextLayoutFrameDrawingOmitLinks);
    BOOL drawImages = !(options & DTCoreTextLayoutFrameDrawingOmitAttachments);
    
    CGRect rect = CGContextGetClipBoundingBox(context);
    //    if (rect.origin.y == 416) {
    //        rect.size.height = 460;
    //    }
    //    rect.size.height = [UIScreen mainScreen].bounds.size.height;
    
    if (!context)
    {
        return;
    }
    
    if (_textFrame)
    {
        CFRetain(_textFrame);
    }
    
    
    if (_SSLayoutFramesShouldDrawDebugFrames)
    {
        CGContextSaveGState(context);
        
        // stroke the frame because the layout frame might be open ended
        CGContextSaveGState(context);
        CGFloat dashes[] = {10.0, 2.0};
        CGContextSetLineDash(context, 0, dashes, 2);
        CGContextStrokeRect(context, self.frame);
        
        // draw center line
        CGContextMoveToPoint(context, CGRectGetMidX(self.frame), self.frame.origin.y);
        CGContextAddLineToPoint(context, CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
        CGContextStrokePath(context);
        
        CGContextRestoreGState(context);
        
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 0.5);
        CGContextStrokeRect(context, rect);
        
        CGContextRestoreGState(context);
    }
    
    NSArray *visibleLines = [self linesVisibleInRect:rect];
    
    if (![visibleLines count])
    {
        return;
    }
    
    CGContextSaveGState(context);
    
    // need to push the CG context so that the UI* based colors can be set
    UIGraphicsPushContext(context);
    
    // need to draw all text boxes because the the there might be the padding region of a box outside the clip rect visible
    [self _drawTextBlocksInContext:context inRange:NSMakeRange(0, [_attributedStringFragment length])];
    
    for (DTCoreTextLayoutLine *oneLine in visibleLines)
    {
        if ([oneLine isHorizontalRule])
        {
            [self _drawHorizontalRuleFromLine:oneLine inContext:context];
            continue;
        }
        
        if (_SSLayoutFramesShouldDrawDebugFrames)
        {
            // draw line bounds
            CGContextSetRGBStrokeColor(context, 0, 0, 1.0f, 1.0f);
            CGContextStrokeRect(context, oneLine.frame);
            
            // draw baseline
            CGContextMoveToPoint(context, oneLine.baselineOrigin.x-5.0f, oneLine.baselineOrigin.y);
            CGContextAddLineToPoint(context, oneLine.baselineOrigin.x + oneLine.frame.size.width + 5.0f, oneLine.baselineOrigin.y);
            CGContextStrokePath(context);
        }
        
        NSInteger runIndex = 0;
        
        for (SSGlyphRun *oneRun in oneLine.glyphRuns)
        {
            if (!CGRectIntersectsRect(rect, oneRun.frame))
            {
                continue;
            }
            
            if (_SSLayoutFramesShouldDrawDebugFrames)
            {
                if (runIndex%2)
                {
                    CGContextSetRGBFillColor(context, 1, 0, 0, 0.2f);
                }
                else
                {
                    CGContextSetRGBFillColor(context, 0, 1, 0, 0.2f);
                }
                
                CGContextFillRect(context, oneRun.frame);
                runIndex ++;
            }
            
            DTTextAttachment *attachment = oneRun.attachment;
            
            if (drawImages && [attachment conformsToProtocol:@protocol(DTTextAttachmentDrawing)])
            {
                id<DTTextAttachmentDrawing> drawableAttachment = (id<DTTextAttachmentDrawing>)attachment;
                
                // frame might be different due to image vertical alignment
                CGFloat ascender = [attachment ascentForLayout];
                CGRect rect = CGRectMake(oneRun.frame.origin.x, oneLine.baselineOrigin.y - ascender, attachment.displaySize.width, attachment.displaySize.height);
                
                [drawableAttachment drawInRect:rect context:context];
            }
            
            if (!drawLinks && oneRun.isHyperlink)
            {
                continue;
            }
            
            // don't draw decorations on images
            if (attachment)
            {
                continue;
            }
            
            // don't draw background, strikout or underline for trailing white space
            if ([oneRun isTrailingWhitespace])
            {
                continue;
            }
            
            [self _setForgroundColorInContext:context forGlyphRun:oneRun options:options];
            
            [oneRun drawDecorationInContext:context];
        }
    }
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -self.frame.size.height);
    
    // instead of using the convenience method to draw the entire frame, we draw individual glyph runs
    
    for (SSLayoutLine *oneLine in visibleLines)
    {
        for (SSGlyphRun *oneRun in oneLine.glyphRuns)
        {
            if (!CGRectIntersectsRect(rect, oneRun.frame))
            {
                continue;
            }
            
            if (!drawLinks && oneRun.isHyperlink)
            {
                continue;
            }
            
            CGPoint textPosition = CGPointMake(oneLine.frame.origin.x, self.frame.size.height - oneRun.frame.origin.y - oneRun.ascent);
            
            NSInteger superscriptStyle = [[oneRun.attributes objectForKey:(id)kCTSuperscriptAttributeName] integerValue];
            
            NSNumber *ascentMultiplier = [oneRun.attributes objectForKey:(id)DTAscentMultiplierAttribute];
            
            
            switch (superscriptStyle)
            {
                case 1:
                {
                    textPosition.y += oneRun.ascent * (ascentMultiplier ? [ascentMultiplier floatValue] : 0.47f);
                    break;
                }
                case -1:
                {
                    textPosition.y -= oneRun.ascent * (ascentMultiplier ? [ascentMultiplier floatValue] : 0.25f);
                    break;
                }
                default:
                    break;
            }
            
            CGContextSetTextPosition(context, textPosition.x, textPosition.y);
            
            if (!oneRun.attachment)
            {
                NSArray *shadows = [oneRun.attributes objectForKey:DTShadowsAttribute];
                
                if (shadows)
                {
                    CGContextSaveGState(context);
                    
                    NSUInteger numShadows = [shadows count];
                    
                    if (numShadows == 1)
                    {
                        // single shadow, we only draw the glyph run with the shadow, no clipping magic
                        NSDictionary *singleShadow = [shadows objectAtIndex:0];
                        [self _setShadowInContext:context fromDictionary:singleShadow additionalOffset:CGSizeZero];
                        
                        [oneRun drawInContext:context];
                    }
                    else // multiple shadows, we shift the text away and then draw a single glyph run over it
                    {
                        // get the run bounds, Core Text has bottom left 0,0 so we flip it
                        CGRect runBoundsFlipped = oneRun.frame;
                        runBoundsFlipped.origin.y = self.frame.size.height - runBoundsFlipped.origin.y - runBoundsFlipped.size.height;
                        
                        // assume that shadows would never be more than 100 pixels away from glyph run frame or outside of frame
                        CGRect clipRect = CGRectIntersection(CGRectInset(runBoundsFlipped, -100, -100), self.frame);
                        
                        // clip to the rect
                        CGContextAddRect(context, clipRect);
                        CGContextClipToRect(context, clipRect);
                        
                        // Move the text outside of the clip rect so that only the shadow is visisble
                        CGContextSetTextPosition(context, textPosition.x + clipRect.size.width, textPosition.y);
                        
                        // draw each shadow
                        [shadows enumerateObjectsUsingBlock:^(NSDictionary *shadowDict, NSUInteger idx, BOOL *stop) {
                            BOOL isLastShadow = (idx == (numShadows-1));
                            
                            if (isLastShadow)
                            {
                                // last shadow draws the original text
                                [self _setShadowInContext:context fromDictionary:shadowDict additionalOffset:CGSizeZero];
                                
                                // ... so we put text position back
                                CGContextSetTextPosition(context, textPosition.x, textPosition.y);
                            }
                            else
                            {
                                [self _setShadowInContext:context fromDictionary:shadowDict additionalOffset:CGSizeMake(-clipRect.size.width, 0)];
                            }
                            
                            [oneRun drawInContext:context];
                        }];
                    }
                    
                    CGContextRestoreGState(context);
                }
                else // no shadows
                {
                    [self _setForgroundColorInContext:context forGlyphRun:oneRun options:options];
                    
                    [oneRun drawInContext:context];
                }
            }
        }
    }
    
    if (_textFrame)
    {
        CFRelease(_textFrame);
    }
    
    UIGraphicsPopContext();
    CGContextRestoreGState(context);
}

#pragma mark - Text Attachments

- (NSArray *)textAttachments
{
    if (!_textAttachments)
    {
        NSMutableArray *tmpAttachments = [NSMutableArray array];
        
        for (SSLayoutLine *oneLine in self.lines)
        {
            for (SSGlyphRun *oneRun in oneLine.glyphRuns)
            {
                DTTextAttachment *attachment = [oneRun attachment];
                
                if (attachment)
                {
                    [tmpAttachments addObject:attachment];
                }
            }
        }
        
        _textAttachments = [[NSArray alloc] initWithArray:tmpAttachments];
    }
    
    
    return _textAttachments;
}

- (NSArray *)textAttachmentsWithPredicate:(NSPredicate *)predicate
{
    return [[self textAttachments] filteredArrayUsingPredicate:predicate];
}

#pragma mark - Calculations

- (NSRange)visibleStringRange
{
    if (!_textFrame)
    {
        return NSMakeRange(0, 0);
    }
    
    if (!_lines)
    {
        // need to build lines to know range
        [self _buildLines];
    }
    
    return _stringRange;
}

- (NSArray *)stringIndices
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.lines count]];
    
    for (SSLayoutLine *oneLine in self.lines)
    {
        [array addObjectsFromArray:[oneLine stringIndices]];
    }
    
    return array;
}

- (NSInteger)lineIndexForGlyphIndex:(NSInteger)index
{
    NSInteger retIndex = 0;
    for (SSLayoutLine *oneLine in self.lines)
    {
        NSInteger count = [oneLine numberOfGlyphs];
        if (index >= count)
        {
            index -= count;
        }
        else
        {
            return retIndex;
        }
        
        retIndex++;
    }
    
    return retIndex;
}

- (CGRect)frameOfGlyphAtIndex:(NSInteger)index
{
    for (SSLayoutLine *oneLine in self.lines)
    {
        NSInteger count = [oneLine numberOfGlyphs];
        if (index >= count)
        {
            index -= count;
        }
        else
        {
            return [oneLine frameOfGlyphAtIndex:index];
        }
    }
    
    return CGRectNull;
}

- (CGRect)frame
{
    if (!_lines)
    {
        [self _buildLines];
    }
    
    if (![self.lines count])
    {
        return CGRectZero;
    }
    
    if (_frame.size.height == CGFLOAT_HEIGHT_UNKNOWN)
    {
        // actual frame is spanned between first and last lines
        SSLayoutLine *lastLine = [_lines lastObject];
        
        _frame.size.height = lastLine.baselineOrigin.y + lastLine.ascent + lastLine.descent + 1.5f + _additionalPaddingAtBottom;
    }
    
    if (_frame.size.width == CGFLOAT_WIDTH_UNKNOWN)
    {
        // actual frame width is maximum value of lines
        CGFloat maxWidth = 0;
        
        for (SSLayoutLine *oneLine in _lines)
        {
            CGFloat lineWidthFromFrameOrigin = CGRectGetMaxX(oneLine.frame) - _frame.origin.x;
            maxWidth = MAX(maxWidth, lineWidthFromFrameOrigin);
        }
        
        _frame.size.width = ceil(maxWidth);
        
    }
    
    return _frame;
}

- (CGRect)intrinsicContentFrame
{
    if (!_lines)
    {
        [self _buildLines];
    }
    
    if (![self.lines count])
    {
        return CGRectZero;
    }
    
    SSLayoutLine *firstLine = [_lines objectAtIndex:0];
    
    CGRect outerFrame = self.frame;
    
    CGRect frameOverAllLines = firstLine.frame;
    
    // move up to frame origin because first line usually does not go all the ways up
    frameOverAllLines.origin.y = outerFrame.origin.y;
    
    for (SSLayoutLine *oneLine in _lines)
    {
        // need to limit frame to outer frame, otherwise HR causes too long lines
        CGRect frame = CGRectIntersection(oneLine.frame, outerFrame);
        
        frameOverAllLines = CGRectUnion(frame, frameOverAllLines);
    }
    
    // extend height same method as frame
    frameOverAllLines.size.height = ceil(frameOverAllLines.size.height + 1.5f + _additionalPaddingAtBottom);
    
    return CGRectIntegral(frameOverAllLines);
}

- (SSLayoutLine *)lineContainingIndex:(NSUInteger)index
{
    for (SSLayoutLine *oneLine in self.lines)
    {
        if (NSLocationInRange(index, [oneLine stringRange]))
        {
            return oneLine;
        }
    }
    
    return nil;
}

- (NSArray *)linesInParagraphAtIndex:(NSUInteger)index
{
    NSArray *paragraphRanges = self.paragraphRanges;
    
    NSAssert(index < [paragraphRanges count], @"index parameter out of range");
    
    NSRange range = [[paragraphRanges objectAtIndex:index] rangeValue];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    // find lines that are in this range
    
    BOOL insideParagraph = NO;
    
    for (SSLayoutLine *oneLine in self.lines)
    {
        if (NSLocationInRange([oneLine stringRange].location, range))
        {
            insideParagraph = YES;
            [tmpArray addObject:oneLine];
        }
        else
        {
            if (insideParagraph)
            {
                // that means we left the range
                
                break;
            }
        }
    }
    
    // return array only if there is something in it
    if ([tmpArray count])
    {
        return tmpArray;
    }
    else
    {
        return nil;
    }
}

// returns YES if the given line is the first in a paragraph
- (BOOL)isLineFirstInParagraph:(SSLayoutLine *)line
{
    NSRange lineRange = line.stringRange;
    
    if (lineRange.location == 0)
    {
        return YES;
    }
    
    NSInteger prevLineLastUnicharIndex =lineRange.location - 1;
    unichar prevLineLastUnichar = [[_attributedStringFragment string] characterAtIndex:prevLineLastUnicharIndex];
    
    return [[NSCharacterSet newlineCharacterSet] characterIsMember:prevLineLastUnichar];
}

// returns YES if the given line is the last in a paragraph
- (BOOL)isLineLastInParagraph:(SSLayoutLine *)line
{
    NSString *lineString = [[_attributedStringFragment string] substringWithRange:line.stringRange];
    
    if ([lineString hasSuffix:@"\n"])
    {
        //		NSLog(@"ddd:%@", lineString);
        return YES;
    }
    
    return NO;
}

#pragma mark - Paragraphs
- (NSUInteger)paragraphIndexContainingStringIndex:(NSUInteger)stringIndex
{
    for (NSValue *oneValue in self.paragraphRanges)
    {
        NSRange range = [oneValue rangeValue];
        
        if (NSLocationInRange(stringIndex, range))
        {
            return [self.paragraphRanges indexOfObject:oneValue];
        }
    }
    
    return NSNotFound;
}

- (NSRange)paragraphRangeContainingStringRange:(NSRange)stringRange
{
    NSUInteger firstParagraphIndex = [self paragraphIndexContainingStringIndex:stringRange.location];
    NSUInteger lastParagraphIndex;
    
    if (stringRange.length)
    {
        lastParagraphIndex = [self paragraphIndexContainingStringIndex:NSMaxRange(stringRange)-1];
    }
    else
    {
        // range is in a single position, i.e. last paragraph has to be same as first
        lastParagraphIndex = firstParagraphIndex;
    }
    
    return NSMakeRange(firstParagraphIndex, lastParagraphIndex - firstParagraphIndex + 1);
}

#pragma mark - Debugging
+ (void)setShouldDrawDebugFrames:(BOOL)debugFrames
{
    _SSLayoutFramesShouldDrawDebugFrames = debugFrames;
}

+ (BOOL)shouldDrawDebugFrames
{
    return _SSLayoutFramesShouldDrawDebugFrames;
}

#pragma mark - Properties
- (NSMutableAttributedString *)attributedStringFragment
{
    return _attributedStringFragment;
}

// builds an array
- (NSArray *)paragraphRanges
{
    if (!_paragraphRanges)
    {
        NSString *plainString = [[self attributedStringFragment] string];
        NSUInteger length = [plainString length];
        
        NSRange paragraphRange = [plainString rangeOfParagraphsContainingRange:NSMakeRange(0, 0) parBegIndex:NULL parEndIndex:NULL];
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        while (paragraphRange.length)
        {
            NSValue *value = [NSValue valueWithRange:paragraphRange];
            [tmpArray addObject:value];
            
            NSUInteger nextParagraphBegin = NSMaxRange(paragraphRange);
            
            if (nextParagraphBegin>=length)
            {
                break;
            }
            
            // next paragraph
            paragraphRange = [plainString rangeOfParagraphsContainingRange:NSMakeRange(nextParagraphBegin, 0) parBegIndex:NULL parEndIndex:NULL];
        }
        
        _paragraphRanges = tmpArray; // no copy for performance
    }
    
    return _paragraphRanges;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    if( _numberOfLines != numberOfLines )
    {
        _numberOfLines = numberOfLines;
        // clear lines cache
        _lines = nil;
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if( _lineBreakMode != lineBreakMode )
    {
        _lineBreakMode = lineBreakMode;
        // clear lines cache
        _lines = nil;
    }
}

- (void)setTruncationString:(NSAttributedString *)truncationString
{
    if( ![_truncationString isEqualToAttributedString:truncationString] )
    {
        _truncationString = truncationString;
        
        if( self.numberOfLines > 0 )
        {
            // clear lines cache
            _lines = nil;
        }
    }
}

- (void)setJustifyRatio:(CGFloat)justifyRatio
{
    if (_justifyRatio != justifyRatio)
    {
        _justifyRatio = justifyRatio;
        
        // clear lines cache
        _lines = nil;
    }
}

@synthesize numberOfLines = _numberOfLines;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize truncationString = _truncationString;
@synthesize frame = _frame;
@synthesize lines = _lines;
@synthesize paragraphRanges = _paragraphRanges;
@synthesize textBlockHandler = _textBlockHandler;
@synthesize justifyRatio = _justifyRatio;

@end
