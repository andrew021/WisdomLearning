//
//  UIButton+EnlargeEdge.h
//  ZONRY_Client
//
//  Created by Razi on 16/5/17.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)

- (void)setEnlargeEdge:(CGFloat)size;
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
