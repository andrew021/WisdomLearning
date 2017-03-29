//
//  SSPlayerPanInfo.m
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import "SSPlayerPanInfo.h"

@implementation SSPlayerPanInfo

{
    UIImageView *_flagImgView;
    UILabel *_timeLbl;
    UIColor *_currentTimeColor;
    UIColor *_otherColor;
    NSDictionary *_currentTimeAttributes;
    NSDictionary *_otherAttributes;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
        [self initViewFrame:self.bounds];
    }
    return self;
}

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self initViewFrame:self.bounds];
}

- (void) initView
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.layer.cornerRadius = 8;
    //    self.backgroundColor = [UIColor redColor];
    
    _currentTimeColor = [UIColor colorWithRed:226/255.0f green:7/255.0f blue:7/255.0f alpha:1];
    _otherColor = [UIColor whiteColor];
    
    _currentTimeAttributes = @{NSForegroundColorAttributeName : _currentTimeColor, NSFontAttributeName : [UIFont systemFontOfSize:18]};
    _otherAttributes = @{NSForegroundColorAttributeName : _otherColor, NSFontAttributeName : [UIFont systemFontOfSize:18]};
    
    _flagImgView = [[UIImageView alloc] init];
    _flagImgView.image = [UIImage imageNamed:@"av_forward"];
    //    _flagImgView.backgroundColor = [UIColor orangeColor];
    
    _timeLbl = [[UILabel alloc] init];
    _timeLbl.textAlignment = NSTextAlignmentCenter;
    
    NSString *str = @"00:00/00:00";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"00:00/00:00"];
    
    
    
    [string addAttributes:_currentTimeAttributes range:NSMakeRange(0, 5)];
    [string addAttributes:_otherAttributes range:NSMakeRange(5, str.length - 5)];
    _timeLbl.attributedText = string;
    
    [self addSubview:_flagImgView];
    [self addSubview:_timeLbl];
}

- (void) initViewFrame:(CGRect)frame
{
    _flagImgView.frame = CGRectMake(51, 34, frame.size.width - 51 * 2, frame.size.height - 34 - 66);
    _timeLbl.frame = CGRectMake(0, 115, frame.size.width, 25);
}

- (void) setPanPercent:(CGFloat)panPercent
{
    if (_duration == 0)
    {
        return;
    }
    _panPercent = panPercent;
    NSTimeInterval current = self.startPanTime + _panPercent * self.duration * 0.5;
    if (current < 0)
    {
        current = 0;
    }
    
    if (current > self.duration)
    {
        current = self.duration;
    }
    self.panToTime = current;
    
    NSString *currentStr = [self timeFormatted:current];
    NSString *totalStr = [self timeFormatted:self.duration];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", currentStr, totalStr]];
    [string addAttributes:_currentTimeAttributes range:NSMakeRange(0, currentStr.length)];
    [string addAttributes:_otherAttributes range:NSMakeRange(currentStr.length, totalStr.length + 1)];
    _timeLbl.attributedText = string;
}

- (void) setPanToSecond:(NSTimeInterval)panToSecond
{
    if (_duration == 0)
    {
        return;
    }
    
    if (panToSecond < 0)
    {
        panToSecond = 0;
    }
    
    if (panToSecond > self.duration)
    {
        panToSecond = self.duration;
    }
    NSString *currentStr = [self timeFormatted:panToSecond];
    NSString *totalStr = [self timeFormatted:self.duration];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", currentStr, totalStr]];
    [string addAttributes:_currentTimeAttributes range:NSMakeRange(0, currentStr.length)];
    [string addAttributes:_otherAttributes range:NSMakeRange(currentStr.length, totalStr.length + 1)];
    _timeLbl.attributedText = string;
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
