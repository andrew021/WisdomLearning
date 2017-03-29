//
//  NearbyStudentsViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  附近同学

#import <UIKit/UIKit.h>

@protocol ToClassroomViewDelegate <NSObject>

- (void)ToClassroomViewWithClickBtns:(UIButton *)sender;
-(void)groupChat;

@end

@interface NearbyStudentsViewController : UIViewController

@property (nonatomic,strong) NSString * type;

@property (nonatomic,strong) NSString * typeID;

@property (nonatomic,strong) NSString * ID;

@property (nonatomic,assign) BOOL isCreateBtn;
//@property (nonatomic, assign) CGFloat  btnHeight;
//@property (nonatomic, assign) CGFloat  offest;

@property (nonatomic,strong) id<ToClassroomViewDelegate>delegate;
@property (nonatomic, strong) UITableView *tableView;

@end
