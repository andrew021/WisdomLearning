//
//  CellTapDelegate.h
//  BigMovie
//
//  Created by Shane on 16/5/24.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellTapDelegate <NSObject>

- (void)tapAtIndexPath:(NSIndexPath *)indexPath andType:(NSInteger)type;

@end
