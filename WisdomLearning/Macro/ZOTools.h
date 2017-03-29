//
//  ZOTools.h
//  ZONRY_Client
//
//  Created by wayne on 16/3/24.
//  Copyright © 2016年 Razi. All rights reserved.
//

#ifndef ZOTools_h
#define ZOTools_h

NS_INLINE NSString* appVersion(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NS_INLINE NSString* appId()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

NS_INLINE NSString* deviceType()
{
    return [[UIDevice currentDevice] model];
}

NS_INLINE NSString* deviceUUIDString()
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

NS_INLINE NSString* deviceOS()
{
    return [[UIDevice currentDevice] systemName];
}

NS_INLINE NSString* deviceOSVersion()
{
    return [[UIDevice currentDevice] systemVersion];
}

NS_INLINE NSString* cachesDirectory()
{
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
}

NS_INLINE NSString* documentsDirectory()
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

NS_INLINE NSString* documentsPathOfFile(NSString* filename)
{
    return [documentsDirectory() stringByAppendingPathComponent:filename];
}

NS_INLINE NSString* libraryFileDirectory()
{
    return [documentsDirectory() stringByAppendingPathComponent:@"Library"];
}

// 照片原图路径
NS_INLINE NSString* originalPhotoImagePath()
{
    return [cachesDirectory() stringByAppendingPathComponent:@"OriginalPhotoImages"];
}

NS_INLINE NSURL* reportPathURL()
{
    return [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:@"Reports"];
}

/**
 *  时间戳
 *
 *  @return HHmmss
 */
NS_INLINE NSString* timestamp(void)
{
    NSDateFormatter* formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HHmmss";
    return [formatter stringFromDate:[NSDate date]];
}

/**
 *  请求加密Key
 *
 *  @return NSString
 */
NS_INLINE NSString* requestEncryptKey(void)
{
    NSString* str = timestamp();
    str = [str substringFromIndex:3];
    return [NSString stringWithFormat:@"%@%@", @"x%73z", str];
}

NS_INLINE bool FloatNumberIsZero(double f)
{
    return -0.000001 < f && f < 0.000001;
}

#endif /* ZOTools_h */
