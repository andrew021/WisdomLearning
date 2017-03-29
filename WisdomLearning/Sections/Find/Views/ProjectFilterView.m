//
//  ProjectFilterView.m
//  WisdomLearning
//
//  Created by DiorSama on 2017/2/8.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ProjectFilterView.h"
#import "ZWTagListView.h"
#import "ZSLearnCircleListModel.h"
#import "MBProgressHUD.h"


@interface ProjectFilterView ()<GetClickBtnText,UITextFieldDelegate>

@property (nonatomic,strong) NSArray * codeArr;
@property (nonatomic,strong) NSArray * titleArr;
@property (nonatomic,strong)  ZWTagListView * tagList;
@property (nonatomic,strong) NSArray * dataArr;
@property (nonatomic,strong) UILabel * courseLabel;


@property (nonatomic,strong) UITextField * leftText;
@property (nonatomic,strong) UITextField * rightText;

@property (nonatomic,strong) UITextField * studyleftText;
@property (nonatomic,strong) UITextField * studyRightText;



@end
@implementation ProjectFilterView

- (instancetype) initWithFrame:(CGRect)frame withNSArray:(NSArray*)arr
{
    if (self = [super initWithFrame:frame]){
        _dataArr = arr;
        
        _selectTags = @[].mutableCopy;
        
        
        _selectCodeArr = [[NSMutableArray alloc]init];
        FilterFieldModel * model = arr[1];
        FilterFieldModel * model1 = arr[0];
        
        self.codeArr =  [model.enumCodes componentsSeparatedByString:@","];
        self.titleArr = [model.enumItems componentsSeparatedByString:@","];
        
        for (NSInteger index = 0; index < _titleArr.count ; ++index) {
            _selectTags[index] = @(NO);
        }
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel * priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, SCREEN_WIDTH/2, 20)];
        priceLabel.text = model1.filterTypeName;
        priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:priceLabel];
        
        self.courseLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, ViewMaxY(priceLabel)+65, SCREEN_WIDTH/2, 20)];
        _courseLabel.text = model.filterTypeName;
        _courseLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_courseLabel];
        
       // [self setViewWith:arr];
        
        NSArray * btnTitleArr = @[@"重置",@"确定"];
        for(int i=0;i<2;i++){
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(15+SCREEN_WIDTH/4*i, ViewMaxY(self.courseLabel)+65, SCREEN_WIDTH/4-15, 30);
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            
            btn.tag = i;
            [btn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:btn];
            
            
            UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(15+SCREEN_WIDTH/3.5*i, ViewMaxY(priceLabel)+20, SCREEN_WIDTH/3.5-30, 25)];
            textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            
            if(i==0){
                btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                textField.placeholder = @"最低价";
                self.leftText = textField;
            }
            else{
                btn.backgroundColor = kMainThemeColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                textField.placeholder = @"最高价";
                self.rightText = textField;
            }
            textField.delegate = self;
            textField.textAlignment = NSTextAlignmentCenter;
            textField.font = [UIFont systemFontOfSize:13];
            textField.tag = i;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            [self addSubview:textField];
            
            
            
            UITextField * text= [[UITextField alloc]initWithFrame:CGRectMake(15+SCREEN_WIDTH/3.5*i, ViewMaxY(self.courseLabel)+20, SCREEN_WIDTH/3.5-30, 25)];
            text.backgroundColor = [UIColor groupTableViewBackgroundColor];
            
            
            if(i==0){
                btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                text.placeholder = @"最少学时";
                self.studyleftText = text;
            }
            else{
                btn.backgroundColor = kMainThemeColor;
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                text.placeholder = @"最多学时";
                self.studyRightText = text;
            }
            text.delegate = self;
            text.textAlignment = NSTextAlignmentCenter;
            text.font = [UIFont systemFontOfSize:13];
            text.tag = i+2;
            text.keyboardType = UIKeyboardTypeNumberPad;
            [self addSubview:text];
        }
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.5-10, ViewMaxY(priceLabel)+32, 20, 1)];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView];
        
        UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.5-10, ViewMaxY(self.courseLabel)+32, 20, 1)];
        lineView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView2];
        
        UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, ViewMaxY(priceLabel)+60,  SCREEN_WIDTH/2+30, 1)];
        lineView1.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:lineView1];
        
    }
    return self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag==0){
        self.downString = textField.text;
    }
    else if(textField.tag == 1){
        self.highString = textField.text;
    }
    else if(textField.tag == 2){
        self.downStudy = textField.text;
    }
    else {
        self.highStudy = textField.text;
    }
}

- (void)clickGetText:(NSString*)tagName
{
    
}

-(void)clickGetBtnTag:(NSInteger)tag
{
    [self endEditing:YES];
    [self.selectCodeArr addObject:self.codeArr[tag]];
}

-(void)clickBtn:(UIButton *)btn{
    [self endEditing:YES];
    if (btn.selected) {
        [self.selectCodeArr addObject:self.codeArr[btn.tag]];
        self.selectTags[btn.tag] = @(YES);
    }else{
        [self.selectCodeArr removeObject:self.codeArr[btn.tag]];
        self.selectTags[btn.tag] = @(NO);
    }
}


-(void)setViewWith:(NSArray*)arr
{
    [self.selectCodeArr removeAllObjects];
    [self.tagList removeFromSuperview];
    
    
    
    
    //
    //    if(self.titleArr.count == 1){
    //        if([self.titleArr[0] isEqualToString:@""]){
    //
    //        }
    //        else{
    //            self.tagList = [[ZWTagListView alloc] initWithFrame:CGRectMake(5, ViewMaxY(_courseLabel)+20, SCREEN_WIDTH/2+20, 0)];
    //            self.tagList.signalTagColor = [UIColor whiteColor];
    //            self.tagList.delegate = self;
    //            [ self.tagList setTagWithTagArray:self.titleArr];
    //
    //            [self addSubview: self.tagList];
    //        }
    //    }
    //    else if(self.titleArr.count == 0){
    //
    //    }
    // else{
    self.tagList = [[ZWTagListView alloc] initWithFrame:CGRectMake(5, ViewMaxY(_courseLabel)+20, SCREEN_WIDTH/2+20, 0)];
    self.tagList.signalTagColor = [UIColor whiteColor];
    self.tagList.delegate = self;
    [ self.tagList setTagWithTagArray:self.titleArr];
    
    [self addSubview: self.tagList];
    // }
    
    
    
}

-(void)setPriceRange:(NSString *)priceRange{
    _priceRange = priceRange;
    
    if ([priceRange containsString:@","]) {
        NSArray *priceArr = [priceRange componentsSeparatedByString:@","];
        _leftText.text = priceArr[0];
        _rightText.text = priceArr[1];
        _highString = _rightText.text;
        _downString = _leftText.text;
    }
}

-(void)setStudyHourRange:(NSString *)studyHourRange
{
    _studyHourRange = studyHourRange;
    
    if ([studyHourRange containsString:@","]) {
        NSArray *priceArr = [studyHourRange componentsSeparatedByString:@","];
        _studyleftText.text = priceArr[0];
        _studyRightText.text = priceArr[1];
        _downStudy = _studyleftText.text;
        _highStudy = _studyRightText.text;
    }
}

-(void)setSelectTags:(NSMutableArray *)selectTags{
    [_tagList setTagStatusByArray:selectTags];
}


-(void)clickSelectBtn:(UIButton*)btn{
    [self endEditing:YES];
    if(btn.tag==0){
        //[self setViewWith:_dataArr];
        self.leftText.text = @"";
        self.rightText.text = @"";
        self.studyleftText.text = @"";
        self.studyRightText.text = @"";
        
        _highString = _rightText.text;
        _downString = _leftText.text;
        _downStudy =  self.studyleftText.text;
        _highStudy =  self.studyRightText.text;
        [_selectTags removeAllObjects];
    }
    else{
        
        if(self.downString.length>0 && self.highString.length>0){
            if([self.highString integerValue]<= [self.downString integerValue]){
                UIView *view = [[UIApplication sharedApplication].delegate window];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                hud.userInteractionEnabled = NO;
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"最低价不能大于或等于最高价!";
                hud.margin = 10.f;
                hud.yOffset = 180;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                return;
                
            }
        }
        
        if(self.downStudy.length>0 && self.highStudy.length>0){
            if([self.highStudy integerValue]<= [self.downStudy integerValue]){
                UIView *view = [[UIApplication sharedApplication].delegate window];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
                hud.userInteractionEnabled = NO;
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"最少学时不能大于或等于最大学时!";
                hud.margin = 10.f;
                hud.yOffset = 180;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:2];
                return;
                
            }
        }

        NSLog(@"%@ %@",self.downStudy,self.highStudy);
        if(_delegate){
            if (self.downString == nil) {
                self.downString = @"";
            }
            
            if (self.highString == nil) {
                self.highString = @"";
            }
            
            if (self.downStudy == nil) {
                self.downStudy = @"";
            }
            
            if (self.highStudy == nil) {
                self.highStudy = @"";
            }
            [self.delegate sendDownPrice:self.downString withHighPrice:self.highString withDownHour:self.downStudy whitHighHour:self.highStudy];
            
           // [self.delegate clickSureInFilterView:self];
          //  NSLog(@"%@ %@ %@ %@",self.downString,self.highString,self.downStudy,self.highStudy);
        }
    }
}
@end