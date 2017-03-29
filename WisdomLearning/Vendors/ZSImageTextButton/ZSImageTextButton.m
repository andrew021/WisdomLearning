//
//  ZSImageTextButton.m
//  WisdomLearning
//
//  Created by Shane on 16/12/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSImageTextButton.h"

@interface ZSImageTextButton(){
    UIImage *buttonImage;
    NSString *buttonTitle;
}

@property (nonatomic, strong) UIImageView *theImageView;
@property (nonatomic, strong) UILabel *theTitleLabel;

@end

@implementation ZSImageTextButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andImageLeft:(BOOL)bImageLeft andImage:(UIImage *)image andTitle:(NSString *)title andTitleFont:(UIFont *)titleFont{
    if (self = [super initWithFrame:frame]) {
        buttonImage = image;
        buttonTitle = title;
        _imageWidth = 20;
        _imageHeight = 20;
        _titleFont = titleFont;
        _titleColor = [UIColor blackColor];
        _xPos = 0;
        _gap = 3;
        _bImageLeft = bImageLeft;
        
        [self addSubview:self.theImageView];
        [self addSubview:self.theTitleLabel];
    }
    return self;
}

-(UIImageView *)theImageView{
    if (!_theImageView) {
        _theImageView = [[UIImageView alloc] init];
    }
    return _theImageView;
}

-(UILabel *)theTitleLabel{
    if (!_theTitleLabel) {
        _theTitleLabel = [[UILabel alloc] init];
    }
    return _theTitleLabel;
}

-(void)drawRect:(CGRect)rect{
    if (_bImageLeft == YES) {
         _theImageView.frame = CGRectMake(_xPos, (CGRectGetHeight(self.frame)-_imageHeight)/2, _imageWidth, _imageHeight);
        
        _theTitleLabel.frame = CGRectMake(CGRectGetMaxX(_theImageView.frame)+_gap, 0, CGRectGetWidth(self.frame)-_gap-_imageWidth, CGRectGetHeight(self.frame));
    }else{
        _theImageView.frame = CGRectMake(CGRectGetWidth(self.frame)-_imageWidth, (CGRectGetHeight(self.frame)-_imageHeight)/2, _imageWidth, _imageHeight);
        
        _theTitleLabel.frame = CGRectMake(_xPos, 0, CGRectGetWidth(self.frame)-_gap-_imageWidth, CGRectGetHeight(self.frame));
    }
   
    _theImageView.image = buttonImage;
    
    
    _theTitleLabel.text = buttonTitle;
    _theTitleLabel.font = _titleFont;
    _theTitleLabel.textColor = _titleColor;
}

-(void)setImage:(UIImage *)image{
    _image = image;
    _theImageView.image = image;
}

//-(void)setTitleFont:(UIFont *)titleFont{
//    _titleFont = titleFont;
//    _theTitleLabel.font = titleFont;
//}

-(void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    _theTitleLabel.textColor = titleColor;
}

-(void)setImageHeight:(float)imageHeight{
    _imageHeight = imageHeight;
    [self setNeedsDisplay];
}

-(void)setImageWidth:(float)imageWidth{
    _imageWidth = imageWidth;
    [self setNeedsDisplay];
}

-(void)setGap:(float)gap{
    _gap = gap;
    [self setNeedsDisplay];
}

-(void)setImageX:(float)imageX{
    _xPos = imageX;
    [self setNeedsDisplay];
}



@end
