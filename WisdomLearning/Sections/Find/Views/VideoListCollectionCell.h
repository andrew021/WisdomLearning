//
//  VideoListCollectionCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "ZSOnlineCourseDetail.h"

@interface VideoListCollectionCell : UICollectionViewCell

@property(nonatomic, weak) IBOutlet LDProgressView *progressView;
@property(nonatomic, weak) IBOutlet UILabel *chapterNameLabel;
@property(nonatomic, weak) IBOutlet UILabel *percentLabel;
@property(nonatomic, weak) IBOutlet UILabel *statusLabel;

@property(nonatomic, assign) BOOL isChoose;


@property(nonatomic, strong) ZSChaptersInfo *charpterInfo;

@end
