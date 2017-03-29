//
//  SearchResultListCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SearchResultListCell.h"

@implementation SearchResultListCell

- (void)awakeFromNib {
    // Initialization code
    self.moneyLabel.textColor = KMainOrange;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickLikeBtn:(UIButton *)sender {
    
}

@end
