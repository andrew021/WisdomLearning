//
//  TextAndImageCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextAndImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
