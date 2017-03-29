//
//  ZSImagesView.m
//  WisdomLearning
//
//  Created by Shane on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSImagesView.h"

@implementation ZSImagesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//图片之间距离动态
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray andPadding:(float)padding andImageWidth:(float)width andImageHeight:(float)height andCorner:(BOOL)bCorner{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSInteger count = imageArray.count;
        float gap = (SCREEN_WIDTH-2*padding-count*width)/(count-1);
        float x = padding;
        float y = (self.frame.size.height-height)/2;
//        float y = 15;
        
        for(int i=0;i<count;i++){
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, y, width, height);
            if (bCorner == YES) {
                btn.layer.cornerRadius = width/2;
                btn.clipsToBounds = YES;
            }
            
            btn.tag = i;
            if ([imageArray[i] hasPrefix:@"http"] || [imageArray[i] hasPrefix:@"https"]) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
            }else{
                [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            x += (width+gap);
            
            [self addSubview:btn];
        }
    }
    return self;
}


//图片之间距离固定
-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray andPadding:(float)padding andImageWidth:(float)width andImageHeight:(float)height andCorner:(BOOL)bCorner andFixedGap:(float)fixedGap{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSInteger count = imageArray.count;
        float gap = fixedGap;
        float x = padding;
        float y = (self.frame.size.height-height)/2;
    
        
        for(int i=0;i<count;i++){
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(x, y, width, height);
            if (bCorner == YES) {
                btn.layer.cornerRadius = width/2;
                btn.clipsToBounds = YES;
            }
            
            btn.tag = i;
            if ([imageArray[i] hasPrefix:@"http"] || [imageArray[i] hasPrefix:@"https"]) {
                [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imageArray[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_icon"]];
            }else{
                [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            }
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            x += (width+gap);
            
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)clickBtn:(UIButton*)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(clickImgaeView:)]) {
        [_delegate clickImgaeView:btn];
    }
}


@end
