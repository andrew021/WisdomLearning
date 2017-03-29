//
//  CustomCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by CHC on 15/5/12.
//  Copyright (c) 2015年 CHC. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell()

@end

@implementation CustomCollectionViewCell
//- (id)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        self.layer.borderColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0].CGColor;
//        self.layer.borderWidth = 1;
//        
//        self.label = [[UILabel alloc] initWithFrame:self.bounds];
//        self.label.font = [UIFont systemFontOfSize:13];
//        self.label.textAlignment = NSTextAlignmentCenter;
//        self.label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0];
//        [self.contentView addSubview:self.label];
//    }
//    
//    return self;
//}

- (void)setContent:(NSString *)aContent
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    self.layer.borderColor = [UIColor colorWithHexString:@"d8d8d8"].CGColor;
    self.layer.borderWidth = 1;
    
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = KMainTextBlack;
    self.label.text = aContent;
    [self.contentView addSubview:self.label];
}
@end
