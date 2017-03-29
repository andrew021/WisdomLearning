//
//  GroupCell.h
//  BigMovie
//
//  Created by Shane on 16/4/7.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewCell.h"

static CGFloat Buddy_Group_CellMinHeight = 75.f;
static NSString *Buddy_Group_CellIdentifier = @"Buddy_Group_Cell";

@interface Buddy_Group_Cell : kBaseTableViewCell

//群组图像
@property(nonatomic, weak) IBOutlet UIImageView *ivGroup;
//群组名
@property(nonatomic, weak) IBOutlet UILabel *lbGroup;

@end
