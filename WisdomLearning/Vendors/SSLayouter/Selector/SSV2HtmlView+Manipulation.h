//
//  SSV2HtmlView+Manipulation.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSV2HtmlView.h"
#import <DTRichTextEditor.h>
#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreTextGlyphRun.h>

/**
 Options for generating HTML output
 */
typedef NS_ENUM(NSUInteger, SSHTMLWriterOption)
{
    /**
     HTML output as document-style, with CSS styles compressed in header
     */
    SSHTMLWriterOptionDocument = 0,  // default
    
    /**
     HTML output as fragment, CSS styles inlined
     */
    SSHTMLWriterOptionFragment = 1 << 0
};


@class DTTextRange, DTTextPosition, DTCSSListStyle, DTCoreTextFontDescriptor;

/**
 The **Manipulation** category enhances DTRichTextEditorView with useful text format manipulation methods.
 */
@interface SSV2HtmlView (Manipulation)

/**
 @name Getting/Setting Content
 */

/**
 Retrieves that attributed substring for the given range.
 @param range The text range
 @returns The `NSAttributedString` substring
 */
- (NSAttributedString *)attributedSubstringForRange:(UITextRange *)range;

@end
