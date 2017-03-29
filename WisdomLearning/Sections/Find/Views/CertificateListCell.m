//
//  CertificateListCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CertificateListCell.h"

@implementation CertificateListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(CertificateListModel *)model
{
    _model = model;
    
    [self.iconImge sd_setImageWithURL:[_model.img stringToUrl] placeholderImage:kPlaceDefautImage];
    
   // [self.iconImge sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"back_Image"]];
    self.titleLabel.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld%@",model.scoreNeed,resunit];
    self.mustLabel.text = [NSString stringWithFormat:@"必修: %ld",model.mustScoreNeed];
    self.selectLabel.text = [NSString stringWithFormat:@"选修: %ld",model.selectScoreNeed];
    self.rightLabel.text =[NSString stringWithFormat:@"辅修: %ld",model.minorScoreNeed];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
