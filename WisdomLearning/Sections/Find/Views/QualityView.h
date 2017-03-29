//
//  QualityView.h
//  SelectControl
//
//  Created by DiorSama on 2016/11/15.
//  Copyright © 2016年 DiorSama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDelegate.h"



@interface QualityView : UIView

- (instancetype) initWithFrame:(CGRect)frame withNSArray:(NSArray*)arr;

@property (nonatomic,strong) id<ComDelegate>delegate;

@property (nonatomic,strong) NSString * fieldCode;
@property (nonatomic,strong) NSString * fieldName;
@property (nonatomic,assign) BOOL isUp;
@end
