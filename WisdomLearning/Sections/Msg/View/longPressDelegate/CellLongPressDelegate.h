//
//  CellLongPressDelegate.h
//  BigMovie
//
//  Created by Shane on 16/4/8.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellLongPressDelegate <NSObject>

- (void)longPressAtIndexPath:(NSIndexPath *)indexPath;

@end
