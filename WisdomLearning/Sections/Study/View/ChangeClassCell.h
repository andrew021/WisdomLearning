//
//  ChangeClassCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/16.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@property (nonatomic, strong) ClassList * list;
@property (nonatomic, strong) ClassList *changeList;

@end
