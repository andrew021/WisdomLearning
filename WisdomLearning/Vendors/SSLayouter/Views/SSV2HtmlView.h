//
//  SSV2HtmlView.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSHtmlView.h"

@class SSV2HtmlView;

@protocol SSV2HtmlViewDelegate <SSHtmlViewDelegate>

@optional

/**
 Notifies the delegate that text will be pasted at the given range.  This gives the delegate an opportunity to modify content for a paste operation.  A delegate may use this method to modify or remove specific attributes including disallowing image attachments.  editorView:shouldChangeTextInRange:replacementText: is called before this method if implemented.
 
 @param editorView The editor view undergoing a paste operation.
 @param text The text to paste.
 @param range The range in which to paste the text.
 
 @return An attributed string for the paste operation.  Return text if suitable or a modified string. Return nil to cancel the paste operation.
 */
- (NSAttributedString *)htmlView:(SSV2HtmlView *)htmlView willPasteText:(NSAttributedString *)text inRange:(NSRange)range;

/**
 Tells the delegate that the text selection changed in the specified editor view.
 
 @param editorView The editor view whose selection changed.
 */
- (void)htmlViewDidChangeSelection:(SSV2HtmlView *)htmlView;

@property (nonatomic, retain) NSArray *menuItems;
- (BOOL)htmlView:(SSV2HtmlView *)htmlView canPerformAction:(SEL)action withSender:(id)sender;

@end

@interface SSV2HtmlView : SSHtmlView<UITextInputTraits, UITextInput>

/**
 Property to enable copy/paste support. If enabled the user can paste text into DTRichTextEditorView or copy text to the pasteboard.
 */
@property (nonatomic, assign) BOOL canInteractWithPasteboard;

//@property(nonatomic, weak) id<SSV2HtmlViewDelegate> v2htmlViewDelegate;

@property(nonatomic, weak) id<SSV2HtmlViewDelegate> htmlViewDelegate;

@end
