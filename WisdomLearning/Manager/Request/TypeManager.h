//
//  TypeManager.h
//  BigMovie
//
//  Created by hfcb001 on 16/2/3.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeManager : NSObject
//single
+ (TypeManager*)sharedAPI;

@property (nonatomic, strong) NSArray* IntelligentOrder;
@property (nonatomic, strong) NSArray* filterFields;
@property (nonatomic, strong) NSArray* proIntelligentOrder;
@property (nonatomic, strong) NSArray* proFilterFields;

@end
