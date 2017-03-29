//
//  NewThingCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "NewThingCell.h"

@implementation NewThingCell

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
    self.avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 35, 35)];
   // self.avatarImage.image = [UIImage imageNamed:@"avatar"];
    self.avatarImage.layer.cornerRadius = 35/2;
    self.avatarImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatarImage];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 15, SCREEN_WIDTH-60, 20)];
    self.nameLabel.text = @"沙百菲萨";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 35, SCREEN_WIDTH-60, 15)];
    self.timeLabel.text = @"2016-10-14";
    self.timeLabel.textColor = KMainTextGray;
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.timeLabel];
  
    _contentLabel = [UILabel new];
    //[[UILabel alloc]initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, height)];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = KMainTextBlack;
    _contentLabel.numberOfLines = 0;
    //_contentLabel.text = text;
    [self.contentView addSubview:_contentLabel];
   
  
    

}


-(void)setModel:(NewThingModel *)model
{
    _model = model;
    [self.avatarImage sd_setImageWithURL:[_model.userIcon stringToUrl] placeholderImage:KPlaceHeaderImage];
    self.nameLabel.text = model.userName;
    self.timeLabel.text = model.createTime;
    
    
  
    CGFloat height = [GetHeight getHeightWithContent:model.content width:SCREEN_WIDTH-30 font:14];
    _contentLabel.text = model.content;
     _contentLabel.frame = CGRectMake(15, 60, SCREEN_WIDTH-30, height);
    
    
;
    NSString * imageStr = model.imgStr;
   NSArray *arr = [imageStr componentsSeparatedByString:@","];
  
    
    CGFloat imHeight = [CrowdFundingImageView getImagesGirdViewHeight:arr withWidth:SCREEN_WIDTH-30 ];
    _imageViews = [[CrowdFundingImageView alloc]initWithFrame:CGRectMake(15, 70+height, SCREEN_WIDTH-30, imHeight) withWidth:(SCREEN_WIDTH-35)/3];
    _imageViews.imageArrays = arr;
    [self.contentView addSubview:_imageViews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
