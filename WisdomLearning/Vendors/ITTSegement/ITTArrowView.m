//
//  ITTArrowView.m
//  AiXinDemo
//
//  Created by shaofa on 14-2-17.
//  Copyright (c) 2014年 shaofa. All rights reserved.
//

#import "ITTArrowView.h"

@implementation ITTArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.states = UPStates;
        self.image = [UIImage imageNamed:@"up_white@2x.png"];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected
{

    _isSelected = isSelected;
    if (isSelected) {
        ArrowStates states =_states ^ 1;
        self.states = states;
    }else {
        [self setStates:_states];
    }
    
}

-(void)setStates:(ArrowStates)states
{
    if (states != _states) {
        _states = states;
    }
    
    if (_isSelected) {
        if (_states == UPStates) {
            self.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
        } else if (_states == DOWNStates) {
//            self.image = [UIImage imageNamed:@"pull_down"];
            self.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
        }
        if (self.block != nil) {
            self.block(_states);
        }
    } else {
        
        self.image = [UIImage imageNamed:@"arrow_gray"];
//        
//        if (_states == UPStates) {
//            self.image = [UIImage imageNamed:@"pull_up"];
//        } else if (_states == DOWNStates) {
//            self.image = [UIImage imageNamed:@"pull_down"];
//        }
    }
}

@end
