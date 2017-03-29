//
//  CertificateListCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindModel.h"

@interface CertificateListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImge;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (nonatomic,strong)  CertificateListModel * model;
@property (strong, nonatomic) IBOutlet UILabel *mustLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;
@end
