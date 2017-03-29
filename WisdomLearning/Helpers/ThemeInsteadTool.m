//
//  ThemeInsteadTool.m
//  ThemeInsteadTest
//
//  Created by laidianhuo on 25/10/2016.
//  Copyright © 2016 laidianhuo. All rights reserved.
//

#import "ThemeInsteadTool.h"

@implementation ThemeInsteadTool





+ (UIImage *)imageWithImageName:(NSString *)imageName{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *settingDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][identifier];
    //获取当前bundleId 对应的sysConfig地址
    //    NSString *sysConfigUrl = settingDict[@"sysConfigUrl"];
    //获取当前bundleId 对应的skin文件夹
    NSString *skinPath = settingDict[@"skinPath"];
    
//    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",skinPath]];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:skinPath ofType:@"bundle"];
    
//    NSString *filePath = [bundlePath stringByAppendingPathComponent:imageName];
//    return [UIImage imageNamed:filePath];
    
    NSBundle *themeBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *imagePath = [themeBundle pathForResource:imageName ofType:@"png"];
    
    return [UIImage imageWithContentsOfFile:imagePath];
}


@end
