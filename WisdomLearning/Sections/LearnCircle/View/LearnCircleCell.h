//
//  LearnCircleCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSLearnCircleListModel.h"

@interface LearnCircleCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
@property (strong, nonatomic) IBOutlet UIImageView *hotImageView;

@property (strong, nonatomic) IBOutlet UILabel *tagLeftLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagMidLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagRightLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutTitleLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *layoutLocationLabelTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hotImageLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hotLabelLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *numLabelLayout;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationLabelTop;

@property (nonatomic,strong) ZSLearnCircleListModel * model;

@end
