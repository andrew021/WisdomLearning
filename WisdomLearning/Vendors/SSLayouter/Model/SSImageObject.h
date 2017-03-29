//
//  SSImageObject.h
//  DTCoreTextLayout
//
//  Created by Su Jiang on 16/9/12.
//  Copyright © 2016年 sunima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSImageObject : NSObject

@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) UIImage *placeholder;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, copy) NSString *descri;
@property(nonatomic, assign) CGRect rect;

@end
