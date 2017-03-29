//
//  SSAttributedTextView.m
//  DTCoreText
//
//  Created by su on 16/5/25.
//  Copyright © 2016年 Drobnik.com. All rights reserved.
//

#import "SSAttributedTextView.h"
#import "SSLayoutLine.h"
#import "SSLayoutFrame.h"
#import "SSLayouter.h"
#import "DTTiledLayerWithoutFade.h"
#import "SSLayouterConfig.h"

@interface SSAttributedTextView ()

@end


@implementation SSAttributedTextView
{
	BOOL _shouldRelayout;
	
	BOOL _finishLoad;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
        [self _setup];
	}
	return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
	[self _setup];
}

- (void) layoutSubviews
{
	if (_shouldRelayout)
	{
		(void)[self attributedContentView];
		[_attributedContentView layoutSubviewsInRect:self.bounds];
	}
	else
	{
		_shouldRelayout = YES;
	}
	[super layoutSubviews];
}


- (void)setFrame:(CGRect)frame
{
	CGRect oldFrame = self.frame;
	
	if (!CGRectEqualToRect(oldFrame, frame))
	{
		[super setFrame:frame]; // need to set own frame first because layout completion needs this updated frame
		
		if (oldFrame.size.width != frame.size.width)
		{
			// height does not matter, that will be determined anyhow
			CGRect contentFrame = CGRectMake(0, 0, frame.size.width - self.contentInset.left - self.contentInset.right, _attributedContentView.frame.size.height);
			
			_attributedContentView.frame = contentFrame;
		}
	}
}


- (void) _setup
{
	if (self.backgroundColor)
	{
		CGFloat alpha = [self.backgroundColor alphaComponent];
		if (alpha < 1.0f)
		{
			self.opaque = NO;
		}
		else
		{
			self.opaque = YES;
		}
	}
	else
	{
		self.backgroundColor = [UIColor whiteColor];
		self.opaque = YES;
	}
	
	self.autoresizesSubviews = NO;
	self.clipsToBounds = YES;
	
	_shouldDrawLinks = YES;
	_shouldDrawImages = YES;
	_shouldRelayout = YES;
}

- (Class)classForContentView
{
	return [SSAttributedContentView class];
}


#pragma mark external methods
- (void) scrollToAnchorNamed:(NSString *)anchorName animated:(BOOL)animated
{
	NSRange range = [self.attributedContentView.attributedString rangeOfAnchorNamed:anchorName];
	if (range.location != NSNotFound)
	{
		[self scrollRangeToVisible:range animated:animated];
	}
}

- (void)scrollRangeToVisible:(NSRange)range animated:(BOOL)animated
{
	// get the line of the first index of the anchor range
	SSLayoutLine *line = [self.attributedContentView.layoutFrame lineContainingIndex:range.location];
	
	// make sure we don't scroll too far
	CGFloat maxScrollPos = self.contentSize.height - self.bounds.size.height + self.contentInset.bottom + self.contentInset.top;
	CGFloat scrollPos = MIN(line.frame.origin.y, maxScrollPos);
	
	// scroll
	[self setContentOffset:CGPointMake(0, scrollPos) animated:animated];
}

- (void) relayoutText
{
	dispatch_async(dispatch_get_main_queue(), ^{
		
		// need to reset the layouter because otherwise we get the old framesetter or cached layout frames
		_attributedContentView.layouter = nil;
		_finishLoad = NO;
		// here we're layouting the entire string, might be more efficient to only relayout the paragraphs that contain these attachments
		[_attributedContentView relayoutText];
		
		// layout custom subviews for visible area
		[self setNeedsLayout];
		
	});
}

#pragma mark Notifications
- (void)contentViewDidLayout:(NSNotification *)notification
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSDictionary *userInfo = [notification userInfo];
		CGRect optimalFrame = [[userInfo objectForKey:@"OptimalFrame"] CGRectValue];
		
		CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
		
		// ignore possibly delayed layout notification for a different width
		if (optimalFrame.size.width == frame.size.width)
		{
			//			_attributedTextContentView.frame = optimalFrame;
			
			CGRect frame = _attributedContentView.frame;
			frame.size.height = optimalFrame.size.height;
			_attributedContentView.frame = frame;
			
			CGFloat externHeight = 0;
			
			// fit the frame of backgroundView
			if (_backgroundView) {
				_backgroundView.frame = frame;
			}

			
			CGSize size = [_attributedContentView intrinsicContentSize];
			
			size.height += externHeight;
			
			self.contentSize = size;
			
			_finishLoad = YES;
		}
		
	});
}

#pragma mark Properties
- (SSAttributedContentView *)attributedContentView
{
	if (!_attributedContentView)
	{
		// subclasses can specify a DTAttributedTextContentView subclass instead
		Class classToUse = [self classForContentView];
		
		CGRect frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
		
		if (frame.size.width<=0 || frame.size.height<=0)
		{
			frame = CGRectZero;
		}
		
		// make sure we always have a tiled layer
		Class previousLayerClass = nil;
		
		// for DTAttributedTextContentView subclasses we force a tiled layer
		if ([classToUse isSubclassOfClass:[SSAttributedContentView class]])
		{
			Class layerClass = [SSAttributedContentView layerClass];
			
			if (![layerClass isSubclassOfClass:[CATiledLayer class]])
			{
				[SSAttributedContentView setLayerClass:[DTTiledLayerWithoutFade class]];
				previousLayerClass = layerClass;
			}
		}
		
		_attributedContentView = [[classToUse alloc] initWithFrame:frame];
		_attributedContentView.edgeInsets = UIEdgeInsetsMake(0, [[SSLayouterConfig shared] getMarginLeft], 0, [[SSLayouterConfig shared] getMarginRight]);
		
		// restore previous layer class if we changed the layer class for the content view
		if (previousLayerClass)
		{
			[SSAttributedContentView setLayerClass:previousLayerClass];
		}
		
		_attributedContentView.userInteractionEnabled = YES;
		_attributedContentView.backgroundColor = self.backgroundColor;
		_attributedContentView.shouldLayoutCustomSubviews = NO; // we call layout when scrolling
		
		// adjust opaqueness based on background color alpha
		CGFloat alpha = [self.backgroundColor alphaComponent];
		
		if (alpha < 1.0)
		{
			_attributedContentView.opaque = NO;
		}
		else
		{
			_attributedContentView.opaque = YES;
		}
		
		// set text delegate if it was set before instantiation of content view
		_attributedContentView.delegate = _textDelegate;
		
		// pass on setting
		_attributedContentView.shouldDrawLinks = _shouldDrawLinks;
		
		// notification that tells us about the actual size of the content view
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentViewDidLayout:) name:SSAttributedContentViewDidFinishLayoutNotification object:_attributedContentView];
		
		// temporary frame to specify the width
		_attributedContentView.frame = frame;
		
		// set text we previously got, this also triggers a relayout
		_attributedContentView.attributedString = _attributedString;
		
		// this causes a relayout and the resulting notification will allow us to set the final frame
		
		[self addSubview:_attributedContentView];
	}
	return _attributedContentView;
}


#pragma mark - properties

- (void)setBackgroundColor:(UIColor *)newColor
{
	if ([newColor alphaComponent]<1.0)
	{
		super.backgroundColor = newColor;
		_attributedContentView.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	}
	else
	{
		super.backgroundColor = newColor;
		
		if (_attributedContentView.opaque)
		{
			_attributedContentView.backgroundColor = newColor;
		}
	}
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
	if (!UIEdgeInsetsEqualToEdgeInsets(self.contentInset, contentInset))
	{
		[super setContentInset:contentInset];
		
		// height does not matter, that will be determined anyhow
		CGRect contentFrame = CGRectMake(0, 0, self.frame.size.width - self.contentInset.left - self.contentInset.right, _attributedContentView.frame.size.height);
		
		_attributedContentView.frame = contentFrame;
	}
}


- (UIView *)backgroundView
{
	if (!_backgroundView)
	{
		_backgroundView = [[UIView alloc] initWithFrame:self.bounds];
		_backgroundView.backgroundColor	= [UIColor whiteColor];
		
		// default is no interaction because background should have no interaction
		_backgroundView.userInteractionEnabled = NO;
		
		[self insertSubview:_backgroundView belowSubview:self.attributedContentView];
		
		// make content transparent so that we see the background
		_attributedContentView.backgroundColor = [DTColor clearColor];
		_attributedContentView.opaque = NO;
	}
	
	return _backgroundView;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
	if (_backgroundView != backgroundView)
	{
		[_backgroundView removeFromSuperview];
		_backgroundView = backgroundView;
		
		if (_attributedContentView)
		{
			[self insertSubview:_backgroundView belowSubview:_attributedContentView];
		}
		else
		{
			[self addSubview:_backgroundView];
		}
		
		if (_backgroundView)
		{
			// make content transparent so that we see the background
			_attributedContentView.backgroundColor = [UIColor clearColor];
			_attributedContentView.opaque = NO;
		}
		else
		{
			_attributedContentView.backgroundColor = [UIColor whiteColor];
			_attributedContentView.opaque = YES;
		}
	}
}


- (void)setAttributedString:(NSAttributedString *)string
{
	_attributedString = string;
	
	// might need layout for visible custom views
	[self setNeedsLayout];
	
	if (_attributedContentView)
	{
		// pass it along if contentView already exists
		_attributedContentView.attributedString = string;
		
		// this causes a relayout and the resulting notification will allow us to set the frame and contentSize
	}
}

- (NSAttributedString *)attributedString
{
	return _attributedString;
}


- (void)setTextDelegate:(id<SSAttributedContentViewDelegate>)aTextDelegate
{
	// store unsafe pointer to delegate because we might not have a contentView yet
	_textDelegate = aTextDelegate;
	
	// set it if possible, otherwise it will be set in contentView lazy property
	_attributedContentView.delegate = aTextDelegate;
}

- (id<SSAttributedContentViewDelegate>)textDelegate
{
	return _attributedContentView.delegate;
}

- (void)setShouldDrawLinks:(BOOL)shouldDrawLinks
{
	_shouldDrawLinks = shouldDrawLinks;
	_attributedContentView.shouldDrawLinks = _shouldDrawLinks;
}

- (void)setShouldDrawImages:(BOOL)shouldDrawImages
{
	_shouldDrawImages = shouldDrawImages;
	_attributedContentView.shouldDrawImages = _shouldDrawImages;
}



@synthesize attributedContentView = _attributedContentView;
@synthesize attributedString = _attributedString;
@synthesize textDelegate = _textDelegate;
@synthesize backgroundView = _backgroundView;

@synthesize shouldDrawLinks = _shouldDrawLinks;

@end
