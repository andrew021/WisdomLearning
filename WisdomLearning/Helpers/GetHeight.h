//
//  GetHeight.h
//  ElevatorUncle
//
//  Created by DiorSama on 16/6/24.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetHeight : NSObject

//获取带有行间距地label的高度
+(CGFloat)setText:(NSString *)text LineSpacing:(CGFloat)lineSpacing WithWidth:(CGFloat)width;

//计算每行4个图片的高度
+ (CGFloat)getImagesGirdViewHeight:(NSArray*)imgs withWidth:(CGFloat)width isComplete:(BOOL)isComplete;

//根据高度度求宽度  content 计算的内容  Height 计算的高度 font字体大小
+ (CGFloat)getWidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font;

//获取带行间距label的高度 （这个可以实现在 其他事项中自定义cell 的高度 ）
+(CGFloat)hightForText:(NSString *)text andWidth:(CGFloat)width LineSpacing:(CGFloat)lineSpacing;

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
+ (CGFloat)getHeightWithContent:(NSString *)content width:(CGFloat)width font:(CGFloat)font;

//获取年月日
+ (NSString*)getTime:(NSString*)str;

//获取实际的图片数组
+(NSArray*)getAllArr:(NSString*)imageStr videoStr:(NSString*)video voiceStr:(NSString*)voice;

@end
