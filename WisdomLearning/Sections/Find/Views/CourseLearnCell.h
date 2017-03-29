//
//  CourseLearnCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseLearnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *studyBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
