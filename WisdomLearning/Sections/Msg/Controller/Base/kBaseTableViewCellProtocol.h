//
//  kBaseTableViewCellProtocol.h
//  BigMovie
//
//  Created by Shane on 16/4/21.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol kBaseTableViewCellProtocol <NSObject>

//cell的高度
+ (CGFloat)cellHeightWithModel:(id)model;
//cell的Identifier
+ (NSString *)cellIdentifierWithModel:(id)model;

@end
