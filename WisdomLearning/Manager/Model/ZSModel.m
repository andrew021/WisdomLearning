//
//  ZSModel.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"

@implementation ZSModel

- (BOOL) isSuccess
{
    if ([self.success isEqualToString:kSuccessCode]) {
        return YES;
    }
    return NO;
}

- (NSString *) message
{
    if (!_message || _message.length == 0) {
        return @"";
    }
    return _message;
}

@end
