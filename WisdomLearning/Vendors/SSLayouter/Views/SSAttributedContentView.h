//
//  SSAttributedContentView.h
//  DTCoreText
//
//  Created by su on 16/5/23.
//  Copyright © 2016年 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLayoutFrame.h"

@class SSAttributedContentView;
@class SSLayoutFrame;
@class DTTextBlock;
@class SSLayouter;
@class DTTextAttachment;

extern NSString * const SSAttributedContentViewDidFinishLayoutNotification;

@protocol SSAttributedContentViewDelegate <NSObject>

@optional
/**
 @name Notifications
 */

/**
 Called before a layout frame or a part of it is drawn. The text delegate can draw contents that goes under the text in this method.
 
 @param attributedTextContentView The content view that will be drawing a layout frame
 @param layoutFrame The layout frame that will be drawn for
 @param context The graphics context that will drawn into
 */
- (void)attributedContentView:(SSAttributedContentView *)attributedTextContentView willDrawLayoutFrame:(SSLayoutFrame *)layoutFrame inContext:(CGContextRef)context;


/**
 Called after a layout frame or a part of it is drawn. The text delegate can draw contents that goes over the text in this method.
 
 @param attributedTextContentView The content view that drew a layout frame
 @param layoutFrame The layout frame that was drawn for
 @param context The graphics context that was drawn into
 */
- (void)attributedContentView:(SSAttributedContentView *)attributedTextContentView didDrawLayoutFrame:(SSLayoutFrame *)layoutFrame inContext:(CGContextRef)context;


/**
 Called before the text belonging to a text block is drawn.
 
 This gives the developer an opportunity to draw a custom background below a text block.
 
 @param attributedTextContentView The content view that drew a layout frame
 @param textBlock The text block
 @param frame The frame within the content view's coordinate system that will be drawn into
 @param context The graphics context that will be drawn into
 @param layoutFrame The layout frame that will be drawn for
 @returns `YES` is the standard fill of the text block should be drawn, `NO` if it should not
 */
- (BOOL)attributedContentView:(SSAttributedContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(SSLayoutFrame *)layoutFrame;

/**
 @name Providing Custom Views for Content
 */


/**
 Provide custom view for an attachment, e.g. an imageView for images
 
 @param attributedTextContentView The content view asking for a custom view
 @param attachment The <DTTextAttachment> that this view should represent
 @param frame The frame that the view should use to fit on top of the space reserved for the attachment
 @returns The view that should represent the given attachment
 */
- (UIView *)attributedContentView:(SSAttributedContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame;


/**
 Provide button to be placed over links, the identifier is used to link multiple parts of the same A tag
 
 @param attributedTextContentView The content view asking for a custom view
 @param url The `NSURL` of the hyperlink
 @param identifier An identifier that uniquely identifies the hyperlink within the document
 @param frame The frame that the view should use to fit on top of the space reserved for the attachment
 @returns The view that should represent the given hyperlink
 */
- (UIView *)attributedContentView:(SSAttributedContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame;


/**
 Provide generic views for all attachments.
 
 This is only called if the more specific delegate methods are not implemented.
 
 @param attributedTextContentView The content view asking for a custom view
 @param string The attributed sub-string containing this element
 @param frame The frame that the view should use to fit on top of the space reserved for the attachment
 @returns The view that should represent the given hyperlink or text attachment
 @see attributedTextContentView:viewForAttachment:frame: and attributedTextContentView:viewForAttachment:frame:
 */
- (UIView *)attributedContentView:(SSAttributedContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame;

@end


typedef NS_ENUM(NSInteger, SSAttributedContentViewRelayoutMask) {
	SSAttributedContentViewRelayoutNever            = 0,
	SSAttributedTextContentViewRelayoutOnWidthChanged   = 1 << 0,
	SSAttributedTextContentViewRelayoutOnHeightChanged  = 1 << 1,
};



@interface SSAttributedContentView : UIView
{
	
}

- (CGSize)suggestedFrameSizeToFitEntireStringConstraintedToWidth:(CGFloat)width;

- (CGSize)intrinsicContentSize;

@property (nonatomic, assign) BOOL layoutFrameHeightIsConstrainedByBounds;

- (void)relayoutText;

@property (atomic, strong) SSLayouter *layouter;

@property (atomic, strong) SSLayoutFrame *layoutFrame;

- (void)removeAllCustomViews;

- (void)removeAllCustomViewsForLinks;

- (void)layoutSubviewsInRect:(CGRect)rect;

@property (nonatomic, copy) NSAttributedString *attributedString;

@property (nonatomic, weak) id <SSAttributedContentViewDelegate> delegate;

@property (nonatomic) UIEdgeInsets edgeInsets;

@property (nonatomic) BOOL shouldDrawImages;

@property (nonatomic) BOOL shouldDrawLinks;

@property (nonatomic) BOOL shouldLayoutCustomSubviews;

@property (nonatomic) CGPoint layoutOffset;

@property (nonatomic) CGSize backgroundOffset;

@property (nonatomic) SSAttributedContentViewRelayoutMask relayoutMask;

@property (nonatomic) CGRect headerViewRect;

@property (nonatomic) CGRect footerViewRect;


@end



/**
 You can globally customize the layer class to be used for new instances of <EATAttributedTextContentView>. By itself it makes most sense to go with the default `CALayer`. For larger bodies of text, i.e. if there is scrolling then you should use a `CATiledLayer` subclass instead.
 */
@interface SSAttributedContentView (Tiling)

/**
 Sets the layer class globally to use in new instances of content views. Defaults to `CALayer`.
 
 While being fine for most use cases you should use a `CATiledLayer` subclass for anything larger than a screen full, e.g. in scroll views.
 @param layerClass The class to use, should be a `CALayer` subclass
 */
+ (void)setLayerClass:(Class)layerClass;

/**
 The current layer class that is used for new instances
 @returns The `CALayer` subclass that new instances are using
 */
+ (Class)layerClass;

@end


/**
 Methods for drawing the content view
 */
@interface SSAttributedContentView (Drawing)

/**
 Creates an image from a part of the receiver's content view
 @param bounds The bounds of the content to draw
 @param options The drawing options to apply when drawing
 @see [DTCoreTextLayoutFrame drawInContext:options:] for a list of available drawing options
 @returns A `UIImage` with the specified content
 */
- (UIImage *)contentImageWithBounds:(CGRect)bounds options:(SSLayoutFrameDrawingOptions)options;

@end

