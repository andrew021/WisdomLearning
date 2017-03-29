//
//  TestViewController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TestViewController.h"
#import "WorkTestCell.h"
#import "WorkTestSelectCell.h"

@interface TestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSMutableArray * itemArr;
@property (nonatomic,strong) NSMutableArray * questionArr;
@property (nonatomic,strong) NSDictionary * questionDic;
@property (nonatomic,assign) BOOL isSingle;
@property (nonatomic,strong) NSMutableArray * historyArr;
@property (nonatomic,assign) BOOL isCanSideBack;
@property (nonatomic,strong) NSMutableArray * moreArr;
@property (nonatomic,strong) NSMutableArray * numArr;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
   // _num = 1;
    self.selectIndex = -1;
    _dataArr = [[NSMutableArray alloc]init];
    _itemArr = [[NSMutableArray alloc]init];
    _questionArr = [[NSMutableArray alloc]init];
    _historyArr = [[NSMutableArray alloc]init];
    _moreArr = [[NSMutableArray alloc]init];
    _isSingle = YES;
    _numArr = [[NSMutableArray alloc]init];
    [_numArr addObjectsFromArray:@[@3,@4,@5,@3,@4,@5,@3,@4,@5,@4]];
    if(_tag>5){
        _isSingle = NO;
    }
    
}



//setup TableView
-(void)createTableView
{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0-51-50) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 250;
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];
    
    
}


- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _num+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        static NSString* identifier = @"WorkTestCell";
        WorkTestCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WorkTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        static NSString* identifier = @"WorkTestSelectCell";
        WorkTestSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[WorkTestSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        NSArray * arr = @[@"answer_a",@"answer_b",@"answer_c",@"answer_d"];
        
        
        if(_isSingle){
            if (indexPath.row == self.selectIndex+1){
                [cell.iconBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
                
            }
            else{
                [cell.iconBtn setImage:[UIImage imageNamed:arr[indexPath.row-1]] forState:UIControlStateNormal];
                
            }
        }
        else{
           // cell.iconBtn.selected = NO;
            [cell.iconBtn setImage:[UIImage imageNamed:arr[indexPath.row-1]] forState:UIControlStateNormal];
           
            
            [cell.iconBtn setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            
        }
        

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconBtn.tag = indexPath.row-1;
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 150;
    }
    else{
        return 50;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(_isSingle){
        if(indexPath.row !=0){
          
            self.selectIndex = indexPath.row-1;
            NSString * questionId = [NSString stringWithFormat:@"%ld",(long)_tag];
            NSString * answerText = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            _questionDic = @{@"questionId":questionId,@"answerText":answerText};
            NSString * key = [NSString stringWithFormat:@"answerKey%ld",(long)_tag];
            NSUserDefaults * user = [[NSUserDefaults alloc]init];
            
            [user setObject:_questionDic forKey:key];
            [user synchronize];
            [self.tableView reloadData];
        }
    }
    else{
        if(indexPath.row>0){
            WorkTestSelectCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            cell.iconBtn.selected = !cell.iconBtn.selected;
            if(!cell.iconBtn.selected){
                
                
              
                NSString * text = [NSString stringWithFormat:@"%ld",(long)cell.iconBtn.tag];
                for (int i= 0;i<_moreArr.count;i++){
                    if([_moreArr[i] isEqualToString:text]){
                        [_moreArr removeObjectAtIndex:i];
                    }
                }
                
            }
            else{
                
                NSString * text = [NSString stringWithFormat:@"%ld",(long)cell.iconBtn.tag];
                [_moreArr addObject:text];
                
            }
            NSString * questionId = [NSString stringWithFormat:@"%ld",(long)_tag];
            NSString *answerText = [_moreArr componentsJoinedByString:@","];
            _questionDic = @{@"questionId":questionId,@"answerText":answerText};
            

            NSString * key = [NSString stringWithFormat:@"answerKey%ld",(long)_tag];
            NSUserDefaults * user = [[NSUserDefaults alloc]init];
            
            [user setObject:_questionDic forKey:key];
            [user synchronize];
            [self.tableView reloadData];
            
          
        }
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    if(_delegate){
        [self.delegate sendTag:_tag];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
