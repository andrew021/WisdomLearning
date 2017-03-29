//
//  VideoListCollectionCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "VideoListCollectionCell.h"

@implementation VideoListCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    _progressView.color = [UIColor colorWithRed:63.0f/255.0f green:184.0f/255.0f blue:255.0f/255.0f alpha:1];
//    
//    
    _statusLabel.textColor = kMainThemeColor;
    _progressView.flat = @YES;
    _progressView.showBackgroundInnerShadow = @NO;
    _progressView.progress = 0.70;
    _progressView.animate = @NO;
    _progressView.showText = @0;
    _progressView.color = kMainThemeColor;
    _isChoose = NO;
    
    // Initialization code
}

-(void)setCharpterInfo:(ZSChaptersInfo *)charpterInfo{
    _charpterInfo = charpterInfo;
    _chapterNameLabel.text = [NSString stringWithFormat:@"%@ %@", charpterInfo.chapterOrder, charpterInfo.chapterName];
    NSString *userId = [[Config Instance] getUserid];
    if ([userId isEqualToString:@""]) {
        _progressView.progress = 1.0;
        _percentLabel.text = @"100%";
//        _statusLabel.text = @"开始学习";
    }else{
        _progressView.progress = [charpterInfo.learnCoverRate floatValue]/100;
        _percentLabel.text = [charpterInfo.learnCoverRate add:@"%"];
        
//        float percent = [charpterInfo.learnCoverRate floatValue];
//        if (percent == 100) {
//            _statusLabel.text = @"开始复习";
//        }else if(percent < 100 && percent > 0){
//            _statusLabel.text = @"继续学习";
//        }else{
//            _statusLabel.text = @"开始学习";
//        }
    }
//    if (_isChoose) {
//        _statusLabel.textColor = [UIColor redColor];
//        _statusLabel.text = @"正在学习";
//    }else{
//        _statusLabel.text = @"开始学习";
//        _statusLabel.textColor = kMainThemeColor;
//    }
}

-(void)setIsChoose:(BOOL)isChoose{
    _isChoose = isChoose;
    
    if (_isChoose) {
        _statusLabel.textColor = [UIColor redColor];
        _statusLabel.text = @"正在学习";
    }else{
        _statusLabel.text = @"开始学习";
        _statusLabel.textColor = kMainThemeColor;
    }
}

@end
