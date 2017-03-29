//
//  Offset.m
//  WisdomLearning
//
//  Created by hfcb001 on 17/1/16.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "Offset.h"

@implementation Offset

+(Offset *) sharedInstance
{
    static Offset *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}

@end
