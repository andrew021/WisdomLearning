//
//  DynCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "DynCell.h"

@implementation DynCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(DiscoveryInformation *)model
{
    _model = model;
    
    [self.headerImage sd_setImageWithURL:[model.img stringToUrl] placeholderImage:kPlaceDefautImage];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.comFrom;
    self.dateLabel.text = model.createDate;
//    self.numLabel.text = [NSString stringWithFormat:@"%ld次浏览",model.viewNum];
}

@end
