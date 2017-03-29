//
//  SSImageButton.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSImageButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "SSImageObject.h"

@implementation SSImageButton
{
    CGFloat _width;
    CGFloat _height;
}

- (void) setImageObject:(SSImageObject *)imageObject
{
    _imageObject = imageObject;
    self.contentMode = UIViewContentModeCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    __weak __typeof(self) weakself = self;
    [self sd_setImageWithURL:imageObject.url forState:UIControlStateNormal placeholderImage:imageObject.placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakself imageDidLoad];
    }];
}

- (void) imageDidLoad
{
    UIImage *image = [self imageForState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(didLoadImage:didChangeImageSize:)]) {
        [self.delegate didLoadImage:self didChangeImageSize:image.size];
    }
}

@end
