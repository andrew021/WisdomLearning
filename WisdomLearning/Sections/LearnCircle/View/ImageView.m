//
//  ImageView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        for(int i=0;i<imageArray.count;i++){
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_WIDTH/20+i*SCREEN_WIDTH/imageArray.count+3, 15, SCREEN_WIDTH/(imageArray.count*2)-6, SCREEN_WIDTH/(imageArray.count*2)-6);
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
            [self addSubview:btn];
        }
    }
    return self;
}

-(void)clickBtn:(UIButton*)btn{
    if(_delegate){
        [self.delegate clickRepons:btn];
    }
}
@end
