//
//  QualityView.m
//  SelectControl
//
//  Created by DiorSama on 2016/11/15.
//  Copyright © 2016年 DiorSama. All rights reserved.
//

#import "QualityView.h"

#import "PriceLeftCell.h"



@interface QualityView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger width;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic,strong) NSString * dataStr;
@property (nonatomic,strong) NSArray * arr;
@property (nonatomic,strong) UIButton * btn;
@property (nonatomic, assign)NSInteger btnIndex;

@end

@implementation QualityView

- (instancetype) initWithFrame:(CGRect)frame withNSArray:(NSArray*)arr
{
    if (self = [super initWithFrame:frame]){
        
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 135) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"PriceLeftCell" bundle:nil] forCellReuseIdentifier:@"priceLeftCell"];
        self.tableView.rowHeight = 45;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        self.selectIndex = -1;
        self.arr = arr;
        self.btnIndex = -1;
        
        
        
    }
    return self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.arr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PriceLeftCell* cell = [tableView dequeueReusableCellWithIdentifier:@" priceLeftCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceLeftCell" owner:nil options:nil] lastObject];
    }
    
    
    IntelligentOrderModel * model = self.arr[indexPath.row];
    // NSArray * imageArr = @[@"price_gray",@"star_level",@"people_num"];
    //   NSArray * selectArr = @[@"图层10拷贝",@"xx拷贝",@""];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.arr = self.arr;
    [cell.titleBtn setTitle:[NSString stringWithFormat:@"  %@",model.fieldName] forState:UIControlStateNormal];
    
    
    
    
    
    if (self.btnIndex-1 == indexPath.row) {
        cell.titleBtn.selected = self.btn.selected;
        
        
        if(cell.titleBtn.selected){
            [cell.titleBtn setTitleColor:[UIColor colorWithRed:89/255.0 green:191/255.0 blue:94/255.0 alpha:1] forState:UIControlStateSelected];
            UIImage* img = [ThemeInsteadTool imageWithImageName:@"arrow_up_selected"];
            
            [cell.titleBtn setTintColor:[UIColor whiteColor]];
            
            
            cell.arrowsImage.image = img;
            
            
        }else{
            
            
            [cell.titleBtn setTitleColor:[UIColor colorWithRed:89/255.0 green:191/255.0 blue:94/255.0 alpha:1] forState:UIControlStateNormal];
            UIImage* img = [ThemeInsteadTool imageWithImageName:@"arrow_down_selected"];
            cell.arrowsImage.image = img;
            
            
        }
        
    }
    else {
        [cell.titleBtn setTintColor:[UIColor colorWithRed:193/255.0 green:194/255.0 blue:195/255.0 alpha:1]];
        
        if(cell.titleBtn.selected){
            [cell.titleBtn setTitleColor:[UIColor colorWithRed:193/255.0 green:194/255.0 blue:195/255.0 alpha:1] forState:UIControlStateSelected];
            
            
        }else{
            [cell.titleBtn setTitleColor:[UIColor colorWithRed:193/255.0 green:194/255.0 blue:195/255.0 alpha:1] forState:UIControlStateNormal];
            
        }
        cell.arrowsImg.image = [UIImage imageNamed:@"arrows_gray"];
        
    }
    
    
    [cell.titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleBtn.tag = indexPath.row+1;
    
    return cell;
    
}


-(void)clickTitleBtn:(UIButton*)btn{
    
    self.btnIndex = btn.tag;
    btn.selected = !btn.selected;
    self.btn = btn;
    
    [self.tableView reloadData];
    
    IntelligentOrderModel * model = self.arr[btn.tag-1];
    self.fieldCode = model.fieldCode;
    self.fieldName = model.fieldName;
    if(btn.selected){
//        if(_delegate){
//         [self.delegate interactData:@"1" tag:2 data:model.fieldCode];
//        }
        self.isUp = YES;
        
    }
    else{
        self.isUp = NO;
//        if(_delegate){
//          [self.delegate interactData:@"0" tag:2 data:model.fieldCode];
//        }
    }
    
  
    
}



@end
