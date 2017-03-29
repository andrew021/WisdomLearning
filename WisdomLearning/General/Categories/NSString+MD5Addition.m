//
//  NSString+MD5Addition.m
//  App58ForIphone
//
//  Created by cxk on 12-2-20.
//  Copyright (c) 2012年 __SUN__. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5Addition)

- (NSString *)string02XFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
#if 0
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
#else
    const char *cStr = [self UTF8String];
    unsigned char result[20];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
#endif
}

- (NSData *)stringFromMD5
{
    const char *src = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(src, strlen(src), result);
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

@end
