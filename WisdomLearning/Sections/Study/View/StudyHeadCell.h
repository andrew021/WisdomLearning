//
//  StudyHeadCell.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickStudyHeadCellBtn <NSObject>

-(void)clickStudyHeadCellBtn:(UIButton*)btn;

@end
@interface StudyHeadCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//名字
@property (strong, nonatomic) IBOutlet UIButton *headerBtn;//头像
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *MyApplicationBtn;
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgIv;
@property (weak, nonatomic) IBOutlet UIButton *scoreBtn;
@property (weak, nonatomic) IBOutlet UIButton *cerBtn;
@property (weak, nonatomic) IBOutlet UIButton *signedBtn;

@property (nonatomic,strong) id<ClickStudyHeadCellBtn>delegate;

@end
