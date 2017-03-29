//
//  SSPlayerCtrlView.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSPlayerCtrlView.h"
#import "SSPlayerSlider.h"
#import "SSPlayerPanInfo.h"

#define text_size_multiline(text, font, maxSize) [text length] > 0 ? [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero
#define text_size(text, font) [text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero

@interface SSPlayerCtrlView ()<SSPlayerSliderDelegate>

@property(nonatomic, strong) UIButton *playOrPauseBtn;
@property(nonatomic, strong) UIView *barView;
@property(nonatomic, strong) UILabel *durationLbl;
@property(nonatomic, strong) UILabel *progressLbl;
@property(nonatomic, strong) UIButton *zoomBtn;
@property(nonatomic, strong) SSPlayerSlider *progressSlider;
@property(nonatomic, strong) UIActivityIndicatorView *loadingView;
@property(nonatomic, strong) SSPlayerPanInfo *panInfoView;

@end

@implementation SSPlayerCtrlView
{
    UIPanGestureRecognizer *_panGesture;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initViewFrame:frame];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initViewFrame:frame];
}

- (void) initView
{
    //    self.backgroundColor = [UIColor blackColor];
    //    self.layer.opacity = kOpacity;
    //    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UIButton *playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"av_play"] forState:UIControlStateNormal];
    [playOrPauseBtn setImage:[UIImage imageNamed:@"av_pause"] forState:UIControlStateSelected];
    [playOrPauseBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    playOrPauseBtn.autoresizingMask = UIViewAutoresizingNone;
    self.playOrPauseBtn = playOrPauseBtn;
    
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = [UIColor colorWithRed:30 / 255.0 green:30/255.0f blue:35/255.0f alpha:0.86];
    self.barView = barView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"00:00";
    label.font = [UIFont systemFontOfSize:10.0f];
    label.textColor = [UIColor colorWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentRight;
    self.durationLbl = label;
    
    label = [[UILabel alloc] init];
    label.text = @"00:00";
    label.font = [UIFont systemFontOfSize:10.0f];
    label.textColor = [UIColor colorWithRed:133/255.0f green:133/255.0f blue:133/255.0f alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    self.progressLbl = label;
    
    UIButton *zoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zoomBtn setImage:[UIImage imageNamed:@"av_btn_zoom_out"] forState:UIControlStateNormal];
    [zoomBtn setImage:[UIImage imageNamed:@"av_btn_zoom_in"] forState:UIControlStateSelected];
    [zoomBtn addTarget:self action:@selector(zoom:) forControlEvents:UIControlEventTouchUpInside];
    self.zoomBtn = zoomBtn;
    [barView addSubview:self.zoomBtn];
    
    SSPlayerSlider *slider = [[SSPlayerSlider alloc] init];
    slider.value = 0.0f;
    slider.middleValue = 0.0f;
    slider.translatesAutoresizingMaskIntoConstraints = NO;
    slider.delegate = self;
    self.progressSlider = slider;
    [barView addSubview:self.progressSlider];
    [barView addSubview:self.durationLbl];
    [barView addSubview:self.progressLbl];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.loadingView hidesWhenStopped];
    
    self.panInfoView = [[SSPlayerPanInfo alloc] init];
    self.panInfoView.hidden = YES;
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    _panGesture.enabled = NO;
    [self addGestureRecognizer:_panGesture];
    
    [self addSubview:self.loadingView];
    [self addSubview:self.playOrPauseBtn];
    [self addSubview:self.barView];
    [self addSubview:self.panInfoView];
}

- (void) initViewFrame:(CGRect)frame
{
//    NSLog(@"ctrl view'frame : %@", NSStringFromCGRect(frame));
    CGSize zoomBtnSize = CGSizeMake(kTimingViewHeight, kTimingViewHeight);
    CGSize panInfoViewSize = CGSizeMake(170, 160);
    CGFloat timeLblWidth = 50;
    CGFloat paddingLeft = 18;
    CGFloat progressSliderHeight = 20;
    
    CGSize plarOrPauseBtnSize = CGSizeMake(45, 45);
    self.playOrPauseBtn.frame = CGRectMake((self.frame.size.width - plarOrPauseBtnSize.width) / 2.0f,
                                           (self.frame.size.height - plarOrPauseBtnSize.height) / 2.0f,
                                           plarOrPauseBtnSize.width, plarOrPauseBtnSize.height);
    
    self.barView.frame = CGRectMake(0, frame.size.height - kTimingViewHeight, frame.size.width, kTimingViewHeight);
    self.zoomBtn.frame = CGRectMake(self.barView.frame.size.width - zoomBtnSize.width,
                                    (self.barView.frame.size.height - zoomBtnSize.height) / 2.0f,
                                    zoomBtnSize.width, zoomBtnSize.height);
    
    self.progressSlider.frame = CGRectMake(paddingLeft,
                                           8,
                                           frame.size.width - (paddingLeft + plarOrPauseBtnSize.width),
                                           progressSliderHeight);
    
    self.durationLbl.frame = CGRectMake(self.zoomBtn.frame.origin.x - timeLblWidth, 23, timeLblWidth, 11);
    
    self.progressLbl.frame = CGRectMake(paddingLeft, 25, timeLblWidth, 11);
    
    self.panInfoView.frame = CGRectMake((frame.size.width - panInfoViewSize.width)/2.0f, (frame.size.height - panInfoViewSize.height) / 2.0f - 20, panInfoViewSize.width, panInfoViewSize.height);
    
    self.loadingView.center = self.center;
    self.progressSlider.value = self.progress;
}

- (void) playOrPause:(UIButton *)button
{
    self.isPlaying = !self.isPlaying;

    if ([self.delegate respondsToSelector:@selector(playerCtrlView:playOrPause:)]) {
        [self.delegate playerCtrlView:self playOrPause:self.isPlaying];
    }
}

#pragma mark - setter

- (void) setIsPlaying:(CGFloat)isPlaying
{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        //显示暂停图标
        self.playOrPauseBtn.selected = YES;
    } else {
        //显示暂停图标
        self.playOrPauseBtn.selected = NO;
    }
}

- (void) setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    if (_isLoading)
    {
        self.playOrPauseBtn.hidden = YES;
        self.progressSlider.userInteractionEnabled = NO;
        [self.loadingView startAnimating];
    }
    else
    {
        self.playOrPauseBtn.hidden = NO;
        self.progressSlider.userInteractionEnabled = YES;
        [self.loadingView stopAnimating];
    }
}

- (void) setIsBuffering:(BOOL)isBuffering
{
    _isBuffering = isBuffering;
    if (_isBuffering)
    {
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
    }
    else
    {
        [self.loadingView stopAnimating];
    }
}

- (void) setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    _panGesture.enabled = _isFullScreen;
}

//BOOL _playOrPauseBtnHidden = NO;
- (void) setAlpha:(CGFloat)alpha
{
    //    self.playOrPauseBtn.hidden = NO;
    self.playOrPauseBtn.alpha = alpha;
    self.barView.alpha = alpha;
}

#pragma mark - action delegate
- (void) zoom:(UIButton *)zoomBtn
{
    zoomBtn.selected = !zoomBtn.selected;
    if ([self.delegate respondsToSelector:@selector(playerCtrlView:zoomOrScall:)])
    {
        [self.delegate playerCtrlView:self zoomOrScall:zoomBtn.selected];
    }
}

#pragma mark - Gesture action

- (void)panAction:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat detalX = [panGesture translationInView:self].x;
    CGFloat percent = detalX / self.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.panInfoView.hidden = NO;
            self.panInfoView.startPanTime = self.currentTime;
            self.panInfoView.duration = self.duration;
            break;
        case UIGestureRecognizerStateChanged:
            self.panInfoView.panPercent = percent;
            break;
        case UIGestureRecognizerStateEnded:
            self.panInfoView.hidden = YES;
            if ([self.delegate respondsToSelector:@selector(playerCtrlView:seekToTime:)])
            {
                [self.delegate playerCtrlView:self seekToTime:self.panInfoView.panToTime];
            }
            break;
        default:
            self.panInfoView.hidden = YES;
            break;
    }
}

- (void) playerSliderDragging:(SSPlayerSlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(playerCtrlViewSeeking)])
    {
        [self.delegate playerCtrlViewSeeking];
    }
}

- (void) playerSliderValueChanged:(SSPlayerSlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(playerCtrlView:seekToTime:)])
    {
        [self.delegate playerCtrlView:self seekToTime:slider.value * self.duration];
    }
}

- (void) setBufferTime:(NSTimeInterval)bufferTime
{
    _bufferTime = bufferTime;
    if (_duration != 0)
    {
        self.bufferProgress = _bufferTime / _duration;
    }
}

- (void) setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    if (_duration != 0)
    {
        self.progress = _currentTime / _duration;
    }
    self.progressLbl.text = [self timeFormatted:currentTime];
}

- (void) setDuration:(NSTimeInterval)duration
{
    _duration = duration;
    self.durationLbl.text = [self timeFormatted:duration];
}

- (void) setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressSlider.value = progress;
}

- (void) setProgressText:(NSString *)progressText
{
    self.progressLbl.text = progressText;
}

- (void) setDurationText:(NSString *)durationText
{
    self.durationLbl.text = durationText;
}

- (void) setBufferProgress:(CGFloat)bufferProgress
{
    _bufferProgress = bufferProgress;
    self.progressSlider.middleValue = bufferProgress;
}

#pragma mark - utils
- (NSString *)timeFormatted:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    if (hours == 0)
    {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else
    {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    }
}
@end
