//
//  ZSHorThreeImagesView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSHorThreeImagesView.h"

#import "MHPhotoBrowserController.h"
#import "MHPhotoModel.h"
#import "SDPhotoBrowser.h"

//#define kPadding 3.0
//#define kWidth 100.0

@interface ZSHorThreeImagesView()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray<UIImageView*>* imageViews;
@property (nonatomic, assign) CGFloat horizontalSpacing;
@property (nonatomic, assign) CGFloat verticalSpacing;
@property (nonatomic, assign) CGFloat padding;

@end

@implementation ZSHorThreeImagesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame withPadding:(CGFloat)padding withHorizontalSpacing:(CGFloat)horizontalSpacing withVerticalSpacing:(CGFloat)verticalSpacing
{
    //固定宽度
    //    frame.size.width = 3 * 100.0 + 2 * kPadding;
    self = [super initWithFrame:frame];
    if (self) {
        _horizontalSpacing = horizontalSpacing;
        _padding = padding;
        _verticalSpacing = verticalSpacing;
        _images = [NSArray new];
    }
    return self;
}

-(void)setImages:(NSArray *)images{
    _images = images;
    float imageWidth = (CGRectGetWidth(self.frame)-2*_padding-2*_horizontalSpacing)/3;
    
    __block CGPoint origin = {_padding, 0};
    for (int index = 0; index < images.count; ++index) {
        UIImageView* imageView = _imageViews[index];
        if (!imageView) {
            imageView = [UIImageView new];
            
            [_imageViews addObject:imageView];
        }
        
        int nowHeight = imageWidth;
        CGRect frame = {.origin = origin, .size = { imageWidth, nowHeight}};
        
        [imageView setFrame:frame];
        
        [self addSubview:imageView];
        imageView.tag = index;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        
        NSString *url = images[index];
        if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
            NSLog(@"%@", url);
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }else{
            UIImage *image = [UIImage imageNamed:images[index]];
            [imageView setImage:image];
        }
        
        origin.x = ((index+1)%3==0) ? _padding:(origin.x+(_horizontalSpacing+imageWidth));
        origin.y = ((index+1)%3==0) ? (origin.y+nowHeight+_verticalSpacing):(origin.y);
    }
}



- (void)tapImage:(UITapGestureRecognizer*)tap
{
    
    UIView* imageView = tap.view;
    SDPhotoBrowser* browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    
    browser.imageCount = _images.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

- (UIImage*)photoBrowser:(SDPhotoBrowser*)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView* imageView = self.subviews[index];
    return imageView.image;
}


#pragma mark - SDPhotoBrowserDelegate

+ (CGFloat)getHorThreeImagesViewHeight:(NSArray*)imgs withWidth:(CGFloat)nowWidth withVerticalSpacing:(CGFloat)verticalSpacing
{
    CGFloat totalHeight = 0;
    NSInteger picsCount = [imgs count];
    if(picsCount == 0){
        return totalHeight;
    }else{
//        NSString *url = imgs[0];
//        UIImage *image = nil;
//        if ([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) {
//            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//        }else{
//            image = [UIImage imageNamed:imgs[0]];
//        }
//        int width=image.size.width;
//        int height=image.size.height;
        
//        int nowHeight = height * (nowWidth)/width;
        if (imgs.count % 3 == 0) {
            totalHeight = (imgs.count / 3)*(nowWidth+verticalSpacing);
        }else{
            totalHeight = (imgs.count / 3 + 1)*(nowWidth+verticalSpacing);
        }
    }
    return totalHeight + 20;
}


@end
