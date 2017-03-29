//
//  SSHtmlView.m
//  DTCoreText
//
//  Created by su on 16/5/25.
//  Copyright © 2016年 Drobnik.com. All rights reserved.
//

#import "SSHtmlView.h"
#import <UIImageView+WebCache.h>
#import "SSImageObject.h"
#import "SSImageButton.h"
#import "SSPlayerView.h"
#import <DTCoreText.h>

@interface SSHtmlView ()<SSAttributedContentViewDelegate, SSImageButtonDelegate>

@property(nonatomic, strong) NSMutableSet *mediaPlayers;

@end

@implementation SSHtmlView

- (void) setHtml:(NSString *)html
{
	self.textDelegate = self;
	self.attributedString = [self _attributedStringForHtmlString:html];
}


- (NSAttributedString *)_attributedStringForHtmlString:(NSString *)html
{
	// Load HTML data
	NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
	
	// Create attributed string from HTML
	CGSize maxImageSize = CGSizeMake(self.bounds.size.width - ([[SSLayouterConfig shared] getMarginLeft] + [[SSLayouterConfig shared] getMarginRight]), MAXFLOAT);
	
	// example for setting a willFlushCallback, that gets called before elements are written to the generated attributed string
	void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
		
		// the block is being called for an entire paragraph, so we check the individual elements
		
		for (DTHTMLElement *oneChildElement in element.childNodes)
		{
			// if an element is larger than twice the font size put it in it's own block
			if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
			{
				oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
				oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
				oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
			}
		}
	};
	
	NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithFloat:1.0], NSTextSizeMultiplierDocumentOption,
									[NSValue valueWithCGSize:maxImageSize], DTMaxImageSize,
									@"blue", DTDefaultLinkColor,
									@"blue", DTDefaultLinkHighlightColor,
									callBackBlock, DTWillFlushBlockCallBack,
									@([[SSLayouterConfig shared] getFontSize]), DTDefaultFontSize,
									@([[SSLayouterConfig shared] getFirstLineHeadIndent]), DTDefaultFirstLineHeadIndent,
									@([[SSLayouterConfig shared] getLineHeightMultiplier]), DTDefaultLineHeightMultiplier,
									nil];
    NSString *textColor = [[SSLayouterConfig shared] getTextColor];
    if (textColor) {
        [options setObject:textColor forKey:DTDefaultTextColor];
    }
    NSString *fontName = [[SSLayouterConfig shared] getFontName];
    if (fontName) {
        [options setObject:fontName forKey:DTDefaultFontName];
    }
    NSString *fontFamily = [[SSLayouterConfig shared] getFontFamily];
    if (fontFamily) {
        [options setObject:fontFamily forKey:DTDefaultFontFamily];
    }
    NSString *linkColor = [[SSLayouterConfig shared] getLinkColor];
    if (linkColor) {
        [options setObject:linkColor forKey:DTDefaultLinkColor];
    }
    NSString *linkHighlightColor = [[SSLayouterConfig shared] getLinkHighlightColor];
    if (linkHighlightColor) {
        [options setObject:linkHighlightColor forKey:DTDefaultLinkHighlightColor];
    }
	
	NSAttributedString *string = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:NULL];
	
	NSString *plainString = [string string];
	NSRegularExpression *regUnicodeBlank = [NSRegularExpression regularExpressionWithPattern:@"[\\u200b\\u200B]" options:0 error:NULL];
	
	NSMutableAttributedString *mutableAttributedString = [string mutableCopy];
	
	NSArray *results = [regUnicodeBlank matchesInString:plainString options:0 range:NSMakeRange(0, [plainString length])];
	
	for (NSInteger i = results.count - 1; i >= 0; i --) {
		NSTextCheckingResult *result = [results objectAtIndex:i];
		[mutableAttributedString deleteCharactersInRange:result.range];
	}
	
	return mutableAttributedString;
}




#pragma mark - attributedContentView delegate

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    return YES;
}

- (UIView *)attributedContentView:(SSAttributedContentView *)attributedTextContentView
				viewForAttachment:(DTTextAttachment *)attachment
							frame:(CGRect)frame
{
	if ([attachment isKindOfClass:[DTImageTextAttachment class]])
	{
        SSImageObject *imgObj = [self createImageObjectFromAttachment:attachment];
        imgObj.rect = frame;
        
        SSImageButton *imageBtn = [[SSImageButton alloc] initWithFrame:frame];
        imageBtn.delegate = self;
        imageBtn.imageObject = imgObj;
        [imageBtn addTarget:self action:@selector(imageDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return imageBtn;
	}
    else if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
    {
        NSURL *url = attachment.contentURL;
        SSPlayerView *player = nil;
        for (player in self.mediaPlayers) {
            if ([player.url isEqual:url]) {
                break;
            }
        }
        if (!player) {
            player = [[SSPlayerView alloc] initWithFrame:frame url:url];
            if (!self.mediaPlayers) {
                self.mediaPlayers = [[NSMutableSet alloc] init];
            }
            [self.mediaPlayers addObject:player];
        }
        NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
        if (autoplayAttr) {
            player.autoplay = YES;
        }
        return player;
    }
	else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
	{
		UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
		webView.backgroundColor = [UIColor lightGrayColor];
		[webView loadRequest:[NSURLRequest requestWithURL:attachment.contentURL]];
		return webView;
	}
    return nil;
}

/**
 *  创建一个view给<a>标签
 *
 *  @param attributedTextContentView 属性容器视图
 *  @param url                       <a>的链接
 *  @param identifier                唯一标识
 *  @param frame                     frame
 *
 *  @return DTLinkButton
 */
- (UIView *)attributedContentView:(SSAttributedContentView *)attributedTextContentView
					  viewForLink:(NSURL *)url
					   identifier:(NSString *)identifier
							frame:(CGRect)frame
{
    DTLinkButton *linkBtn = [[DTLinkButton alloc] initWithFrame:frame];
    linkBtn.URL = url;
    linkBtn.GUID = identifier;
    linkBtn.minimumHitSize = CGSizeMake(25, 25);
    [linkBtn addTarget:self action:@selector(linkDidClick:) forControlEvents:UIControlEventTouchUpInside];
    return linkBtn;
}

#pragma mark - util methods
- (SSImageObject *) createImageObjectFromAttachment:(DTTextAttachment *)attachment
{
    @synchronized (self) {
        if (!_imageObjects) {
            _imageObjects = [[NSMutableArray alloc] init];
        } else {
            for (SSImageObject *imgObj in _imageObjects) {
                if (imgObj.url == attachment.contentURL) {
                    return imgObj;
                }
            }
        }
        SSImageObject *imgObj = [[SSImageObject alloc] init];
        imgObj.url = attachment.contentURL;
        if (_imageObjects.count > 0) {
            imgObj.index = [(SSImageObject *)[_imageObjects lastObject] index] + 1;
        }
        [_imageObjects addObject:imgObj];
        return imgObj;
    }
}

#pragma mark - action
- (void) imageDidClick:(SSImageButton *) imageButton
{
    if ([self.htmlViewDelegate respondsToSelector:@selector(htmlView:clickImage:)]) {
        CGRect frame = imageButton.frame;
        frame.origin.y += self.attributedContentView.frame.origin.y + self.frame.origin.y;
        frame.origin.y -= self.contentOffset.y;
        imageButton.imageObject.rect = frame;
        [self.htmlViewDelegate htmlView:self clickImage:imageButton.imageObject];
    }
}

- (void) linkDidClick:(DTLinkButton *)linkButton
{
    if ([self.htmlViewDelegate respondsToSelector:@selector(htmlView:clickUrl:)]) {
        [self.htmlViewDelegate htmlView:self clickUrl:linkButton.URL];
    }
}

#pragma mark - public methods
- (void) pauseAllVideoPlayer
{
    for (SSPlayerView *player in self.mediaPlayers) {
        [player pause];
    }
}


@end
