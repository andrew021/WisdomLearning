//
//  MHPhotoCollectionCell.m
//  图片浏览器
//
//  Created by LMH on 16/3/10.
//  Copyright © 2016年 LMH. All rights reserved.
//

#import "MHPhotoCollectionCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MHPhotoBrowserController.h"
#import "UIImageView+WebCache.h"
//#import "SVProgressHUD.h"

@interface MHPhotoCollectionCell()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) UIGestureRecognizer *recognizer;
@end

@implementation MHPhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        frameRect = frame;
        [self createView];
        
        // 单击的 Recognizer
        UITapGestureRecognizer *singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        
        // 双击的 Recognizer
        UITapGestureRecognizer *doubleRecognizer;
        doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
        doubleRecognizer.numberOfTapsRequired = 2; // 双击
        [self addGestureRecognizer:doubleRecognizer];
        
        // 关键在这一行，如果双击确定偵測失败才會触发单击
        [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
        
        // 双击的 Recognizer
        UILongPressGestureRecognizer *longPress;
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressFrom:)];
        longPress.minimumPressDuration = 1.0; // 长按最小时间
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer *)tap
{
    MHPhotoBrowserController *con = (MHPhotoBrowserController*)self.viewController;
    if ([con isKindOfClass:[MHPhotoBrowserController class]]) {
        [con performSelector:@selector(singleTapDetected) withObject:nil afterDelay:0.2];
    }
#ifdef DEBUG
    NSLog(@"触发 单击事件了");
#endif
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)tap
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewController];
    [self photoViewZoomWithPoint:[tap locationInView:self.photoView]];
#ifdef DEBUG
    NSLog(@"触发 双击事件了");
#endif
}

- (void)handleLongPressFrom:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        if (self.photoView.image == nil) {
            return;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否保存图片到相册?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];

#ifdef DEBUG
        NSLog(@"触发 长按事件了");
#endif
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UIImageWriteToSavedPhotosAlbum(self.photoView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo
{
    if (error == nil) {
       // [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}

- (void)createView
{
    self.imgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, frameRect.size.height)];
    self.imgScrollView.delegate = self;
    //设置最大伸缩比例
    self.imgScrollView.maximumZoomScale = 5.0;
    //设置最小伸缩比例
    self.imgScrollView.minimumZoomScale = 1;
    [self addSubview:self.imgScrollView];
    
    self.photoView = [[MHTapImgView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.photoView.delegate = self;
    [self.imgScrollView addSubview:self.photoView];

    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.loadingIndicator.hidesWhenStopped = NO;
    [self.loadingIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.loadingIndicator setCenter:CGPointMake((self.imgScrollView.frame.size.width)/2.0, ([[UIScreen mainScreen] bounds].size.height)/2.0)];
//    [self.loadingIndicator setCenter:CGPointMake((self.imgScrollView.frame.size.width)/2.0, (self.imgScrollView.frame.size.width)/2.0)];
    [self.imgScrollView addSubview:self.loadingIndicator];
}

//告诉scrollview要缩放的是哪个子控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = frameRect.size;
    CGRect frameToCenter = self.photoView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    }
    else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    }
    else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.photoView.frame, frameToCenter)){
        self.photoView.frame = frameToCenter;
    }
}

- (void)reloadCellWith:(MHPhotoModel*)photo
{
    __weak typeof(self) weakSelf = self;
    [self.loadingIndicator stopAnimating];
    [self.imgScrollView setZoomScale:1];
    
    if (photo.image) {
        [self.photoView setImage:photo.image];
        [self changeImageFrameWithImage:photo.image];
    }
    else if (photo.photoURL) {
        if ([[[photo.photoURL scheme] lowercaseString] isEqualToString:@"assets-library"]) {
            
            ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:photo.photoURL
                           resultBlock:^(ALAsset *asset){
                               ALAssetRepresentation *rep = [asset defaultRepresentation];
                               CGImageRef iref = [rep fullScreenImage];
                               if (iref) {
                                   UIImage *img = [UIImage imageWithCGImage:iref];
                                   [weakSelf.photoView setImage:img];
                               }
                           }
                          failureBlock:^(NSError *error) {
                              
                          }];
            
        }
        else if ([photo.photoURL isFileURL]) {
            UIImage *img = [UIImage imageWithContentsOfFile:photo.photoURL.path];
            [self.photoView setImage:img];
            
        }
        else {
            BOOL imgExists = [[SDWebImageManager sharedManager] diskImageExistsForURL:photo.photoURL];
            if (!imgExists) {
                [self.loadingIndicator startAnimating];
            }
//            [self.photoView sd_setImageWithURL:photo.photoURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [weakSelf.loadingIndicator stopAnimating];
//                UIImage *img = (image == nil ? weakSelf.photoView.image:image);
//                
//                if (img) {
//                    [weakSelf changeImageFrameWithImage:img];
//                }
//                else {
//                    NSLog(@"图片加载失败-----");
//                }
//            }];
        }
    }
}

//改变图片frame
- (void)changeImageFrameWithImage:(UIImage *)image
{
    CGSize newSize = image.size;
    if (newSize.width > frameRect.size.width) {
        float ratio = frameRect.size.width/newSize.width;
        newSize.width = frameRect.size.width;
        newSize.height = floorf(newSize.height *ratio);
    }
    else if (newSize.height > frameRect.size.height) {
        float ratio = frameRect.size.height/newSize.height;
        newSize.height = frameRect.size.height;
        newSize.width = floorf(newSize.width *ratio);
    }
    
    [self.photoView setFrame:CGRectMake(0, 0, newSize.width, newSize.height)];
    [self.photoView setCenter:CGPointMake((self.imgScrollView.frame.size.width)/2.0, (self.imgScrollView.frame.size.height)/2.0)];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
            [self handleSingleTap:touch];
            break;
        case 2:
            [self handleDoubleTap:touch];
            break;
        default:
            break;
    }
}

- (void)handleSingleTap:(UITouch *)touch {
    MHPhotoBrowserController *con = (MHPhotoBrowserController*)self.viewController;
    if ([con isKindOfClass:[MHPhotoBrowserController class]]) {
        [con performSelector:@selector(singleTapDetected) withObject:nil afterDelay:0.2];
    }
}

- (void)handleDoubleTap:(UITouch *)touch {
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewController];
    [self photoViewZoomWithPoint:[touch locationInView:self.photoView]];
}

- (void)photoViewZoomWithPoint:(CGPoint)touchPoint {
    if (self.imgScrollView.zoomScale != self.imgScrollView.minimumZoomScale) {
        [self.imgScrollView setZoomScale:self.imgScrollView.minimumZoomScale animated:YES];
    }
    else {
        CGFloat newZoomScale = ((self.imgScrollView.maximumZoomScale + self.imgScrollView.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self.imgScrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];     
    }
}

- (UIViewController*)viewController
{
    UIResponder *nextResponder = self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

@end
