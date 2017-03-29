//
//  NSString+Utilities.m
//  ZONRY_Client
//
//  Created by wayne on 16/3/24.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import "NSString+Utilities.h"
#import "NSString+MD5Addition.h"
#import <sys/stat.h>

@implementation NSString (Utilities)

- (NSString *)firstCharacter
{
  if (self.length > 0) {
    return [self substringToIndex:1];
  }
  
  return nil;
}

- (NSString *)lastCharacter
{
  if (self.length > 0) {
    return [self substringWithRange:NSMakeRange(self.length - 1, 1)];
  }
  
  return nil;
}

- (NSString*)URLEncode
{
  // !   @   $   &   (   )   =   +   ~   `   ;   '   :   ,   /   ?
  //%21 %40 %24 %26 %28 %29 %3D %2B %7E %60 %3B %27 %3A %2C %2F %3F
  
  NSArray *escapeChars  = @[
                            @";"  , @"/"  , @"?"  , @":"  , @"@"  , @"&"  ,
                            @"="  , @"+"  , @"$"  , @","  , @"!"  , @"'"  ,
                            @"("  , @")"  , @"*"
                            ];
  NSArray *replaceChars = @[
                            @"%3B", @"%2F", @"%3F", @"%3A", @"%40", @"%26",
                            @"%3D", @"%2B", @"%24", @"%2C", @"%21", @"%27",
                            @"%28", @"%29", @"%2A"
                            ];
  
  NSInteger len = [escapeChars count];

  NSString *tempStr = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSMutableString *temp = [NSMutableString stringWithString:tempStr];
  
  for (int i = 0; i < len; i++) {
    [temp replaceOccurrencesOfString:escapeChars[i]
                          withString:replaceChars[i]
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [temp length])];
  }
  
  NSString *outStr = [NSString stringWithString:temp];
  
  return outStr;
}

- (NSString *)URLDecode
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

-(NSString *)base64Encode{
    NSData *nsdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    return base64Encoded;
}

-(NSString *)base64Decode{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    
    // Decoded NSString from the NSData
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;

}

- (CGFloat)CGFloatValue
{
#if defined(__LP64__) && __LP64__
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize constrainedToWidth:(CGFloat)width
{
    CGSize size = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]
                   constrainedToSize:CGSizeMake(width, MAXFLOAT)
                       lineBreakMode:NSLineBreakByWordWrapping];
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

- (CGFloat)heightWithFontSize:(CGFloat)fontSize constrainedToWidth:(CGFloat)width
{
    return [self sizeWithFontSize:fontSize constrainedToWidth:width].height;
}

- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if (font) {
        CGRect bounds = [self boundingRectWithSize:size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
        CGSize size = bounds.size;
        return CGSizeMake(ceil(size.width), ceil(size.height));
    } else {
        return CGSizeZero;
    }
}

- (NSString *)firstAlphabet
{
  NSString *alphabet;
  
  int charCode = [self characterAtIndex:0];
  if (charCode < 65 || (charCode > 90 && charCode < 97) || charCode > 122) {
    alphabet =  @"#";
  }
  else {
    alphabet = [[self firstCharacter] uppercaseString];
  }
  
  return alphabet;
}

- (BOOL)isOneOf:(NSArray *)strings
{
  for (NSString *str in strings) {
    if ([self isEqualToString:str]) {
      return YES;
    }
  }
  
  return NO;
}

static int g_nStringLength = 21;
static int g_nHeadIndex = 6;
static int g_nFootIndex = 2;
static int g_nTimeIntervalLength = 13;

- (long long)longLongValueOfServerString
{
  if (self.length == g_nStringLength &&
      [[self substringToIndex:g_nHeadIndex] isEqualToString:@"/Date("] &&
      [[self substringFromIndex:self.length - g_nFootIndex] isEqualToString:@")/"])
  {
    NSString *timeString = [self substringWithRange:NSMakeRange(g_nHeadIndex, g_nTimeIntervalLength)];
    return [timeString longLongValue];
  }
  
  return 0L;
}

- (long long)fileSize
{
	struct stat st;
	if (lstat([self cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0) {
		return st.st_size;
	}
	return 0;
}


+ (NSString *)stringWithArray:(NSArray *)array
{
  NSMutableString *mulString = [NSMutableString string];
  [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *string = (NSString *)obj;
    [mulString appendFormat:@"%@,", string];
  }];
  NSInteger length = [mulString length];
  if (length > 0) {
    [mulString deleteCharactersInRange:NSMakeRange(length - 1, 1)];
  }
  
  return mulString;
}

- (long long)millionSecondsWithHourMinute {
  NSString *hourStr = [self substringWithRange:NSMakeRange(0, 2)];
  NSString *minuteStr = [self substringWithRange:NSMakeRange(3, 2)];
  NSInteger hour = [hourStr intValue];
  NSInteger minute = [minuteStr intValue];

  return 1000 * (minute * 60 + hour * 3600);
}

+ (NSString *)chineseStringWithNum:(NSInteger)num
{
  switch (num) {
    case 0:
      return @"零";
    case 1:
      return @"一";
    case 2:
      return @"二";
    case 3:
      return @"三";
    case 4:
      return @"四";
    case 5:
      return @"五";
    case 6:
      return @"六";
    case 7:
      return @"七";
    case 8:
      return @"八";
    case 9:
      return @"九";
    default:
      return @"";
  }
}

+ (NSString *)getUniqueStrByUUID
{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString ;
    
}

- (NSUInteger)lengthByUnicodeEncoding
{
    return [self lengthByEncoding:NSUnicodeStringEncoding];
}

- (NSUInteger)lengthByEncoding:(NSStringEncoding)encoding
{
    int length = 0;
    char *character = (char *)[self cStringUsingEncoding:encoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:encoding]; i++) {
        if (*character) {
            character++;
            length++;
        } else {
            character++;
        }
    }
    return length;
}

/**
 *  去掉字符串中的数字
 *
 *  @return
 */
- (NSString *)stringDeleteNumbers
{
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]] componentsJoinedByString:@""];
}

/** 查找字符串中所有匹配项 */
- (NSArray *)matchsWithPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:&error];
    if (error) {
        NSLog(@"匹配模式不正确");
        return nil;
    }
    // 匹配所有内容
    NSArray *array = [regex matchesInString:self
                                    options:NSMatchingReportCompletion
                                      range:NSMakeRange(0, self.length)];
    if (array == nil) {
        NSLog(@"没有找到匹配内容");
    }
    return array;
}

- (BOOL)isUnsignedInt
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isUnsignedFloat
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."].invertedSet;
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    NSString *resultStr = [resultArray componentsJoinedByString:@""];
    if (self.length == resultStr.length) {
        return YES;
    } else {
        NSInteger dotCount = 0;
        for (NSString *sort in resultArray) {
            if ([sort isEqualToString:@"."]) {
                dotCount++;
            }
        }
        return dotCount > 1 ? NO : YES;
    }
}

/**
 *  过滤出字母、数字、汉字
 */
- (NSString *)filtrateToAlphanumeric
{
    NSCharacterSet *set = [NSCharacterSet alphanumericCharacterSet].invertedSet;
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    return [resultArray componentsJoinedByString:@""];
}

/**
 *  过滤出字母、汉字
 */
- (NSString *)filtrateToLetter
{
    NSCharacterSet *set = [NSCharacterSet letterCharacterSet].invertedSet;
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    return [resultArray componentsJoinedByString:@""];
}

/**
 *  过滤出数字
 */
- (NSString *)filtrateToNumber
{
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    return [resultArray componentsJoinedByString:@""];
}

/**
 *  过滤掉数字
 */
- (NSString *)filtrateNumber
{
    NSCharacterSet *set = [NSCharacterSet decimalDigitCharacterSet];
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    return [resultArray componentsJoinedByString:@""];
}

/**
 *  过滤掉空格
 */
- (NSString *)filtrateSpaceCharacter
{
    NSCharacterSet *set = [NSCharacterSet whitespaceCharacterSet];
    NSArray *resultArray = [self componentsSeparatedByCharactersInSet:set];
    return [resultArray componentsJoinedByString:@""];
}

/**
 *  是否包含iOS系统表情
 */
+ (BOOL)isContainsSystemEmoji:(NSString *)string {
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                isEomji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
        }
    }];
    return isEomji;
}


/**
 *  根据限制类型返回是否可以继续输入下一个字符
 */
- (BOOL)nextWordCanKeepInput:(NSString *)nextWord withStringLimitType:(XZStringLimitType)limitType{

    
    if (limitType == XZStringLimitTypeOnlyOnlyDecimal) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."]invertedSet];
        NSCharacterSet *cs2 = [[NSCharacterSet characterSetWithCharactersInString:@"."] invertedSet];
        NSCharacterSet *cs3 = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        NSString *filtered;
        if ([self.firstCharacter isEqualToString:@"0"]) {
            
            if ([self hasPrefix:@"0."]) {
                //如果前两个字符是“0.”,则可继续输入其他数字
                filtered = [[nextWord componentsSeparatedByCharactersInSet:cs3]componentsJoinedByString:@""];
            }else{
                //如果首字母是0，其后只能输入小数点
                filtered = [[nextWord componentsSeparatedByCharactersInSet:cs2]componentsJoinedByString:@""];
            }
        }else{
            //如果已经包含"."，其后只能输入数字
            NSRange rang = [self rangeOfString:@"."];
            if (rang.location != NSNotFound) {
                filtered = [[nextWord componentsSeparatedByCharactersInSet:cs3]componentsJoinedByString:@""];
            }else{
                //按cs分离出数组,数组按@""分离出字符串
                filtered = [[nextWord componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
            }
        }
        
        BOOL canKeepInput = [nextWord isEqualToString:filtered];
        
        return canKeepInput;
        
    }else if(limitType == XZStringLimitTypeOnlyNumber){
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        
        NSString *filtered = [[nextWord componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
        
        return [nextWord isEqualToString:filtered];
        
    }else{
        return YES;
    }
    
}


/**
 *  过滤出小数点后X位
 */
- (NSString *)filtrateCountDigitsAfterTheDecimalPoint:(NSUInteger)count{
    NSString *string = self.length > 0 ? self : @"";
    NSRange rang = [string rangeOfString:@"."];
    if (rang.location != NSNotFound) {
        
        //如果第一位就是".",再在第一位补上"0"
        if ([string.firstCharacter isEqualToString:@"."]) {
            string = [NSString stringWithFormat:@"0%@",string];
        }
        
        //如果最后一位是".",则去掉最后一位
        if ([string.lastCharacter isEqualToString:@"."]) {
            string = [string substringToIndex:string.length - 1];
        }
        
        NSRange range = [string rangeOfString:@"."];
        if (range.location != NSNotFound) {
            NSUInteger toIndex = range.location + count + 1 >= string.length ? string.length : range.location + count + 1;
            string = [string substringToIndex:toIndex];
        }
    }
    return string;
}

+ (NSString *)randomString {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *currDateStr = [dateFormat stringFromDate:[NSDate date]];
    
    NSInteger randomNum = arc4random();
    NSString *str = [NSString stringWithFormat:@"random%zd%@",randomNum,currDateStr];
    
    NSString *md5Str = [str string02XFromMD5];
    
    return md5Str;
}

+ (NSString *)randomString:(NSInteger)length {
    char data[length];
    for (int x = 0; x<length; data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

-(NSString *)timeString2DateDay{
    if (self == nil || [self isKindOfClass:[NSNull class]] || self.length == 0) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.0"];
    NSDate *date = [dateFormatter dateFromString:self];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}
@end
