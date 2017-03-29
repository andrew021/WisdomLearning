//
//  SSPlayerView.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

extern NSString *SSPlayerViewWillZoomOutFullScreenNotification;
extern NSString *SSPlayerViewWillZoomInNormalScreenNotification;
extern NSString *SSPlayerViewDidZoomOutFullScreenNotification;
extern NSString *SSPlayerViewDidZoomInNormalScreenNotification;
extern NSString *SSPlayerViewPlayErrorNotification;

@protocol SSPlayerViewDelegate <NSObject>

- (void) playerViewPlay;
- (void) playerViewPause;

@end

@interface SSPlayerView : UIView

@property(nonatomic, weak) id<SSPlayerViewDelegate> delegate;
/**
 *  父scrollview
 */
@property(nonatomic) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *playerItem;

- (id) initWithFrame:(CGRect)frame url:(NSURL *)url;
- (id) initWithFrame:(CGRect)frame asset:(AVAsset *)asset;

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) AVURLAsset *asset;
@property(nonatomic, assign) BOOL autoplay;

- (void) setBackgroundImageUrl:(NSString *)url placeholderImage:(UIImage *)image;

- (void) play;
- (void) pause;

@end
