//
//  MHPhotoModel.h
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHPhotoModel : NSObject

@property (nonatomic,strong) NSString *caption;
@property (nonatomic,readonly) UIImage *image;
@property (nonatomic,readonly) NSURL *photoURL;

+ (MHPhotoModel *)photoWithImage:(UIImage *)image;
+ (MHPhotoModel *)photoWithURL:(NSURL *)url;

- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;

@end
