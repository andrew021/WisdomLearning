//
//  SortCell.m
//  WisdomLearning
//
//  Created by Shane on 17/1/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "SortCell.h"

@implementation SortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [_sortButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"arrow_down_selected"] forState:UIControlStateSelected];
//    [_sortButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"arrow_up_selected"] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
