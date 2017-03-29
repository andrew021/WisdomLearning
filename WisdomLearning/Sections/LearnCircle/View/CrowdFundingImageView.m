//
//  CrowdFundingImageView.m
//  BigMovie
//
//  Created by DiorSama on 16/6/12.
//  Copyright © 2016年 zhisou. All rights reserved.
//



#import "SDPhotoBrowser.h"
#import "CrowdFundingImageView.h"

#define kPadding 3.0
#define kWidth 100.0

@interface CrowdFundingImageView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray<UIImageView*>* imageViews;
@property (nonatomic, assign) CGFloat imageWidth;

@end

@implementation CrowdFundingImageView

- (instancetype)initWithFrame:(CGRect)frame withWidth:(CGFloat)width
{
    //固定宽度
    //    frame.size.width = 3 * 100.0 + 2 * kPadding;
    self = [super initWithFrame:frame];
    if (self) {
        _imageWidth = width;
        _imageArrays = [NSArray new];
    }
    return self;
}

- (void)setImageArrays:(NSArray*)imageArrays
{
    _imageArrays = imageArrays;
    
    NSInteger picsCount = [imageArrays count];
    
    //  picsCount = (picsCount <= 9) ? picsCount : 9;
    
    for (int i = 0; i < picsCount; i++) {
        UIImageView* imageView = _imageViews[i];
        if (!imageView) {
            imageView = [UIImageView new];
            
            [_imageViews addObject:imageView];
        }
 
        CGPoint origin = { 0 };
        origin.x = (i % 3) * (kPadding + _imageWidth);
        origin.y = (i / 3) * (kPadding + _imageWidth);
        CGRect frame = {.origin = origin, .size = { _imageWidth, _imageWidth } };
    
        [imageView setFrame:frame];
        [imageView sd_setImageWithURL:[imageArrays[i] stringToUrl] placeholderImage:kPlaceDefautImage];
      //  imageView.image = [UIImage imageNamed:imageArrays[i]];
        imageView.tag = i;

      
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
}


- (void)tapImage:(UITapGestureRecognizer*)tap
{
   
    UIView* imageView = tap.view;
    SDPhotoBrowser* browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;

    browser.imageCount = _imageArrays.count;
    browser.delegate = self;
    [browser show];
}

#pragma mark - SDPhotoBrowserDelegate

//- (NSURL*)photoBrowser:(SDPhotoBrowser*)browser highQualityImageURLForIndex:(NSInteger)index
//{
////    NSString* imageName = [GetImageUrl getImageUrl:_imageArrays[index]];
////    NSString *urlStr = [imageName stringByReplacingOccurrencesOfString:@"_SMALL" withString:@""];
////    NSURL *url = [NSURL URLWithString:urlStr];
////    NSURL* url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
//   // NSURL * url = [NSURL URLWithString:imageName];
//  //  return url;
//}

- (UIImage*)photoBrowser:(SDPhotoBrowser*)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView* imageView = self.subviews[index];
    return imageView.image;
}


#pragma mark - SDPhotoBrowserDelegate

+ (CGFloat)getImagesGirdViewHeight:(NSArray*)imgs withWidth:(CGFloat)width
{
    
    
    NSInteger picsCount = [imgs count];
    if(picsCount == 0){
        return 0;
    }
    else{
        if(picsCount %3 ==0){
            return (picsCount / 3) * width / 3 + (picsCount / 3) * kPadding;
            
        }
        else{
            return (picsCount / 3 + 1) * width / 3 + (picsCount / 3+1) * kPadding;
        }
        
    }
}

//- (void)selectImage:(UIButton*)sender
//{
//    if (self.delegate) {
//        [self.delegate selectLogImage];
//    }
//}

@end