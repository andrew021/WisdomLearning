//
//  SpecialHeaderView.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectClassLabel;
@property (strong, nonatomic) IBOutlet UIImageView *pullUpImage;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (strong, nonatomic) IBOutlet UILabel *getCertificateLabel;
@property (strong, nonatomic) IBOutlet UILabel *certificateLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *perNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *scrLabel;

@end
