//
//  GroupMemBerTableViewCell.h
//  BigMovie
//
//  Created by hfcb001 on 16/4/8.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupMemBerTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *msgLabel;

@end
