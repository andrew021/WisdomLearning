//
//  TestResultController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestResultController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *resultImageView;
@property (strong, nonatomic) IBOutlet UILabel *creditLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;
@property (nonatomic,strong) NSString * timeStr;
@property (nonatomic, strong)TestWorkList *list;

@end
