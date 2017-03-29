//
//  ClassSelectView.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ClassSelectView.h"

@interface ClassSelectView ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *certificateLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;

@end

@implementation ClassSelectView

- (void)awakeFromNib
{
    self.goldLabel.textColor = KMainOrange;
    _certificateLabel.textColor = kMainThemeColor;
    _courseLabel.textColor = kMainThemeColor;
}

- (void)setDetails:(TopicsDetails *)details
{
    _details = details;
    [self.headerImage sd_setImageWithURL:[details.image stringToUrl] placeholderImage:kPlaceDefautImage];
    
    self.classNameLabel.text = details.name;
    self.personNumLabel.text = [NSString stringWithFormat:@"%ld人参加",details.joinNum];
    self.courseLabel.text = [NSString stringWithFormat:@"%ld%@",details.scoreNeed, resunit];
    self.certificateLabel.text = details.certificateName;
    NSString *string = [NSString stringWithFormat:@"%g%@",details.price,priceunit];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:string];
    [att addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.0]} range:NSMakeRange(0, string.length - 2)];
    self.goldLabel.attributedText = att;
}

@end
