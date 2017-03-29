//
//  NewThingFootView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "NewThingFootView.h"

@implementation NewThingFootView


- (IBAction)clickBtn:(UIButton *)sender {
    if(_delegate){
        [self.delegate clickBtns:sender];
    }
}

@end
