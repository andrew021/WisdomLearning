//
//  WorkTestSelectCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//


#import "WorkTestSelectCell.h"

@implementation WorkTestSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

-(void)setup{
    

    _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = CGRectMake(30, 15, 20, 20);
  
    [self.contentView addSubview:_iconBtn];
    
    NSString * text = @"山顶洞人";
    CGFloat height = [GetHeight getHeightWithContent:text width:SCREEN_WIDTH-30 font:15];
    _contentLabel = [UILabel new];
    
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = KMainTextBlack;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = text;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.frame = CGRectMake(60, 15, SCREEN_WIDTH-60, height);
    
    //   NSArray * arrr = @[@"back_Image",@"back_Image",@"back_Image",@"back_Image",@"back_Image"];
    NSArray * arrr = nil;
    CGFloat imHeight = [CrowdFundingImageView getImagesGirdViewHeight:arrr withWidth:SCREEN_WIDTH-60 ];
    _imageViews = [[CrowdFundingImageView alloc]initWithFrame:CGRectMake(60, 15+height, SCREEN_WIDTH-60, imHeight) withWidth:(SCREEN_WIDTH-35)/3];
    _imageViews.imageArrays = arrr;
    [self.contentView addSubview:_imageViews];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

