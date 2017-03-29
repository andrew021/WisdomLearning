//
//  CertificateDetailViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindModel.h"

@interface CertificateDetailViewController : UIViewController

@property (nonatomic,strong) CertificateListModel * model;
@property (nonatomic,strong) NSString * cerId;

@end
