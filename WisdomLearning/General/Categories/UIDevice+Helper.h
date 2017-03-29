//
//  UIDevice+Helper.h
//  ZONRY_Client
//
//  Created by wayne on 16/3/22.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Helper)

+ (NSString *)ua;
+ (NSUInteger)machine;
+ (NSString *)OSVer;
+ (NSString *)deviceName;
+ (NSString *)platformString:(NSUInteger)platform;
+ (NSString *)imei;

+ (CGSize)screenResolution;

+ (BOOL)isMultitaskingCapable;

@end
