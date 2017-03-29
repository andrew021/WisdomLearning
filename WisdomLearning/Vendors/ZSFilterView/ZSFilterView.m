//
//  ZSFilterView.m
//  WisdomLearning
//
//  Created by Shane on 17/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSFilterView.h"
#import "ZSFilterSegmentView.h"
#import "ZSFilterMultiChooseView.h"

const CGFloat kFilterViewButtonHeight = 40;

@interface ZSFilterView()<ZSFilterMultiChooseViewDelegate>
{
    NSMutableArray <ZSFilterSegmentView *> *sgViews;
    NSMutableArray <ZSFilterMultiChooseView *> *multiChooseViews;
}
@end

@implementation ZSFilterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)initWithContentHeight:(CGFloat)contentHeight andData:(NSArray<FilterFieldModel *> *)datas{
    CGFloat frameHeight = contentHeight + kFilterViewButtonHeight;
    //SCREEN_HEIGHT-35-64
    if (frameHeight > SCREEN_HEIGHT-35-64) {
        frameHeight = SCREEN_HEIGHT-35-64;
    }
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH*0.7,frameHeight);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        sgViews = @[].mutableCopy;
        multiChooseViews = @[].mutableCopy;
        
        CGRect nextFrame = frame;
        UIView *nowView = nil;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)-kFilterViewButtonHeight)];
        

        scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame), contentHeight);
        [self addSubview:scrollView];
        
        //添加点按击手势监听器
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUiscrollView:)];
        //设置手势属性
//        tapGesture.delegate = self;
        tapGesture.numberOfTapsRequired=1;//设置点按次数，默认为1，注意在iOS中很少用双击操作
        tapGesture.numberOfTouchesRequired=1;//点按的手指数
        [scrollView addGestureRecognizer:tapGesture];
        
        NSDictionary *minMaxHintDict = [self initialMinMaxHints];

        for (FilterFieldModel *model in datas) {
            if ([model.filterType isEqualToString:@"area"]) {
                ZSFilterSegmentView *sgView = nil;
                
                NSString *minHint = minMaxHintDict[model.filterTypeCode][0];
                NSString *maxHint = minMaxHintDict[model.filterTypeCode][1];
                sgView = [[ZSFilterSegmentView alloc] initWithFrame:nextFrame andTitle:model.filterTypeName andCode:model.filterTypeCode andMinHint:minHint andMaxHint:maxHint];
                
                nowView = sgView;
                nextFrame = CGRectMake(0, CGRectGetMaxY(sgView.frame), CGRectGetWidth(frame) , CGRectGetHeight(frame));
                
                [scrollView addSubview:sgView];
                [sgViews addObject:sgView];
            }else if ([model.filterType isEqualToString:@"enum"]){
                NSArray * items  = [model.enumItems componentsSeparatedByString:@","];
                NSArray * vals  = [model.enumCodes componentsSeparatedByString:@","];
                ZSFilterMultiChooseView  *multiChooseView = [[ZSFilterMultiChooseView alloc] initWithFrame:nextFrame andTitle:model.filterTypeName andCode:model.filterTypeCode andAllVals:vals];
                multiChooseView.signalTagColor = [UIColor whiteColor];
                multiChooseView.delegate = self;
                [multiChooseView setTagWithTagArray:items];
                
                nowView = multiChooseView;
                nextFrame = CGRectMake(0, CGRectGetMaxY(multiChooseView.frame), CGRectGetWidth(frame) , CGRectGetHeight(frame));
                
                [scrollView addSubview:multiChooseView];
                [multiChooseViews addObject:multiChooseView];
            }
        }
        
       
        UIButton * resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        resetButton.tag = 0;
        [self addSubview:resetButton];
        [resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.equalTo(@(kFilterViewButtonHeight));
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(self).multipliedBy(0.5);
        }];
        [resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        resetButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        
        UIButton * sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.tag = 1;
        [self addSubview:sureButton];
        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(resetButton.mas_right);
            make.height.equalTo(@(kFilterViewButtonHeight));
            make.bottom.equalTo(self.mas_bottom);
            make.width.equalTo(self).multipliedBy(0.5);
        }];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
        sureButton.backgroundColor = kMainThemeColor;
        
        [resetButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [sureButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(resetButton.mas_top);
            make.height.equalTo(@1);
        }];

        
    }
    return self;
}

-(NSDictionary *)initialMinMaxHints{
    NSDictionary *dict = @{@"price":@[@"最低价格", @"最高价格"],
                           @"studyhour":@[@"最少学时", @"最多学时"]};
    return dict;
}

-(void)buttonClicked:(UIButton *)sender{
    [self endEditing:YES];
    if(sender.tag==0){
        [sgViews enumerateObjectsUsingBlock:^(ZSFilterSegmentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj clearText];
        }];
        
        [multiChooseViews enumerateObjectsUsingBlock:^(ZSFilterMultiChooseView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj clearSelected];
        }];
    }else if(sender.tag == 1){
        if (_theDelegate && [_theDelegate respondsToSelector:@selector(sureDataInFileterView:)]) {
            [_theDelegate sureDataInFileterView:self];
        }
    }
}


-(NSString *)filterItems{
    _filterItems = @"";
    
    [sgViews enumerateObjectsUsingBlock:^(ZSFilterSegmentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj modifyVal];
        if (obj.retCode.length != 0) {
            _filterItems = [[_filterItems add:obj.retCode] add:@","];
        }
    }];
    
    [multiChooseViews enumerateObjectsUsingBlock:^(ZSFilterMultiChooseView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.retCode.length != 0) {
            _filterItems = [[_filterItems add:obj.retCode] add:@","];
        }
    }];
    
    if (_filterItems.length != 0) {
        _filterItems = [_filterItems substringToIndex:_filterItems.length-1];
    }
   
    return _filterItems;
}

-(NSString *)filterValues{
    _filterValues = @"";
    
    [sgViews enumerateObjectsUsingBlock:^(ZSFilterSegmentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj modifyVal];
        
        if (obj.retVal.length != 0) {
            _filterValues = [[_filterValues add:obj.retVal] add:@"_"];
        }
    }];
    
    [multiChooseViews enumerateObjectsUsingBlock:^(ZSFilterMultiChooseView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.retVal.length != 0) {
            _filterValues = [[_filterValues add:obj.retVal] add:@"_"];
        }
    }];
    
    if (_filterValues.length != 0) {
        _filterValues = [_filterValues substringToIndex:_filterValues.length-1];
    }
    
    return _filterValues;
}

-(void)tapUiscrollView:(UITapGestureRecognizer *)gr{
    [self endEditing:YES];
}

@end
