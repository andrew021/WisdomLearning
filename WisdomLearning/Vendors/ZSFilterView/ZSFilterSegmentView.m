//
//  ZSFilterSegmentView.m
//  WisdomLearning
//
//  Created by Shane on 17/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSFilterSegmentView.h"
#import "MBProgressHUD+Add.h"

const float FilterViewTitleHeight = 20;
const float FilterViewTitleX = 10;
const float FilterViewTfHeight = 25;
const float FilterSegmentViewHeight = 60;

@interface ZSFilterSegmentView()<UITextFieldDelegate>{
    UITextField *minTextField;
    UITextField *maxTextField;
    
}

@property (nonatomic, copy) NSString *minHint;
@property (nonatomic, copy) NSString *maxHint;
@property (nonatomic, copy) NSString *code;

@end

@implementation ZSFilterSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCode:(NSString *)code andMinHint:(NSString *)minHint andMaxHint:(NSString *)maxHint{
    CGRect nowFrame = CGRectMake(0, frame.origin.y+5, CGRectGetWidth(frame), FilterSegmentViewHeight);
    _minHint = minHint;
    _maxHint = maxHint;
    _code = code;
    
    if (self = [super initWithFrame:nowFrame]) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FilterViewTitleX, 0, CGRectGetWidth(frame),FilterViewTitleHeight)];
        
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        CGFloat tfWidth = CGRectGetWidth(nowFrame)*0.35;
        
        minTextField = [[UITextField alloc] initWithFrame:CGRectMake(FilterViewTitleX, CGRectGetMaxY(titleLabel.frame), tfWidth, FilterViewTfHeight)];
        
        maxTextField = [[UITextField alloc] initWithFrame:CGRectMake( CGRectGetWidth(nowFrame)-FilterViewTitleX-tfWidth, CGRectGetMaxY(titleLabel.frame), tfWidth, FilterViewTfHeight)];
        
        minTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        maxTextField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        minTextField.placeholder = minHint;
        maxTextField.placeholder = maxHint;
        
    
        minTextField.delegate = self;
        minTextField.textAlignment = NSTextAlignmentCenter;
        minTextField.font = [UIFont systemFontOfSize:13];
        minTextField.keyboardType = UIKeyboardTypeNumberPad;

        
        maxTextField.delegate = self;
        maxTextField.textAlignment = NSTextAlignmentCenter;
        maxTextField.font = [UIFont systemFontOfSize:13];
        maxTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        [self addSubview:titleLabel];
        [self addSubview:minTextField];
        [self addSubview:maxTextField];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(minTextField);
            make.left.equalTo(minTextField.mas_right).offset(5);
            make.right.equalTo(maxTextField.mas_left).offset(-5);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

+(CGFloat)getHeight{
    return FilterSegmentViewHeight;
}

-(void)clearText{
    minTextField.text = @"";
    maxTextField.text = @"";
}


-(void)modifyVal{
    _minVal = minTextField.text;
    _maxVal = maxTextField.text;
    if (_minVal.length > 0 && _maxVal.length > 0) {
        if ([_minVal doubleValue] >= [_maxVal doubleValue]) {
            minTextField.text = _maxVal;
            maxTextField.text = _minVal;
        }
    }
    
}

-(NSString *)retCode{
    _retCode = @"";
    _minVal = minTextField.text;
    _maxVal = maxTextField.text;
    
    if (_minVal.length == 0 && _maxVal.length == 0){
        _retCode = @"";
    }else{
        _retCode = _code;
    }
    
    return _retCode ;
}

-(NSString *)retVal{
    _retVal = @"";
    _minVal = minTextField.text;
    _maxVal = maxTextField.text;
    
    if (_minVal.length == 0 && _maxVal.length == 0){
        _retVal = @"";
    }else{
        _retVal = [[_minVal add:@","] add:_maxVal];
    }
    
    return _retVal ;

}




@end
