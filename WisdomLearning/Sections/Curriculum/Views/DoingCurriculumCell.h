//
//  DoingCurriculumCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LDProgressView.h"
#import "ZSMyCourseListModel.h"

@class DoingCurriculumCell ;


@interface DoingCurriculumCell : UITableViewCell


@property(nonatomic, weak) IBOutlet UILabel *coursenameLabel;
@property(nonatomic, weak) IBOutlet UILabel *remaindingtimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *percentLabel;
@property(nonatomic, weak) IBOutlet LDProgressView *ldProgressView;
@property(nonatomic, weak) IBOutlet UIImageView *courseIconView;
@property(nonatomic, weak) IBOutlet UIButton *cancelButton;

@property(nonatomic, assign) int type;

@property(nonatomic, strong) ZSMyCourseInfo *myCourse;

//@property(nonatomic, strong) LDProgressView * ldProgressView;

@end
