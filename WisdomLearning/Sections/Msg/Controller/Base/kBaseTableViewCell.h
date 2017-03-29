//
//  UIBaseCell.h
//  BigMovie
//
//  Created by Shane on 16/4/11.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kBaseTableViewCellProtocol.h"


@interface kBaseTableViewCell : UITableViewCell<kBaseTableViewCellProtocol>

+(id)cellForTableView:(UITableView *)tableView;


@end
