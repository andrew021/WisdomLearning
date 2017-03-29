//
//  MyCurrencyCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyCurrencyCell.h"

@implementation MyCurrencyCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(MyCreditModel *)model
{
    _model = model;
    self.timeLabel.text = model.createTime;
    self.typeLabel.text = model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",model.changeValue];
   // if(model.changeValue>0){
       // self.numLabel.text = [NSString stringWithFormat:@"获得学币 %ld",model.changeValue];
   // }
   // else{
      //  self.numLabel.text = [NSString stringWithFormat:@"花费学币 %ld",model.changeValue];
   // }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
