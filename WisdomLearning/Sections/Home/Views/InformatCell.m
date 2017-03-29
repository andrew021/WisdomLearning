//
//  InformatCell.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "InformatCell.h"

@interface InformatCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation InformatCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setInfoModel:(DiscoveryInformation *)infoModel
{
    _infoModel = infoModel;
    
    [self.headerImage sd_setImageWithURL:[infoModel.img stringToUrl] placeholderImage:kPlaceDefautImage];
    self.titleLabel.text = infoModel.title;
    self.dateLabel.text = infoModel.createDate;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld次浏览",infoModel.viewNum];
    
}

@end
