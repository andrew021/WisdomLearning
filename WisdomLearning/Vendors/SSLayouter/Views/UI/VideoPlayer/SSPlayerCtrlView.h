//
//  SSPlayerCtrlView.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPlayerView.h"

@class SSPlayerCtrlView;

static const CGFloat kTimingViewHeight = 45.0f;

@protocol SSPlayerCtrlViewDelegate <NSObject>

- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView playOrPause:(BOOL)isPlay;
- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView zoomOrScall:(BOOL)isZoom;
- (void) playerCtrlView:(SSPlayerCtrlView *)ctrlView seekToTime:(NSTimeInterval)second;
- (void) playerCtrlViewSeeking;

@end

@interface SSPlayerCtrlView : UIView

@property(nonatomic, weak) id<SSPlayerCtrlViewDelegate> delegate;

@property (nonatomic, assign) CGFloat progress;        /* From 0 to 1 */
@property (nonatomic, assign) CGFloat bufferProgress;  /* From 0 to 1 */

@property (nonatomic, assign) CGFloat isPlaying;

@property (nonatomic, assign) NSTimeInterval bufferTime;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) NSTimeInterval duration;

//@property (nonatomic, assign) SSPlayerStatus playStatus;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isBuffering;
@property (nonatomic, assign) BOOL isFullScreen;

@end
