//
//  KeyboardView.m
//  WisdomLearning
//
//  Created by Shane on 17/1/22.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyboardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype )initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}


@end
