//
//  Macro.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//-------------------获取SIZE大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT 44
//获取屏幕 宽度、高度
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define TabBarHeight self.tabBarController.tabBar.bounds.size.height
#define ViewWidth(v) v.frame.size.width
#define ViewHeight(v) v.frame.size.height
#define ViewX(v) v.frame.origin.x
#define ViewY(v) v.frame.origin.y
#define ViewMaxX(v) CGRectGetMaxX(v.frame)
#define ViewMaxY(v) CGRectGetMaxY(v.frame)
#define SelfViewWidth self.view.bounds.size.width
#define SelfViewHeight self.view.bounds.size.height
#define RectX(f) f.origin.x
#define RectY(f) f.origin.y
#define RectWidth(f) f.size.width
#define RectHeight(f) f.size.height
#define RectSetWidth(f, w) CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h) CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x) CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y) CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h) CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y) CGRectMake(x, y, RectWidth(f), RectHeight(f))

#define Default_Icon_Url  @"http://www.witfore.com/fileserver/uploadfile/avatar/photo.jpg"

//判断设备
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//-------------------获取SIZE大小-------------------------

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#define ULog(fmt, ...)                                                                                                                                                                                                                                            \
{                                                                                                                                                                                                                                                             \
UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; \
[alert show];                                                                                                                                                                                                                                             \
}
#else
#define ULog(...)
#endif
//---------------------打印日志--------------------------

//----------------------系统----------------------------

//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

#define WS(weakSelf) __weak typeof(self) weakSelf = self;


// 单例宏
// ## : 连接字符串和参数
#define singleton_h(name) +(instancetype)shared##name;
#if __has_feature(objc_arc) // ARC
#define singleton_m(name)                           \
static id _instance;                            \
+(id)allocWithZone : (struct _NSZone*)zone      \
{                                               \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [super allocWithZone:zone]; \
});                                         \
return _instance;                           \
}                                               \
+(instancetype)shared##name                     \
{                                               \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [[self alloc] init];        \
});                                         \
return _instance;                           \
}                                               \
+(id)copyWithZone : (struct _NSZone*)zone       \
{                                               \
return _instance;                           \
}
#else // 非ARC
#define singleton_m(name)                           \
static id _instance;                            \
+(id)allocWithZone : (struct _NSZone*)zone      \
{                                               \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [super allocWithZone:zone]; \
});                                         \
return _instance;                           \
}                                               \
\
+(instancetype)shared##name                     \
{                                               \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [[self alloc] init];        \
});                                         \
return _instance;                           \
}                                               \
\
-(oneway void)release                           \
{                                               \
}                                               \
\
-(id)autorelease                                \
{                                               \
return _instance;                           \
}                                               \
\
-(id)retain                                     \
{                                               \
return _instance;                           \
}                                               \
\
-(NSUInteger)retainCount                        \
{                                               \
return 1;                                   \
}                                               \
\
+(id)copyWithZone : (struct _NSZone*)zone       \
{                                               \
return _instance;                           \
}
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
//----------------------系统----------------------------

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file, ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R / 255.0 green:G / 255.0 blue:B / 255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

#pragma mark - color functions
#define RGBCOLOR(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1]
#define RGBACOLOR(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a)]

//----------------------颜色类--------------------------

#define Int2String(i) [NSString stringWithFormat:@"%zd", i]
//#define long2String(i) [NSString stringWithFormat:@"%lu", i]
#define Float2String(f) [NSString stringWithFormat:@"%f", f]
#define Double2String(ld) [NSString stringWithFormat:@"%ld", ld]


#define Hint(text, hint)  \
if(!text || !text.length)     \
{                  \
[self showHint:hint]; \
return;        \
}

#endif /* Macro_h */
