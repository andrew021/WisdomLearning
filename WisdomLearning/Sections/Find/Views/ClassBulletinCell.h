//
//  ClassBulletinCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassBulletinCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;

@end
