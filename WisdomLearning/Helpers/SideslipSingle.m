//
//  SideslipSingle.m
//  WisdomLearning
//
//  Created by hfcb001 on 17/2/22.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "SideslipSingle.h"

@implementation SideslipSingle

+(SideslipSingle *) sharedInstance
{
    static SideslipSingle *client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc]init];
    });
    return client;
}

@end
