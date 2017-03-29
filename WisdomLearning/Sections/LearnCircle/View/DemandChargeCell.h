//
//  DemandChargeCell.h
//  BigMovie
//
//  Created by hfcb001 on 16/2/22.
//  Copyright © 2016年 zhisou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClearHistoryMark <NSObject>

-(void)clearData:(UIButton*)btn;

@end

@interface DemandChargeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *clearBtn;
@property (strong,nonatomic) id<ClearHistoryMark>delegate;
+ (instancetype)cellWithTable:(UITableView *)tableView;

@end
