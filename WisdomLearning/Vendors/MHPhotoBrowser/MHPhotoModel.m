//
//  MHPhotoModel.m
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import "MHPhotoModel.h"

@implementation MHPhotoModel

+ (MHPhotoModel *)photoWithImage:(UIImage *)image {
    return [[MHPhotoModel alloc] initWithImage:image];
}

+ (MHPhotoModel *)photoWithURL:(NSURL *)url {
    return [[MHPhotoModel alloc] initWithURL:url];
}


- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        _image = image;
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _photoURL = [url copy];
    }
    return self;
}

@end
