//
//  LightAppAddCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "LightAppAddCell.h"

@implementation LightAppAddCell

- (void)awakeFromNib {
    // Initialization code
   self.addBtn.layer.cornerRadius = 4;
    
}

-(void)setModel:(LightAppModel *)model
{
    _model = model;
    self.titleLabel.text = model.name;
    self.contentLabel.text = model.subject;

    if(model.owned){
      //  [self.addBtn setTitle:@"已添加" forState:UIControlStateNormal];
       // self.addBtn.backgroundColor = [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
       // [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"app_added"] forState:UIControlStateNormal];
    
        self.addBtn.enabled = NO;
    }
    else{
//        [self.addBtn setTitle:@"添加" forState:UIControlStateNormal];
//        self.addBtn.layer.borderColor = kMainThemeColor.CGColor;
//        self.addBtn.layer.borderWidth = 1;
        [self.addBtn setBackgroundImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
        self.addBtn.enabled = YES;
    }

    switch (model.type) {
        case 1:
           // self.iconImage sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>
            self.iconImage.image = [UIImage imageNamed:@"app_learn"];
       
            break;
        case 2:
              self.iconImage.image = [UIImage imageNamed:@"app_info"];
            break;
        case 3:
              self.iconImage.image = [UIImage imageNamed:@"app_special"];
            break;
        case 4:
              self.iconImage.image = [UIImage imageNamed:@"app_circle"];
            break;
        case 5:
              self.iconImage.image = [UIImage imageNamed:@"app_cer"];
            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
