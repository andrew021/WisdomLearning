//
//  SSPlayerPanInfo.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSPlayerPanInfoDelegate <NSObject>

- (void) playerPanInfoSeekTo:(NSTimeInterval)seekTo;

@end


@interface SSPlayerPanInfo : UIView

@property(nonatomic, weak) id<SSPlayerPanInfoDelegate> delegate;

@property(nonatomic, assign) NSTimeInterval startPanTime;
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, assign) NSTimeInterval panToTime;

@property(nonatomic, assign) CGFloat panPercent; // 0 - 1 //滑动的百分比
@property(nonatomic, assign) NSTimeInterval panToSecond;

@end
