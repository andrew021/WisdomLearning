//
//  SSLayouterConfig.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLayouterConfig.h"
#import <DTCoreText/DTColorFunctions.h>

NSString *SSLayouterDefaultKern = @"DefaultKerning";
NSString *SSLayouterDefaultMarginLeft = @"DefaultMarginLeft";
NSString *SSLayouterDefaultMarginRight = @"DefaultMarginRight";
NSString *SSLayouterDefaultMarginTop = @"DefaultMarginTop";
NSString *SSLayouterDefaultMarginBottom = @"DefaultMarginBottom";
NSString *SSLayouterDefaultLeadingRatio = @"DefaultLeadingRatio";

NSString *SSLayouterDefaultFirstLineHeadIndent = @"DefaultFirstLineHeadIndent";
NSString *SSLayouterDefaultLineHeightMultiplier = @"DefaultLineHeightMultiplier";
NSString *SSLayouterDefaultFontSize = @"DefaultFontSize";
NSString *SSLayouterDefaultFontName = @"DefaultFontName";
NSString *SSLayouterDefaultFontFamily = @"DefaultFontFamily";
NSString *SSLayouterDefaultLinkColor = @"DefaultLinkColor";
NSString *SSLayouterDefaultLinkHighlightColor = @"DefaultLinkHighlightColor";
NSString *SSLayouterDefaultTextColor = @"DefaultTextColor";


@interface SSLayouterConfig ()

@property(nonatomic, strong) NSMutableDictionary *configDic;

@end

@implementation SSLayouterConfig

+ (id) shared
{
    static SSLayouterConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[SSLayouterConfig alloc] init];
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 读取配置文件
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"SSLayouter" ofType:@"plist"];
        _configDic = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
        
    }
    return self;
}

- (NSDictionary *) getConfig
{
    return _configDic;
}
- (void) setConfig:(NSDictionary *)config
{
    for (NSString *key in [config allKeys]) {
        [_configDic setObject:[config objectForKey:key] forKey:key];
    }
}

- (CGFloat) getKerning
{
    return [[_configDic objectForKey:SSLayouterDefaultKern] floatValue];
}
- (CGFloat) getMarginLeft
{
    return [[_configDic objectForKey:SSLayouterDefaultMarginLeft] floatValue];
}
- (CGFloat) getMarginRight
{
    return [[_configDic objectForKey:SSLayouterDefaultMarginRight] floatValue];
}
- (CGFloat) getMarginTop
{
    return [[_configDic objectForKey:SSLayouterDefaultMarginTop] floatValue];
}
- (CGFloat) getMarginBottom
{
    return [[_configDic objectForKey:SSLayouterDefaultMarginBottom] floatValue];
}
- (CGFloat) getLeadingRatio
{
    return [[_configDic objectForKey:SSLayouterDefaultLeadingRatio] floatValue];
}


- (CGFloat) getFirstLineHeadIndent
{
    return [[_configDic objectForKey:SSLayouterDefaultFirstLineHeadIndent] floatValue];
}

- (CGFloat) getLineHeightMultiplier
{
    return [[_configDic objectForKey:SSLayouterDefaultLineHeightMultiplier] floatValue];
}

- (CGFloat) getFontSize
{
    return [[_configDic objectForKey:SSLayouterDefaultFontSize] floatValue];
}

- (NSString *) getFontName
{
    NSString *str = [_configDic objectForKey:SSLayouterDefaultFontName];
    if (str != nil && ![@"" isEqualToString:str]) {
        return str;
    }
    return nil;
}

- (NSString *) getFontFamily
{
    NSString *str = [_configDic objectForKey:SSLayouterDefaultFontFamily];
    if (str != nil && ![@"" isEqualToString:str]) {
        return str;
    }
    return nil;
}

- (NSString *) getLinkColor
{
    NSString *colorStr = [_configDic objectForKey:SSLayouterDefaultLinkColor];
    if (colorStr != nil && ![@"" isEqualToString:colorStr]) {
        return colorStr;
    }
    return nil;
}

- (NSString *) getLinkHighlightColor
{
    NSString *colorStr = [_configDic objectForKey:SSLayouterDefaultLinkHighlightColor];
    if (colorStr != nil && ![@"" isEqualToString:colorStr]) {
        return colorStr;
    }
    return nil;
}

- (NSString *) getTextColor
{
    NSString *colorStr = [_configDic objectForKey:SSLayouterDefaultTextColor];
    if (colorStr != nil && ![@"" isEqualToString:colorStr]) {
        return colorStr;
    }
    return nil;
}




@end
