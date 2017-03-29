//
//  CustomCollectionViewCell.h
//  UICollectionViewDemo
//
//  Created by CHC on 15/5/12.
//  Copyright (c) 2015年 CHC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) UILabel *label;
@end
