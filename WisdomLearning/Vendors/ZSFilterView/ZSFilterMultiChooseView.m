//
//  ZSFilterMultiChooseView.m
//  WisdomLearning
//
//  Created by Shane on 17/2/9.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSFilterMultiChooseView.h"

#define HORIZONTAL_PADDING 5.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f

const float FilterMultiChooseViewTitleX = 10;
const float FilterMultiChooseViewTitleHeight = 20;

@interface ZSFilterMultiChooseView()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSArray *vals;


@end

@implementation ZSFilterMultiChooseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andCode:(NSString *)code andAllVals:(NSArray *)allVals{
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        _code = code;
        _vals = allVals;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FilterMultiChooseViewTitleX, 5, CGRectGetWidth(frame),FilterMultiChooseViewTitleHeight)];
        previousFrame = titleLabel.frame;
        
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:titleLabel];
        
        self.frame=frame;
    }
    
    return self;
}
-(void)setTagWithTagArray:(NSArray*)arr{
    _buttons = @[].mutableCopy;
    
//    previousFrame = CGRectZero;
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UIButton * tag = [UIButton buttonWithType:UIButtonTypeCustom];
        tag.frame =CGRectZero;
        // UILabel*tag=[[UILabel alloc]initWithFrame:CGRectZero];
        if(_signalTagColor){
            //可以单一设置tag的颜色
            // [tag setTitleColor:_signalTagColor forState:UIControlStateNormal];
            [tag setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            //tag颜色多样
            tag.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        
        [tag setTitle:str forState:UIControlStateNormal];
        tag.titleLabel.font = [UIFont systemFontOfSize:14];
        tag.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tag.tag = idx;
        //tag.layer.cornerRadius=5;
        // tag.clipsToBounds=YES;
        
        [tag addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*2;
        Size_str.height += VERTICAL_PADDING*2;
        CGRect newRect = CGRectZero;
        
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            if (idx == 0) {
                newRect.origin = CGPointMake(10, CGRectGetMaxY(previousFrame));
            }else{
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            }
            
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tag setFrame:newRect];
        
        previousFrame=tag.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tag];
        
        [_buttons addObject:tag];
    }
     ];
    if(_GBbackgroundColor){
        self.backgroundColor=_GBbackgroundColor;
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}

-(void)clickBtn:(id)sender
{
    [Tool hideKeyBoard];
    
    UIButton * btn =(UIButton*)sender;
    btn.selected = !btn.selected;
    if(btn.selected){
        [btn setTitleColor:kMainThemeColor forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor whiteColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = kMainThemeColor.CGColor;
    }
    else{
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }
    
    if(_delegate && [_delegate respondsToSelector:@selector(clickBtn:)]){
        
        [_delegate clickBtn:btn];
        
    }
    //    if(btn.selected){
    //        if(_delegate){
    //
    //                [self.delegate clickGetBtnTag:btn.tag];
    //
    //        }
    //    }
}


#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    
    view.frame = tempFrame;
}

+(CGFloat)getTagViewHeight:(NSArray*)arr withWidth:(CGFloat)width
{
    CGRect previousFrame =CGRectZero;
    // UIColor*signalTagColor;
    CGFloat Height =0;
    CGFloat allHeight =0;
    
    for(NSString * str in arr){
        //  [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        UILabel*tag=[[UILabel alloc]initWithFrame:CGRectZero];
        
        tag.textAlignment=NSTextAlignmentCenter;
        tag.textColor=[UIColor whiteColor];
        tag.font=[UIFont boldSystemFontOfSize:15];
        tag.text=str;
        tag.layer.cornerRadius=5;
        tag.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*2;
        Size_str.height += VERTICAL_PADDING*2;
        CGRect newRect = CGRectZero;
        // NSLog(@"场如 %f",width);
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN >width) {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            Height  =Height+ Size_str.height + BOTTOM_MARGIN;
            // totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        [tag setFrame:newRect];
        previousFrame=tag.frame;
        
        allHeight = Height +Size_str.height + BOTTOM_MARGIN;
    }
    return allHeight + FilterMultiChooseViewTitleHeight + 5 + BOTTOM_MARGIN;
    
}


-(void)clearSelected{
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        
        [obj setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        obj.backgroundColor = [UIColor groupTableViewBackgroundColor];
        obj.layer.borderWidth = 1;
        obj.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    }];
}


-(NSString *)retCode{
    _retCode = @"";
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected == YES) {
            _retCode = _code;
            *stop = YES;
        }
    }];
    return _retCode;
}

-(NSString *)retVal{
    _retVal = @"";
    [_buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected == YES) {
            NSString *val = _vals[idx];
            _retVal = [[_retVal add:val] add:@","];
        }
    }];
    
    if (_retVal.length != 0) {
        _retVal = [_retVal substringToIndex:_retVal.length-1];
    }
    return _retVal;

}


@end
