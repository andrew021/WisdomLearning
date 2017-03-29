//
//  DynCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Study.h"

@interface DynCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) DiscoveryInformation *model;

@end
