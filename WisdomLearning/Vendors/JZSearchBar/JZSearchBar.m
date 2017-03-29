//
//  JZSearchBar.m
//  封装一个搜索框
//
//  Created by peijz on 16/1/8.
//  Copyright © 2016年 peijz. All rights reserved.
//

#import "JZSearchBar.h"
//#import "UIImage+JZ.h"
@implementation JZSearchBar

+(instancetype)searchBar
{
    return [[self alloc]init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // 设置圆角
        self.layer.cornerRadius = 5;
        
        // 设置字体
        self.font = [UIFont systemFontOfSize:14];
        self.backgroundColor= [UIColor whiteColor];
        //[UIColor colorWithRed:220/255.0 green:221/255.0 blue:224/255.0 alpha:1];
        
        // 设置清楚按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.textAlignment= NSTextAlignmentJustified;
        
        
        // 设置默认提示文字
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"" attributes:dict];
        /**
         * 左边放大镜图标
         */
       // @"搜索电影项目、需求、资源、众筹"
        UIImageView * iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_gary"]];
        iconView.frame = CGRectMake(0, 0, 30, 30);
        // 让放大镜图片居中
        iconView.contentMode = UIViewContentModeCenter;
        // 把放大镜赋值给leftview
        self.leftView = iconView;
        // 让leftview显示
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    // 设置左侧图片的frame
    self.leftView.frame = CGRectMake(0, 10, 30, self.frame.size.height-20);
}

@end
