//
//  NSString+Category.m
//  WisdomLearning
//
//  Created by Shane on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

-(NSString *)add:(NSString *)theString{
    NSString *sss = self;
    if (self == nil || self == [NSNull class]) {
        sss = @"";
    }
    if (theString == nil || theString == [NSNull class]) {
        theString = @"";
    }
    return [sss stringByAppendingString:theString];
}


-(NSMutableAttributedString *)takeString:(NSString *)sss toColor:(UIColor *)color isBefore:(BOOL)isBefore{
    NSMutableAttributedString *theMutString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:sss];
    if (isBefore) {
        [theMutString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, range.location)];
    }else{
        [theMutString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return theMutString;
}


-(NSURL *)stringToUrl{
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        return [NSURL URLWithString:self];
    }else{
        return [NSURL URLWithString:[gIconHost add:self]];
    }
}

-(NSString*)stringToUserPic
{
    if ([self hasPrefix:@"http"] || [self hasPrefix:@"https"]) {
        return self;
    }else{
        return [NSString stringWithFormat:@"%@%@",gIconHost,self];
    }
}
@end
