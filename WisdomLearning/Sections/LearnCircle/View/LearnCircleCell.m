//
//  LearnCircleCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "LearnCircleCell.h"

@implementation LearnCircleCell

- (void)awakeFromNib {
    // Initialization code
    

    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"匹配度:75%"];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:KMainTextGray
     
                          range:NSMakeRange(0, 4)];
    
    _numLabel.attributedText = AttributedStr;
    
    NSMutableAttributedString *hotStr = [[NSMutableAttributedString alloc]initWithString:@"热度排行:No3"];
    [hotStr addAttribute:NSForegroundColorAttributeName
     
                          value:KMainTextGray
     
                          range:NSMakeRange(0, 5)];
    
    _hotLabel.attributedText = hotStr;
    
    self.tagLeftLabel.layer.cornerRadius = 5;
    self.tagLeftLabel.layer.borderColor = kMainThemeColor.CGColor;
    self.tagLeftLabel.layer.borderWidth = 1;
    self.tagLeftLabel.text = @"  老年  ";
    self.tagLeftLabel.textColor = kMainThemeColor;
    
    self.tagMidLabel.layer.cornerRadius = 5;
    self.tagMidLabel.layer.borderColor = KMainRed.CGColor;
    self.tagMidLabel.layer.borderWidth = 1;
    self.tagMidLabel.text = @"  户外运动  ";
    self.tagMidLabel.textColor = KMainRed;
    
    self.tagRightLabel.layer.cornerRadius = 5;
    self.tagRightLabel.layer.borderColor = [UIColor greenColor].CGColor;
    self.tagRightLabel.layer.borderWidth = 1;
    self.tagRightLabel.text = @"  登山  ";
    self.tagRightLabel.textColor = [UIColor greenColor];
   
    
  
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
    
    NSArray *array = [model.tags componentsSeparatedByString:@" "];
    switch (array.count) {
        case 0:
            self.tagLeftLabel.hidden = YES;
            self.tagMidLabel.hidden = YES;
            self.tagRightLabel.hidden = YES;
            break;
        case 1:
            
            self.tagMidLabel.hidden = YES;
            self.tagRightLabel.hidden = YES;
            break;
        case 2:
            //self.tagLeftLabel.hidden = YES;
           // self.tagMidLabel.hidden = YES;
            self.tagRightLabel.hidden = YES;
            break;
            
        default:
            break;
    }
    

    for (int i=0;i<array.count;i++){
        if(i==0){
            self.tagLeftLabel.text =[NSString stringWithFormat:@"  %@  ",array[i]];
        }
        else if(i==1){
            self.tagMidLabel.text = [NSString stringWithFormat:@"  %@  ",array[i]];
        }
        else {
            self.tagRightLabel.text = [NSString stringWithFormat:@"  %@  ",array[i]]; 
        }
    }
    
    
    if(model.orderNum>0){
        self.hotImageView.image = [UIImage imageNamed:@"rise"];
    }
    else if(model.orderNum == 0){
        self.hotImageView.image = [UIImage imageNamed:@""];
    }
    else{
        self.hotImageView.image = [UIImage imageNamed:@"arrow_down"];
    }
    
    [self.cellImageView sd_setImageWithURL:[model.img stringToUrl]  placeholderImage:kPlaceDefautImage];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
