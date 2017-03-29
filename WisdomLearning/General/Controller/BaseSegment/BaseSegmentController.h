//
//  BaseSegmentController.h
//  SegmentController
//
//  Created by Razi on 16/2/19.
//  Copyright © 2016年 Razi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSegmentController : UIViewController

@property (strong, nonatomic) NSMutableArray* pages;

- (UIViewController*)selectedController;
- (instancetype)initWithPages:(NSArray*)pages;

@end
