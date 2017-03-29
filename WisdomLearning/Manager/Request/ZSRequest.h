//
//  ZSRequest.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/20.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSRequestModel.h"
@class ZSModel;

@interface ZSRequest : NSObject

- (void)requestWithModel:(ZSRequestModel*)model
                   block:(void (^)(ZSModel* model, NSError* error))block;

- (void)cancleRequest;


@end
