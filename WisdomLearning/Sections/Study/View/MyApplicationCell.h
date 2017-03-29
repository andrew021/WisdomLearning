//
//  MyApplicationCell.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyApplicationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *courseBtn;//选课
@property (weak, nonatomic) IBOutlet UIButton *trainBtn;//培训
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) MyTenantList *list;

@end
