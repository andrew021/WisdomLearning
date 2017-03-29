//
//  SSLayouterConfig.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *SSLayouterDefaultKern;
extern NSString *SSLayouterDefaultMarginLeft;
extern NSString *SSLayouterDefaultMarginRight;
extern NSString *SSLayouterDefaultMarginTop;
extern NSString *SSLayouterDefaultMarginBottom;
extern NSString *SSLayouterDefaultLeadingRatio;
extern NSString *SSLayouterDefaultFirstLineHeadIndent;
extern NSString *SSLayouterDefaultLineHeightMultiplier;
extern NSString *SSLayouterDefaultFontSize;
extern NSString *SSLayouterDefaultFontName;
extern NSString *SSLayouterDefaultFontFamily;
extern NSString *SSLayouterDefaultLinkColor;
extern NSString *SSLayouterDefaultLinkHighlightColor;
extern NSString *SSLayouterDefaultTextColor;

@interface SSLayouterConfig : NSObject

+ (id) shared;

- (NSDictionary *) getConfig;
- (void) setConfig:(NSDictionary *)config;

- (CGFloat) getKerning;
- (CGFloat) getMarginLeft;
- (CGFloat) getMarginRight;
- (CGFloat) getMarginTop;
- (CGFloat) getMarginBottom;
- (CGFloat) getLeadingRatio;

- (CGFloat) getFirstLineHeadIndent;
- (CGFloat) getLineHeightMultiplier;
- (CGFloat) getFontSize;
- (NSString *) getFontName;
- (NSString *) getFontFamily;
- (NSString *) getLinkColor;
- (NSString *) getLinkHighlightColor;
- (NSString *) getTextColor;

@end
