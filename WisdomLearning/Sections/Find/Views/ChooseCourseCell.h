//
//  ChooseCourseCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSCurriculumModel.h"

@class LDProgressView ;

@interface ChooseCourseCell : UITableViewCell
@property(nonatomic, strong) ZSCurriculumInfo *curriculum;

@property(nonatomic, weak) IBOutlet UIImageView *courseIcon;
@property(nonatomic, weak) IBOutlet UIImageView *courseRating;
@property(nonatomic, weak) IBOutlet UILabel *courseName;
@property(nonatomic, weak) IBOutlet UILabel *coursePrice;
@property(nonatomic, weak) IBOutlet UILabel *learnNum;
@property(nonatomic, weak) IBOutlet UILabel *createTime;
@property(nonatomic, weak) IBOutlet UILabel *scoreLabel;
@property(nonatomic, weak) IBOutlet UILabel *remaindTimeLabel;
@property(nonatomic, weak) IBOutlet LDProgressView *progressView;
@property(nonatomic, weak) IBOutlet UILabel *progressLabel;

@property(nonatomic, copy) NSArray<NSString *> *images;

@end
