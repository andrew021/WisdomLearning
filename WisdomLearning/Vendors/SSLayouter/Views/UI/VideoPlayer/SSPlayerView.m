//
//  SSPlayerView.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSPlayerView.h"
#import "SSPlayerCtrlView.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define kPlayerBgColor = [UIColor blackColor];
NSString *SSPlayerViewWillZoomOutFullScreenNotification = @"SSPlayerViewWillZoomOutFullScreenNotification";
NSString *SSPlayerViewWillZoomInNormalScreenNotification = @"SSPlayerViewWillZoomInNormalScreenNotification";

NSString *SSPlayerViewDidZoomOutFullScreenNotification = @"SSPlayerViewDidZoomOutFullScreenNotification";
NSString *SSPlayerViewDidZoomInNormalScreenNotification = @"SSPlayerViewDidZoomInNormalScreenNotification";

NSString *SSPlayerViewPlayErrorNotification = @"SSPlayerViewPlayErrorNotification";


static int PlayerStatusKVOContext = 0;

static const NSTimeInterval kCtrlFadeOutTime = 5.0f;
static const NSTimeInterval kZoomFullScreenAnimationTime = 0.3f;
static const NSTimeInterval kBufferSizeToContinuePlaying = 3.0f;

@interface SSPlayerView ()<SSPlayerCtrlViewDelegate>

@property(nonatomic, strong) SSPlayerCtrlView *ctrlView;

@property(nonatomic, strong) UIImageView *backgroundImageView;

@property(nonatomic, strong) id playerObserver;

@end

@implementation SSPlayerView
{
    BOOL _isFullScreen;
    CGRect _originalFrame;
    CGRect _keyWindowOriginalFrame;
    NSTimer *_hideCtrlTimer;
    UIView *_originalSuperView;
}


+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *) player
{
    return [((AVPlayerLayer *)self.layer) player];
}

- (void) setPlayer:(AVPlayer *)player
{
    [((AVPlayerLayer *)self.layer) setPlayer:player];
}


- (void)dealloc
{
    _originalSuperView = nil;
    @try {
        
        if (_playerObserver) {
            [self.player removeTimeObserver:_playerObserver];
            _playerObserver = nil;
        }
        
        [self removeObserver:self forKeyPath:@"asset" context:&PlayerStatusKVOContext];
        [self removeObserver:self forKeyPath:@"player.currentItem.duration" context:&PlayerStatusKVOContext];
        [self removeObserver:self forKeyPath:@"player.currentItem.loadedTimeRanges" context:&PlayerStatusKVOContext];
        [self removeObserver:self forKeyPath:@"player.rate" context:&PlayerStatusKVOContext];
        [self removeObserver:self forKeyPath:@"player.currentItem.status" context:&PlayerStatusKVOContext];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (id) initWithFrame:(CGRect)frame url:(NSURL *)url
{
    _url = url;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @(YES)}];
    return [self initWithFrame:frame asset:asset];
}

- (id) initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset
{
    self = [self initWithFrame:frame];
    self.asset = asset;
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initViewFrame:self.bounds];
}

- (void) setUrl:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:@{AVURLAssetPreferPreciseDurationAndTimingKey : @(YES)}];
    self.asset = asset;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initViewFrame:self.bounds];
        self.player = [[AVPlayer alloc] init];
        
        [self addObserver:self forKeyPath:@"asset" options:NSKeyValueObservingOptionNew context:&PlayerStatusKVOContext];
        [self addObserver:self forKeyPath:@"player.currentItem.duration" options:NSKeyValueObservingOptionNew context:&PlayerStatusKVOContext];
        [self addObserver:self forKeyPath:@"player.currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:&PlayerStatusKVOContext];
        [self addObserver:self forKeyPath:@"player.rate" options:NSKeyValueObservingOptionNew context:&PlayerStatusKVOContext];
        [self addObserver:self forKeyPath:@"player.currentItem.status" options:NSKeyValueObservingOptionNew context:&PlayerStatusKVOContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        __weak typeof(self) weakSelf = self;
        self.playerObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            [weakSelf playerPeriodTimeInterval:time];
        }];
    }
    return self;
}

- (void) initView
{
    self.backgroundColor = [UIColor blackColor];
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    self.ctrlView = [[SSPlayerCtrlView alloc] initWithFrame:CGRectZero];
    self.ctrlView.delegate = self;
    [self addSubview:self.ctrlView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideCtrlView)];
    [self addGestureRecognizer:tap];
}

- (void) initViewFrame:(CGRect)frame
{
    self.ctrlView.frame = frame;
}


- (void) setBackgroundImageUrl:(NSString *)url placeholderImage:(UIImage *)image
{
    if (!self.backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self insertSubview:self.backgroundImageView belowSubview:self.ctrlView];
    }
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];

    self.ctrlView.isPlaying = NO;
    _isCtrlViewShown = YES;
    [_hideCtrlTimer invalidate];
    self.ctrlView.alpha = 1;
    NSLog(@"视频播放结束了");
}

- (void) playerPeriodTimeInterval:(CMTime)time
{
    self.ctrlView.currentTime = CMTimeGetSeconds(time);
}

#pragma mark - player ctrl view delegate
- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView playOrPause:(BOOL)isPlay
{
    //判断是否初始化过了，如果没有，先进行初始化
    if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        if (isPlay) {
            if (self.player.rate == 0)
            {
                if (self.backgroundImageView) {
                    [self.backgroundImageView removeFromSuperview];
                    self.backgroundImageView = nil;
                }
                [self.player play];
                if ([self.delegate respondsToSelector:@selector(playerViewPlay)]) {
                    [self.delegate playerViewPlay];
                }
            }
            
        } else {
            if (self.player.rate != 0) {
                [self.player pause];
                if ([self.delegate respondsToSelector:@selector(playerViewPause)]) {
                    [self.delegate playerViewPause];
                }
            }
        }
    }
    [self triggerTimerToHideCtrl];
}


- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView zoomOrScall:(BOOL)isZoom
{
    _isFullScreen = isZoom;
    if (isZoom)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self zoomOutFullScreen];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self zoomInOriginScreen];
    }
}

- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView seekToTime:(NSTimeInterval)second
{
    if (self.player.currentItem.status != AVPlayerItemStatusReadyToPlay)
    {
        return;
    }
    CMTime currentCMTime = CMTimeMake(second, 1);
    [self.player seekToTime:currentCMTime completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

- (void) playerCtrlViewSeeking
{
    [self.player pause];
}


#pragma mark - 全屏和缩小
- (void) zoomOutFullScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SSPlayerViewWillZoomOutFullScreenNotification object:nil userInfo:@{@"SSPlayerView": self}];
    _originalFrame = self.frame;
    _originalSuperView = self.superview;
    //把self 在scrollview 中 的位置，转成 全屏keywindow中的位置
    CGFloat y;
    if ([_originalSuperView isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)_originalSuperView;
        y = _originalFrame.origin.y - scrollView.contentOffset.y + scrollView.frame.origin.y;
    }
    else
    {
        y = _originalFrame.origin.y + _originalSuperView.frame.origin.y;
        if([_originalSuperView.superview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *superScrollView = (UIScrollView *)_originalSuperView.superview;
            y -= (superScrollView.contentOffset.y - superScrollView.frame.origin.y);
        }
    }
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    _keyWindowOriginalFrame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
    self.frame = _keyWindowOriginalFrame;
    
    [UIView animateWithDuration:kZoomFullScreenAnimationTime animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        self.frame = keyWindow.bounds;
    } completion:^(BOOL finished) {
        self.ctrlView.isFullScreen = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:SSPlayerViewDidZoomOutFullScreenNotification object:nil userInfo:@{@"SSPlayerView": self}];
    }];
}

- (void) zoomInOriginScreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SSPlayerViewWillZoomInNormalScreenNotification object:nil userInfo:@{@"SSPlayerView": self}];
    [UIView animateWithDuration:kZoomFullScreenAnimationTime animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = _keyWindowOriginalFrame;
    } completion:^(BOOL finished) {
        [_originalSuperView addSubview:self];
        self.frame = _originalFrame;
        self.ctrlView.isFullScreen = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:SSPlayerViewDidZoomInNormalScreenNotification object:nil userInfo:@{@"SSPlayerView": self}];
    }];
}

#pragma mark - 显示或隐藏控制视图
BOOL _isCtrlViewShown = false;
- (void) showOrHideCtrlView
{
    if (_isCtrlViewShown)
    {
        [self hideCtrlView];
    }
    else
    {
        [self showCtrlView];
    }
}

- (void) hideCtrlView
{
    _isCtrlViewShown = NO;
    [_hideCtrlTimer invalidate];
    [UIView animateWithDuration:0.15 animations:^{
        self.ctrlView.alpha = 0;
    }];
}

- (void) showCtrlView
{
    _isCtrlViewShown = YES;
    [_hideCtrlTimer invalidate];
    [UIView animateWithDuration:0.15 animations:^{
        self.ctrlView.alpha = 1;
    } completion:^(BOOL finished) {
        [self triggerTimerToHideCtrl];
    }];
}

- (void) triggerTimerToHideCtrl
{
    [_hideCtrlTimer invalidate];
    _hideCtrlTimer = [NSTimer scheduledTimerWithTimeInterval:kCtrlFadeOutTime target:self selector:@selector(hideCtrlView) userInfo:nil repeats:NO];
}


#pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (context != &PlayerStatusKVOContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        //[self syncUI];
        if ([keyPath isEqualToString:@"asset"])
        {
            if (self.asset) {
                self.ctrlView.isLoading = YES;
                [self asyncLoadAsset:self.asset];
            }
        }
        else if ([keyPath isEqualToString:@"player.currentItem.duration"])
        {
            NSTimeInterval duration = 0;
            if (CMTIME_IS_NUMERIC(self.player.currentItem.duration)) {
                duration = CMTimeGetSeconds(self.player.currentItem.duration);
            } else {
                duration = -1;
            }
            self.ctrlView.duration = duration;
        }
        else if ([keyPath isEqualToString:@"player.currentItem.loadedTimeRanges"])
        {
            NSTimeInterval duration = 0;
            if (CMTIME_IS_NUMERIC(self.player.currentItem.duration)) {
                duration = CMTimeGetSeconds(self.player.currentItem.duration);
            } else {
                duration = -1;
            }
            self.ctrlView.duration = duration;
            
            if (duration <= 0) {
                return;
            }
            
            NSArray *array = self.player.currentItem.loadedTimeRanges;
            CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
            NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
            self.ctrlView.bufferTime = totalBuffer;
            if (totalBuffer <= currentTime)
            {
                NSLog(@"正在缓冲，显示loading : (buffer : %f, progress : %f)", self.ctrlView.bufferProgress, self.ctrlView.progress);
            } else {
 
                //判断是否需要继续加载
                if (self.player.rate == 0 &&
                    (CMTimeGetSeconds(self.player.currentItem.duration) != CMTimeGetSeconds(self.player.currentItem.currentTime)) &&
                    (totalBuffer - currentTime > kBufferSizeToContinuePlaying))
                {
                    // 如果是最开始缓存好了，而且设置了自动播放，则缓存好了之后就开始播放
                    if (self.ctrlView.isLoading)
                    {
                        if (currentTime == 0 && self.autoplay) {
                            [self.player play];
                            self.ctrlView.isPlaying = YES;
                            [self hideCtrlView];
                        }
                        self.ctrlView.isLoading = NO;
                    }
                    
                }
            }
        }
        else if ([keyPath isEqualToString:@"player.currentItem.status"])
        {
            if (self.player.currentItem.status == AVPlayerItemStatusFailed) {
                [self handlerErrorWithMessage:self.player.currentItem.error.localizedDescription error:self.player.currentItem.error];
            } else if (self.player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
                
            }
        }
        else if ([keyPath isEqualToString:@"player.rate"])
        {
            if (self.player.rate == 0 &&
                (self.ctrlView.bufferTime - self.ctrlView.currentTime <= kBufferSizeToContinuePlaying) &&
                (CMTimeGetSeconds(self.player.currentItem.duration) != CMTimeGetSeconds(self.player.currentItem.currentTime)))
            {
                self.ctrlView.isBuffering = YES;
                [self.player pause];
            }
            else
            {
                self.ctrlView.isBuffering = NO;
                //如果缓存之前是播放状态，则缓存好之后，继续播放
                if (self.ctrlView.isPlaying) {
                    [self.player play];
                }
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    });
}

- (void) asyncLoadAsset:(AVURLAsset *) newAsset
{
    [newAsset loadValuesAsynchronouslyForKeys:[[self class] assetKeysRequiredToPlay] completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           
            // asset 已经改变了，等下一个来
            if (newAsset != self.asset) {
                return;
            }
            
            for (NSString *key in self.class.assetKeysRequiredToPlay) {
                NSError *error = nil;
                if ([newAsset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed) {
                    NSString *message = @"无法打开视频文件";
                    [self handlerErrorWithMessage:message error:error];
                    return;
                }
            }
            
            // 无法播放
            if (!newAsset.playable || newAsset.hasProtectedContent) {
                NSString *message = @"无法播放视频文件";
                [self handlerErrorWithMessage:message error:nil];
                return;
            }
            
            
            self.playerItem = [AVPlayerItem playerItemWithAsset:newAsset];
            
        });
    }];
}

#pragma mark - error handle
- (void) handlerErrorWithMessage:(NSString *) message error:(NSError *)error
{
    NSLog(@"播放视频出错啦:%@，这里要做提示:%@", error.localizedDescription, message);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (message) {
        [userInfo setObject:message forKey:@"message"];
    }
    if (error) {
        [userInfo setObject:error forKey:@"error"];
    }
    [userInfo setObject:self forKey:@"SSPlayerView"];
    [[NSNotificationCenter defaultCenter] postNotificationName:SSPlayerViewPlayErrorNotification object:nil userInfo:userInfo];
}


#pragma mark - properties
+ (NSArray *)assetKeysRequiredToPlay {
    return @[ @"playable", @"hasProtectedContent" ];
}

- (void) setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem != playerItem) {
        _playerItem = playerItem;
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
    }
}

#pragma mark - public methods
- (void) play
{
    [self.player play];
    self.ctrlView.isPlaying = YES;
}

- (void) pause
{
    [self.player pause];
    self.ctrlView.isPlaying = NO;
}

@end
