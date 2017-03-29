//
//  PriceLeftCell.h
//  ACMilan
//
//  Created by DiorSama on 2016/12/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceLeftCell : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *labelLayout;

@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UIButton *titleBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrowsImage;
@property (strong, nonatomic) UIImageView * arrowsImg;
@property (strong, nonatomic) NSArray * arr;
@end
