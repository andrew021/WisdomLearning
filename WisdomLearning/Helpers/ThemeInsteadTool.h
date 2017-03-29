//
//  ThemeInsteadTool.h
//  ThemeInsteadTest
//
//  Created by laidianhuo on 25/10/2016.
//  Copyright © 2016 laidianhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeInsteadTool : NSObject


/**
 *    @brief  根据资源文件获取主题颜色
 *
 *    @return 主题颜色
 */
//+ (UIColor *)themeColor;

/**
 *    @brief  根据资源文件名获取图片
 *
 *    @param imageName 本地资源文件图片名称
 *
 *    @return 资源图片
 */
+ (UIImage *)imageWithImageName:(NSString *)imageName;

@end
