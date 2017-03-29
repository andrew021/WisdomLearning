//
//  StudyRemindExtCell.h
//  WisdomLearning
//
//  Created by Shane on 16/11/27.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyRemindExtCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *remindContentLabel;
@property (nonatomic, weak) IBOutlet UIButton *lookButton;

@property (nonatomic, strong) NSString *remindContent;

@end
