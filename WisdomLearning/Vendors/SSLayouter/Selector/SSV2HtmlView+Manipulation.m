//
//  SSV2HtmlView+Manipulation.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/13.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSV2HtmlView+Manipulation.h"

@implementation SSV2HtmlView (Manipulation)

- (NSAttributedString *)attributedSubstringForRange:(UITextRange *)range
{
    DTTextRange *textRange = (DTTextRange *)range;
    
    return [self.attributedContentView.layoutFrame.attributedStringFragment attributedSubstringFromRange:[textRange NSRangeValue]];
}

@end
