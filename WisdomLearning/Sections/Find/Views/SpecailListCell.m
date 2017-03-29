//
//  SpecailListCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SpecailListCell.h"

@implementation SpecailListCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(ZSLearnCircleListModel *)model
{
    self.titleLabel.text = model.name;
    
    NSString *str = [NSString stringWithFormat:@"匹配度: %@%@",model.matchRate,@"%"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:KMainTextGray
     
                          range:NSMakeRange(0, 5)];
    
    self.numLabel.attributedText = AttributedStr;
    self.locationLabel.text = model.area;
    
    NSString *hot = [NSString stringWithFormat:@"热度排行: No%d",model.orderNum];
    NSMutableAttributedString *hotStr = [[NSMutableAttributedString alloc]initWithString:hot];
    [hotStr addAttribute:NSForegroundColorAttributeName
     
                   value:KMainTextGray
     
                   range:NSMakeRange(0, 6)];
    
    self.hotLabel.attributedText = hotStr;
    
    if(model.orderNum>0){
        self.riseIcon.image = [UIImage imageNamed:@"rise"];
    }
    else if(model.orderNum == 0){
        self.riseIcon.image = [UIImage imageNamed:@""];
    }
    else{
        self.riseIcon.image = [UIImage imageNamed:@"arrow_down"];
    }
  //  [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.img]    placeholderImage:[UIImage imageNamed:@"back_Image"]];
    
     [self.iconImage sd_setImageWithURL:[model.img stringToUrl] placeholderImage:kPlaceDefautImage];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
