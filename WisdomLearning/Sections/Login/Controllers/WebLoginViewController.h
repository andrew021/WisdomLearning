//
//  WebLoginViewController.h
//  WisdomLearning
//
//  Created by Shane on 17/1/6.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLoginViewController : UIViewController

@property (nonatomic, copy) NSString *ranCode;

@property (nonatomic, weak) IBOutlet UIButton *sureButton;
@property (nonatomic, weak) IBOutlet UIButton *cancelButton;

@end
