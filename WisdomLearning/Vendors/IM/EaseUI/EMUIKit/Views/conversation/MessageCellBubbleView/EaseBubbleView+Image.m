/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseBubbleView+Image.h"

@implementation EaseBubbleView (Image)

#pragma mark - private

- (void)_setupImageBubbleMarginConstraints
{
    NSInteger num = 0;
    NSInteger leftNum = 0;
    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top-7];
    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom+7];
    if(self.isSender){
        num = 3.5;
        leftNum = 9;
    }
    else{
        num = 8;
        leftNum = 3;
    }
    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left-leftNum];
    
    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right+num];
    
    [self.marginConstraints removeAllObjects];
    [self.marginConstraints addObject:marginTopConstraint];
    [self.marginConstraints addObject:marginBottomConstraint];
    [self.marginConstraints addObject:marginLeftConstraint];
    [self.marginConstraints addObject:marginRightConstraint];
    
    
    
    [self addConstraints:self.marginConstraints];
}

- (void)_setupImageBubbleConstraints
{
    [self _setupImageBubbleMarginConstraints];
}

#pragma mark - public

- (void)setupImageBubbleView
{
    self.imageView = [[UIImageView alloc] init];
    // self.backgroundColor = [UIColor redColor];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 4.0;
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 4.0;
    [self.backgroundImageView addSubview:self.imageView];
    
    [self _setupImageBubbleConstraints];
}

- (void)updateImageMargin:(UIEdgeInsets)margin
{
    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
        return;
    }
    _margin = margin;
    
    [self removeConstraints:self.marginConstraints];
    [self _setupImageBubbleMarginConstraints];
}

@end
//#import "EaseBubbleView+Image.h"
//
//@implementation EaseBubbleView (Image)
//
//#pragma mark - private
//
//- (void)_setupImageBubbleMarginConstraints
//{
//    NSLayoutConstraint *marginTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.margin.top];
//    NSLayoutConstraint *marginBottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-self.margin.bottom];
//    NSLayoutConstraint *marginLeftConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-self.margin.right];
//    NSLayoutConstraint *marginRightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:self.margin.left];
//    
//    [self.marginConstraints removeAllObjects];
//    [self.marginConstraints addObject:marginTopConstraint];
//    [self.marginConstraints addObject:marginBottomConstraint];
//    [self.marginConstraints addObject:marginLeftConstraint];
//    [self.marginConstraints addObject:marginRightConstraint];
//    
//    [self addConstraints:self.marginConstraints];
//}
//
//- (void)_setupImageBubbleConstraints
//{
//    [self _setupImageBubbleMarginConstraints];
//}
//
//#pragma mark - public
//
//- (void)setupImageBubbleView
//{
//    self.imageView = [[UIImageView alloc] init];
//    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.imageView.backgroundColor = [UIColor clearColor];
//    [self.backgroundImageView addSubview:self.imageView];
//    
//    [self _setupImageBubbleConstraints];
//}
//
//- (void)updateImageMargin:(UIEdgeInsets)margin
//{
//    if (_margin.top == margin.top && _margin.bottom == margin.bottom && _margin.left == margin.left && _margin.right == margin.right) {
//        return;
//    }
//    _margin = margin;
//    
//    [self removeConstraints:self.marginConstraints];
//    [self _setupImageBubbleMarginConstraints];
//}
//
//@end
