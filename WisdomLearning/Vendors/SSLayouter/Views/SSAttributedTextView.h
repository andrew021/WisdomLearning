//
//  SSAttributedTextView.h
//  DTCoreText
//
//  Created by su on 16/5/25.
//  Copyright © 2016年 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAttributedContentView.h"

@interface SSAttributedTextView : UIScrollView


@property(nonatomic, strong) NSAttributedString *attributedString;

@property(nonatomic, weak) id<SSAttributedContentViewDelegate> textDelegate;

- (void) relayoutText;

@property(nonatomic, strong) SSAttributedContentView *attributedContentView;

@property(nonatomic, strong) UIView *backgroundView;

@property(nonatomic, assign) BOOL shouldDrawLinks;

@property(nonatomic, assign) BOOL shouldDrawImages;

/**
 @name Customizing Content View
 */

/**
 You can override this method to provide a different class to use for the content view. If you replace the content view class then it should inherit from <DTAttributedTextContentView> which is also the default.
 @returns The class to use for the content view.
 */
- (Class)classForContentView;

/**
 @name User Interaction
 */

/**
 Scrolls the receiver to the anchor with the given name to the top.
 @param anchorName The name of the href anchor.
 @param animated `YES` if the movement should be animated.
 */
- (void)scrollToAnchorNamed:(NSString *)anchorName animated:(BOOL)animated;

/**
 Scrolls the receiver until the text in the specified range is visible.
 @param range The range of text to scroll into view.
 @param animated `YES` if the movement should be animated.
 */
- (void)scrollRangeToVisible:(NSRange)range animated:(BOOL)animated;

@end
