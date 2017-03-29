//
//  DynHeaderView.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "DynHeaderView.h"

@interface DynHeaderView ()

@property(nonatomic,strong) NSMutableArray *btnArr;
@property(nonatomic,strong) NSMutableArray *imgArr;
@property(nonatomic,strong) UIButton *time_btn;
@property(nonatomic,assign) NSInteger flag,count;
@end

@implementation DynHeaderView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSMutableArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.btnArr = [NSMutableArray array];
        self.imgArr = [NSMutableArray array];
        self.count = 0;
        
        for (int i = 0; i < titleArray.count; i++) {
            NSString *str = titleArray[i];
            CGSize size = [str boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40)];
            [btn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:5];
            
            UIImageView * im = [[UIImageView alloc]initWithFrame:CGRectMake(btn.size.width/2.0 + size.width/2.0 + 7.0, 16.0, 10.0, 8.0)];
            im.tag = i;
            [btn addSubview:im];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:titleArray[i] forState:UIControlStateNormal];
            if (i == 0) {
                btn.selected = YES;
                [btn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
                self.flag = i;
//                [im setImage:[ThemeInsteadTool imageWithImageName:@"arrow_up"] forState:UIControlStateNormal];
                im.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
                [self.btnArr addObject:btn];
            } else {
                [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
//                [im setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
                im.image = [UIImage imageNamed:@"arrow_gray"];
            }
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.imgArr addObject:im];
        }
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 0.5)];
        lineV.backgroundColor = KMainLine;
        [self addSubview:lineV];
        
    }
    return self;
}

-(void)click:(UIButton *)sender{
    UIButton *btn = self.btnArr[self.btnArr.count - 1];
    UIImageView *im = self.imgArr[btn.tag];
    [self.btnArr addObject:sender];
    
    sender.selected = YES;
    im.image = [UIImage imageNamed:@"arrow_gray"];
//    [im setImage:[UIImage imageNamed:@"arrow_gray"] forState:UIControlStateNormal];
    [self.imgArr replaceObjectAtIndex:im.tag withObject:im];
    
    UIImageView *img = self.imgArr[sender.tag];
    NSInteger asc = 0;
    
    if (sender.tag == 0) {
        img.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
//        [img setImage:[ThemeInsteadTool imageWithImageName:@"arrow_up"] forState:UIControlStateNormal];
        [self.imgArr replaceObjectAtIndex:img.tag withObject:img];
        [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
        [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    } else {
        if (sender.tag == self.flag) {
            _count ++ ;
            if (_count % 2 == 1) {
//                [img setImage:[ThemeInsteadTool imageWithImageName:@"arrow_up_selected"] forState:UIControlStateNormal];
                img.image = [ThemeInsteadTool imageWithImageName:@"arrow_up_selected"];
                asc = 1;
            } else {
//                [img setImage:[ThemeInsteadTool imageWithImageName:@"arrow_down_selected"] forState:UIControlStateNormal];
                img.image = [ThemeInsteadTool imageWithImageName:@"arrow_down_selected"];
                asc = 2;
            }
        } else {
            img.image = [ThemeInsteadTool imageWithImageName:@"arrow_down_selected"];
//            [img setImage:[ThemeInsteadTool imageWithImageName:@"arrow_down_selected"] forState:UIControlStateNormal];
            asc = 2;
            _count = 0;
        }
        [self.imgArr replaceObjectAtIndex:img.tag withObject:img];
        [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
        [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    }
    self.flag = sender.tag;
    [self clickRepons:sender asc:asc];
}

-(void)clickRepons:(UIButton *)sender asc:(NSInteger)asc
{
    if ([_delegate respondsToSelector:@selector(clickRepons:asc:)]) {
        [_delegate clickRepons:sender asc:asc];
    }
}

@end
