//
//  SearchResultView.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynCell.h"



@protocol SelectPushDetailVC <NSObject>

-(void)pushViewControllerWithSection:(NSInteger)section andRow:(NSInteger)row;

-(void)clickCollectBtn:(UIButton*)btn;

@end

typedef NS_ENUM(NSInteger, VCType) {
   
    VCCourse=1,
    VCLearnCircle,
    VCCertificate,
    VCInformation,
    VCSpecial
};

@interface SearchResultView : UIView

@property (nonatomic,strong)id<SelectPushDetailVC>delegate;
@property (nonatomic,assign) BOOL isLearnCircle;
@property (nonatomic, assign) VCType vctype;
-(instancetype)initWithFrame:(CGRect)frame;

@end
