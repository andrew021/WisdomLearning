//
//  SignupListCell.h
//  WisdomLearning
//
//  Created by Shane on 16/11/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupListCell : UITableViewCell

@property (nonatomic, strong) Signup * signupModel;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end
