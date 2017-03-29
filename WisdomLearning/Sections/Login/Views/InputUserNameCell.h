//
//  InputUserNameCell.h
//  WisdomLearning
//
//  Created by Shane on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InputUserNameCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIButton *scanLogin;
@property(nonatomic, weak) IBOutlet UITextField *usernameTextField;

@property (nonatomic ,weak) IBOutlet UIImageView *userNameIv;


@end
