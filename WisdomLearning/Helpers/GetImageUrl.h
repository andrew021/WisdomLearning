//
//  GetImageUrl.h
//  BigMovie
//
//  Created by DiorSama on 16/5/23.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetImageUrl : NSObject
// 获取图片url
+ (NSString*)getImageUrl:(NSString*)url;
//获取多张图片url
+(NSArray*)getImagesUrl:(NSString *)url;

+(NSString*)cutImageUrl:(NSString*)url;
//获取时间
+(NSString*)cutTimeStr:(NSString*)str;

//阿拉伯数字转化汉字数字
+(NSString *)translation:(long long)arebic;

//获取热门标签
+(NSArray*)getHotTags:(NSString *)tag;

+(NSString*)cutImagesUrl:(NSArray *)array;



// 压缩到指定大小的图片
+ (UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

// 简单的 等比例压缩图片
+ (UIImage *) imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize) newSize;

//  等比例压缩图片
+ (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

//  等比例压缩图片
+ (UIImage *) imageCompressForScaleWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

// 根据压缩系数 压缩图片 等比例压缩图片对于每张图片进行压缩，其实有一个最小值，此后无论再怎么改小压缩系数都无济于事。如果还是过大，只能裁剪图片了。
+ (NSData *)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

//
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

@end
