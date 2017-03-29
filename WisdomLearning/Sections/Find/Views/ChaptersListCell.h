//
//  ChaptersListCell.h
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSCircleProgressView ;

@interface ChaptersListCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel *chapterNameLabel;
@property(nonatomic, weak) IBOutlet UIImageView *studyStatusIv;
@property(nonatomic, strong) ZSCircleProgressView  *progressView;

@property(nonatomic, assign) BOOL isChoose;


@property(nonatomic, copy) ZSChaptersInfo *charpterInfo;

@end
