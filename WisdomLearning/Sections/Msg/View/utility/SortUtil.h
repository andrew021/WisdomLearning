//
//  SortUtil.h
//  BigMovie
//
//  Created by Shane on 16/4/28.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortUtil : NSObject

//对数据进行排序
+(void)sortData:(NSArray *)dataArray completionBlock:(void (^)(NSMutableArray *titles, NSMutableArray *data))completionBlock;

@end
