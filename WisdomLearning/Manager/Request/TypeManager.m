//
//  TypeManager.m
//  BigMovie
//
//  Created by hfcb001 on 16/2/3.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import "TypeManager.h"


@interface TypeManager ()


@end


@implementation TypeManager

+ (TypeManager*)sharedAPI
{
    static TypeManager* sharedAPIInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAPIInstance = [[self alloc] init];
    });
    
    return sharedAPIInstance;
}



@end
