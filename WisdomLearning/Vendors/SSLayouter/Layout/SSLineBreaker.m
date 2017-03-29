//
//  SSLineBreaker.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSLineBreaker.h"
#import "SSTextShapeParser.h"
#import "SSTextShape.h"
#import <CoreText/CoreText.h>
#import <DTCoreText.h>

#define maxElasticRate 3
#define peekTokenTime  3

@interface SSLineBreaker ()

@property(nonatomic, strong) SSTextShapeParser *parser;

@end

@implementation SSLineBreaker
{
    NSInteger _breakLoopIndex;
}

+ (id) lineBreakerWithOptimalKerning:(CGFloat)optimalKerning
{
    SSLineBreaker *breaker = [[SSLineBreaker alloc] init];
    
    if (optimalKerning >= 0)
    {
        breaker.parser.optimalKerning = optimalKerning;
    }
    return breaker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parser = [[SSTextShapeParser alloc] init];
    }
    return self;
}

- (NSArray *) linesBreakAndUpdate:(NSMutableAttributedString * __strong *)string
                        lineWidth:(CGFloat)lineWidth
                  paragraphRanges:(NSMutableArray *)paragraphRanges
{
    NSMutableAttributedString *attributedString = *string;
    if (!attributedString)
    {
        return nil;
    }
    NSRange currentParagraphRange = [[paragraphRanges firstObject] rangeValue];
    
    //拆分字符，计算字符大小
    [self.parser parseAttributedStringShape:attributedString lineWidth:lineWidth];
    
    _breakLoopIndex = 0;
    NSInteger offset = 0;
    NSInteger length = 0;
    
    NSMutableArray *lineRanges = [NSMutableArray array];
    
    while (offset < attributedString.length)
    {
        DTTextBlock *currentTextBlock = [[attributedString attribute:DTTextBlocksAttribute
                                                             atIndex:offset
                                                      effectiveRange:NULL] lastObject];
        CGFloat width = lineWidth;
        if (currentTextBlock)
        {
            width = width - currentTextBlock.padding.left - currentTextBlock.padding.right;
        }
        
        while (offset >= (currentParagraphRange.location + currentParagraphRange.length) && paragraphRanges.count > 0)
        {
            [paragraphRanges removeObjectAtIndex:0];
            currentParagraphRange = [[paragraphRanges firstObject] rangeValue];
        }
        
        BOOL isAtBeginOfParagraph = (currentParagraphRange.location == offset);
        
        CGFloat headIndent = 0;
        CTParagraphStyleRef paragraphStyle = (__bridge CTParagraphStyleRef)[attributedString attribute:(id)kCTParagraphStyleAttributeName
                                                                                               atIndex:offset
                                                                                        effectiveRange:NULL];
        if (isAtBeginOfParagraph)
        {
            CTParagraphStyleGetValueForSpecifier(paragraphStyle,
                                                 kCTParagraphStyleSpecifierFirstLineHeadIndent,
                                                 sizeof(headIndent),
                                                 &headIndent);
        }
        else
        {
            CTParagraphStyleGetValueForSpecifier(paragraphStyle,
                                                 kCTParagraphStyleSpecifierHeadIndent,
                                                 sizeof(headIndent),
                                                 &headIndent);
        }
        
        width -= headIndent;
        
        length = [self _breakAndUpdateAttributedString:attributedString lineWidth:width];
        
        if (length == 0)
        {
            NSLog(@"error");
        }
        
        if (length == -1 || length == 0)
        {
            break;
        }
        
        NSRange lineRange = NSMakeRange(offset, length);
        NSValue *rangeValue = [NSValue valueWithRange:lineRange];
        [lineRanges addObject:rangeValue];
        
        offset += length;
    }
    return lineRanges;
}

- (NSInteger) _breakAndUpdateAttributedString:(NSMutableAttributedString *)attributedString lineWidth:(CGFloat)lineWidth
{
    NSString *forbidBreakBeforeCharacters = @"`!%,).:;>?]}¢¨°·ˇˉ―‖’”„†‡›℃∶、。〃〆》「『〕〗〞︵︹︽︿﹃﹘﹚﹜！＂％＇），．：；？］｀｜｝～]】";
    NSString *forbidBreakAfterCharacters  = @"(（｛〔〈《「『【〘〖〝‘“｟« ‘ “ ' \"";
    
    CGFloat totalWidth = 0.0f;
    CGFloat totalKerning = 0.0f;
    
    NSInteger words = 0;
    
    NSInteger index = _breakLoopIndex;
    
    NSArray *shapes = self.parser.shapes;
    
    //根据宽度，生成行
    while (index < shapes.count)
    {
        SSTextShape *s = [shapes objectAtIndex:index];
        
        totalWidth += s.width + s.optimalKerning;
        totalKerning += s.optimalKerning;
        words += s.range.length;
        
        index ++;
        
        NSRange nr = [s.text rangeOfString:@"\n"];
        if (nr.location != NSNotFound)
        {
            break;
        }
        
        if (totalWidth > lineWidth)
        {
            break;
        }
    }
    
    //超出的宽度的那一部分要剪掉
    if(index > 0)
    {
        SSTextShape *b = shapes[(index - 1)];
        //如果总的宽度已经超出排版范围，当前行需要去掉最后一个
        if (totalWidth - b.optimalKerning - lineWidth > 0)
        {
            //只有一个字的时候，不处理，有多个的时候才处理
            //向前回退一个
            if (index - _breakLoopIndex > 1)
            {
                totalWidth -= (b.width + b.optimalKerning);
                totalKerning -= b.optimalKerning;
                words -= b.range.length;
                index--;
            }
        }
    }
    
    //处理最后一个字符，特殊字符
    if (index > 0)
    {
        if (index - _breakLoopIndex > 1)
        {
            SSTextShape *s = [shapes objectAtIndex:index - 1];
            
            NSRange nr = [forbidBreakBeforeCharacters rangeOfString:s.text];
            if (nr.location != NSNotFound)
            {
                totalWidth = totalWidth - (s.width + s.optimalKerning);
                totalKerning = totalKerning - s.optimalKerning;
                words = words - s.range.length;
                index --;
            }
        }
    }
    
    //如果这一行只剩下一个字，那么就不再去做首行也尾行的帅选，避免全部帅选完之后，等下0 个字，造成死循环
    if (index - _breakLoopIndex == 1) {
        if(index < shapes.count)
        {
            SSTextShape *s = [shapes objectAtIndex:index];
            NSRange nr = [s.text rangeOfString:@"\n"];
            if (nr.location != NSNotFound)
            {
                index++;
                words += s.range.length;
            }
        }
        _breakLoopIndex = index;
        return words;
    }
    
    //这里处理尾部字，不属于那些指定的
    NSInteger forwardPeek = 0;
    while (forwardPeek < peekTokenTime)
    {
        if (index > 0)
        {
            SSTextShape *s = [shapes objectAtIndex:index - 1];
            NSRange nr = [forbidBreakAfterCharacters rangeOfString:s.text];
            if (nr.location != NSNotFound)
            {
                totalWidth -= (s.width + s.optimalKerning);
                totalKerning -= s.optimalKerning;
                words -= s.range.length;
                index --;
            }
        }
        forwardPeek ++;
    }
    
    
    CGFloat strech = totalWidth - lineWidth;
    CGFloat elasticRate = (totalKerning - strech) / totalKerning;
    if (elasticRate <= maxElasticRate)
    {
        for (NSInteger i = _breakLoopIndex; i < index; i++)
        {
            SSTextShape *s = [shapes objectAtIndex:i];
            s.kerning = s.optimalKerning * elasticRate;
            NSInteger nextBlankIndex = s.range.location + s.range.length - 1;
            if (nextBlankIndex < attributedString.length)
            {
                [attributedString addAttribute:(NSString *)kCTKernAttributeName
                                         value:[NSNumber numberWithFloat:s.kerning]
                                         range:NSMakeRange(nextBlankIndex, 1)];
            }
        }
    }
    
    NSInteger peek = 0;
    NSInteger stepIn = 0;
    //这里的效果就是逗号那些都在外面
    while (peek < peekTokenTime)
    {
        if(index < shapes.count)
        {
            SSTextShape *s = [shapes objectAtIndex:index];
            NSRange foundRange = [forbidBreakBeforeCharacters rangeOfString:s.text];
            if (foundRange.location != NSNotFound)
            {
                stepIn++;
                index++;
                words += s.range.length;
                totalWidth += s.width + s.optimalKerning;
                totalKerning += s.optimalKerning;
            }
        }
        peek++;
    }
    //如果有处理 在尾部保留 符号那些，需要重新计算字距
    if(stepIn > 1)
    {
        if(index > 1)
        {
            SSTextShape *s = [shapes objectAtIndex:index - 1];
            totalWidth -= (s.width + s.optimalKerning);
            totalKerning -= s.optimalKerning;
            float strech = totalWidth - lineWidth;
            float elasticRate = (totalKerning - strech) / totalKerning;
            if(elasticRate <= maxElasticRate)
            {
                for(NSInteger i = _breakLoopIndex; i < index - 1; i++)
                {
                    SSTextShape *s = [shapes objectAtIndex:i];
                    s.kerning = s.optimalKerning * elasticRate;
                    NSInteger nextBlankIndex = s.range.location + s.range.length - 1;
                    if(nextBlankIndex < attributedString.length)
                    {
                        [attributedString addAttribute:(NSString*)kCTKernAttributeName
                                                 value:[NSNumber numberWithFloat:s.kerning]
                                                 range:NSMakeRange(nextBlankIndex, 1)];
                    }
                }
            }
        }
    }
    
    if(index < shapes.count)
    {
        SSTextShape *s = [shapes objectAtIndex:index];
        NSRange foundRange = [s.text rangeOfString:@"\n"];
        if (foundRange.location != NSNotFound)
        {
            index++;
            words += s.range.length;
        }
    }
    _breakLoopIndex = index;
    
    return words;
}

@end
