//
//  ClassmatesCell.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassmatesCell.h"

@implementation ClassmatesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImage.layer.cornerRadius = 40/2;
    self.iconImage.clipsToBounds = YES;
}

-(void)setModel:(CLassMateListModel *)model
{
    _model = model;
    [self.iconImage sd_setImageWithURL:[_model.userIcon stringToUrl] placeholderImage:KPlaceHeaderImage];
    self.nameLabel.text = model.name;
    self.detailLabel.text = model.distance;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
