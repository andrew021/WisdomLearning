//
//  TextCollectionViewCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
