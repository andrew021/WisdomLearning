//
//  WorkTestCell.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/21.
//  Copyright © 2016年 hfcb001. All rights reserved.
//


#import "WorkTestCell.h"

@implementation WorkTestCell

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
 
    
    NSString * text = @"日前，美国佛罗里达州克莱县治安官办公室在社交网络上分享了一张白头鹰被困在汽车前格栅的照片。当然，白头鹰最终被救了出来，在当地治安官办公室和消防救援服务工作人员的帮助下，它摆脱了格栅并被被转移到了B.E.A.K.S.野生动物保护区。很快，这个故事在社交媒体平台上引起了一阵迷因狂潮，很多美国网友甚至还给它加上了政治色彩.";
    CGFloat height = [GetHeight getHeightWithContent:text width:SCREEN_WIDTH-30 font:15];
    _contentLabel = [UILabel new];
    //[[UILabel alloc]initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH-30, height)];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.textColor = KMainTextBlack;
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = text;
    [self.contentView addSubview:_contentLabel];
    _contentLabel.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, height);
    
 //   NSArray * arrr = @[@"back_Image",@"back_Image",@"back_Image",@"back_Image",@"back_Image"];
    NSArray * arrr = nil;
    CGFloat imHeight = [CrowdFundingImageView getImagesGirdViewHeight:arrr withWidth:SCREEN_WIDTH-30 ];
    _imageViews = [[CrowdFundingImageView alloc]initWithFrame:CGRectMake(15, 10+height, SCREEN_WIDTH-30, imHeight) withWidth:(SCREEN_WIDTH-35)/3];
    _imageViews.imageArrays = arrr;
    [self.contentView addSubview:_imageViews];
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
