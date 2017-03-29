//
//  UIDevice+Helper.m
//  ZONRY_Client
//
//  Created by wayne on 16/3/22.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import "UIDevice+Helper.h"
#import <sys/sysctl.h>
#import "UIDevice+IdentifierAddition.h"

#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS"
#define IPHONE_4_NAMESTRING				@"iPhone 4"
#define IPHONE_5_NAMESTRING				@"iPhone 4s"
#define IPHONE_UNKNOWN_NAMESTRING		@"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad 1G"
#define IPAD_2G_NAMESTRING				@"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"

#define APPLETV_2_NAMESTRING            @"APPLE TV2"

#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"


typedef enum {
    UIDeviceUnknown,
    
    UIDeviceiPhoneSimulator,
    UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
    UIDeviceiPhoneSimulatoriPad,
    
    UIDevice1GiPhone,
    UIDevice3GiPhone,
    UIDevice3GSiPhone,
    UIDevice4iPhone,
    UIDevice5iPhone,
    
    UIDevice1GiPod,
    UIDevice2GiPod,
    UIDevice3GiPod,
    UIDevice4GiPod,
    
    UIDevice1GiPad, // both regular and 3G
    UIDevice2GiPad,
    UIDevice3GiPad,
    
    UIDeviceAppleTV2,
    
    UIDeviceUnknowniPhone,
    UIDeviceUnknowniPod,
    UIDeviceUnknowniPad,
    UIDeviceIFPGA,
    
} UIDevicePlatform;

@implementation UIDevice (Helper)

+ (NSString *)imei
{
    //return [[UIDevice currentDevice] uniqueIdentifier];
    NSString *macAdress = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    return macAdress;
}

+ (NSUInteger)machine
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])
        return UIDeviceIFPGA;
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])
        return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])
        return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])
        return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])
        return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])
        return UIDevice5iPhone;
    
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])
        return UIDevice1GiPod;
    if ([platform isEqualToString:@"iPod2,1"])
        return UIDevice2GiPod;
    if ([platform isEqualToString:@"iPod3,1"])
        return UIDevice3GiPod;
    if ([platform isEqualToString:@"iPod4,1"])
        return UIDevice4GiPod;
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])
        return UIDevice1GiPad;
    if ([platform isEqualToString:@"iPad2,1"])
        return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])
        return UIDevice3GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])
        return UIDeviceAppleTV2;
    
    /*
     MISSING A SOLUTION HERE TO DATE TO DIFFERENTIATE iPAD and iPAD 3G.... SORRY!
     */
    
    if ([platform hasPrefix:@"iPhone"])
        return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])
        return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])
        return UIDeviceUnknowniPad;
    
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) // thanks Jordan Breeding
    {
        if ([[UIScreen mainScreen] bounds].size.width < 768)
            return UIDeviceiPhoneSimulatoriPhone;
        else
            return UIDeviceiPhoneSimulatoriPad;
        
        return UIDeviceiPhoneSimulator;
    }
    return UIDeviceUnknown;
}

+ (NSString *)platformString:(NSUInteger)platform
{
    switch (platform)
    {
        case UIDevice1GiPhone:
            return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone:
            return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone:
            return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone:
            return IPHONE_4_NAMESTRING;
        case UIDevice5iPhone:
            return IPHONE_5_NAMESTRING;
        case UIDeviceUnknowniPhone:
            return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod:
            return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod:
            return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod:
            return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod:
            return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod:
            return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad:
            return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad:
            return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad:
            return IPAD_3G_NAMESTRING;
            
        case UIDeviceAppleTV2:
            return APPLETV_2_NAMESTRING;
            
        case UIDeviceiPhoneSimulator:
            return IPHONE_SIMULATOR_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPhone:
            return IPHONE_SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceiPhoneSimulatoriPad:
            return IPHONE_SIMULATOR_IPAD_NAMESTRING;
            
        case UIDeviceIFPGA:
            return IFPGA_NAMESTRING;
            
        default:
            return IPOD_FAMILY_UNKNOWN_DEVICE;
    }
}

+ (NSString *)deviceName {
    return [UIDevice platformString:[UIDevice machine]];
}

+ (NSString *)OSVer {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)ua {
    return [NSString stringWithFormat:@"%@_iOS %@", [UIDevice deviceName], [UIDevice OSVer]];
}

+ (CGSize)screenResolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    float scale = [[UIScreen mainScreen] scale];
    return CGSizeMake(rect.size.width*scale, rect.size.height*scale);
}

+ (BOOL)isMultitaskingCapable {
    UIDevice *device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    
    return backgroundSupported;
}

@end
