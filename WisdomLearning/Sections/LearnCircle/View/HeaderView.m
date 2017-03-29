//
//  HeaderView.m
//  ElevatorUncleManage
//
//  Created by Shane on 16/7/12.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "HeaderView.h"
//#import "ZSDateSelectView.h"
@interface HeaderView()//<ZSDateSelectViewDelegate>
@property(nonatomic,strong) NSMutableArray *btnArr;
@property(nonatomic,strong) NSMutableArray *imgArr;
@property(nonatomic,strong) UIButton *time_btn;
@property (nonnull,strong) NSArray * titles;

@property (nonnull,strong) NSArray *selectedImages;
@property (nonnull,strong) UIView * view;

@end
@implementation HeaderView
-(instancetype)initWithFrame:(CGRect)frame withTitleArr:(NSArray*)titleArr withImageArr:(NSArray*)imageArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.btnArr = [NSMutableArray array];
        self.imgArr = [NSMutableArray array];
        self.titles = titleArr;
        self.selectedImages = imageArr;
        self.selectIndex = -1;
//        UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 12, 12)];
//        im.image = [UIImage imageNamed:@"icon15.02"];
//        [self addSubview:im];
        
//        NSArray *arr = @[@"时间",@"热度",@"匹配度"];
//        CGFloat f = 0;
//        for (int i = 0; i < arr.count; i++) {
//            NSString *str = arr[i];
//            CGSize size = [str boundingRectWithSize:CGSizeMake(999, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
//            
//            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3-10, 40)];
//            [btn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:5];
//            UIImageView * im = [[UIImageView alloc]init];
//            
//            if(i==2){
//                im.frame = CGRectMake(SCREEN_WIDTH/3+i*SCREEN_WIDTH/3-SCREEN_WIDTH*0.09 , 16, 12, 8);
//            }
//            else{
//               im.frame = CGRectMake(SCREEN_WIDTH/3+i*SCREEN_WIDTH/3-SCREEN_WIDTH*0.1, 16, 12, 8);
//            }
//            im.tag = i;
//            [self addSubview:im];
//            btn.tag = i;
//            btn.titleLabel.font = [UIFont systemFontOfSize:14];
//            [btn setTitle:arr[i] forState:UIControlStateNormal];
//            if (i == 0) {
//                btn.selected = YES;
//                [btn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
//                im.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
//                [self.btnArr addObject:btn];
//            }else{
//                [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
//                im.image = [UIImage imageNamed:@"arrow_gray"];
//            }
//            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:btn];
//            f = f + size.width + 5 +35+i*SCREEN_WIDTH/3;
//            [self.imgArr addObject:im];
//        }
        
        
      //  NSArray *arr = @[@"排序",@"筛选"];
      //  CGFloat f = 0;

       // [self createView];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 0.5)];
        lineV.backgroundColor = KMainLine;
        [self addSubview:lineV];

    }
    return self;
}

-(void)changeTitles:(NSArray *)titles{
    _titles = titles;
    [self setNeedsDisplay];
}

-(void)changeSelectedImages:(NSArray *)selectedImages{
    _selectedImages = selectedImages;
    [self setNeedsDisplay];
}

-(void)reloadData{
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect{
    
    [self.view removeFromSuperview];
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41)];
    for (int i = 0; i < _titles.count; i++) {
        
     
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-10, 40)];
        [btn setEnlargeEdgeWithTop:0 right:15 bottom:0 left:5];
        
        
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(5.0, -30.0, 5.0, 0.0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(15.0,  100, 15.0, SCREEN_WIDTH/2-130);
        
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(-btn.titleLabel.intrinsicContentSize.height, 0, 0, -btn.titleLabel.intrinsicContentSize.width)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.currentImage.size.height, -btn.currentImage.size.width, 0, 0)];
        
        // SCREEN_WIDTH/2-140
        
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        
        [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
        
         [btn setImage:self.selectedImages[i] forState:UIControlStateNormal];
        if(i==0){
            if(![_titles[0] isEqualToString:@"排序"])
           [btn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
        }
        else{
            if(self.selectIndex == 2){
                [btn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
            }
        }
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
       
    }
    [self addSubview:self.view];

}

-(void)click:(UIButton *)sender{
    
//   // if(sender.tag == 0)
////    [btn setTitleColor:kMainThemeColor forState:UIControlStateNormal];
////    [btn setImage:[ThemeInsteadTool imageWithImageName:@"arrow_up"] forState:UIControlStateNormal];
//    
//    UIButton *btn = self.btnArr[self.btnArr.count - 1];
//   // UIImageView *im = self.imgArr[btn.tag];
//    [self.btnArr addObject:sender];
////    if (btn.tag == sender.tag) {
////        if (sender.selected) {
////            sender.selected = NO;
////            im.image = [UIImage imageNamed:@"pull_up"];
////            [self.imgArr replaceObjectAtIndex:im.tag withObject:im];
////        }else{
////            sender.selected = YES;
////            im.image = [UIImage imageNamed:@"pull_down"];
////            [self.imgArr replaceObjectAtIndex:im.tag withObject:im];
////        }
////    }else{
//        sender.selected = YES;
////        im.image = [UIImage imageNamed:@"arrow_gray"];
////        [self.imgArr replaceObjectAtIndex:im.tag withObject:im];
////        
////        UIImageView *img = self.imgArr[sender.tag];
////        img.image = [ThemeInsteadTool imageWithImageName:@"arrow_up"];
////        [self.imgArr replaceObjectAtIndex:img.tag withObject:img];
//        [btn setTitleColor:KMainTextBlack forState:UIControlStateNormal];
//        [sender setTitleColor:kMainThemeColor forState:UIControlStateNormal];
//   // }
    [self clickRepons:sender];
}

-(void)clickRepons:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(clickRepons:)]) {
        [_delegate clickRepons:sender];
    }
}

//-(void)seachTime{
//    ZSDateSelectView *view = [[ZSDateSelectView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 254) width:SCREEN_WIDTH - 20];
//    view.delegate = self;
//    self.popupView = [KLCPopup popupWithContentView:view showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
//    [self.popupView showWithLayout:KLCPopupLayoutCenter];
//}
//
//-(void)selectTechnicianViewCancel{
//    [self.popupView dismiss:YES];
//}
//-(void)selectTechnicianViewString:(NSString *)text{
//    if ([_delegate respondsToSelector:@selector(selectTimeButton:)]) {
//        [_delegate selectTimeButton:text];
//    }
//    [self.time_btn setTitle:text forState:UIControlStateNormal];
//    [self.popupView dismiss:YES];
//}

@end
