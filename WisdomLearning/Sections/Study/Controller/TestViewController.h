//
//  TestViewController.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestAnswerDelegate <NSObject>

//-(void)textAnswer:(NSDictionary *)dic AndWithTag:(NSInteger)tag;
-(void)sendTag:(NSInteger)tag;

@end

@interface TestViewController : UIViewController

@property (nonatomic,assign) NSInteger tag;
@property (nonatomic,assign) NSInteger num;
@property (nonatomic,strong)id<TestAnswerDelegate>delegate;

@end

