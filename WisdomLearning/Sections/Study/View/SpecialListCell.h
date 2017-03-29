//
//  SpecialListCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *organizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *classTypeImage;
@property (weak, nonatomic) IBOutlet UIImageView *justImage;

@property (nonatomic, strong)UserClassList *list;

@end
