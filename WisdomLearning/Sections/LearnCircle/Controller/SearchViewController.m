//
//  SearchViewController.m
//  BigMovie
//
//  Created by hfcb001 on 16/2/18.
//  Copyright © 2016年 zhisou. All rights reserved.
//首页搜索

#import "DemandChargeCell.h"
#import "JZSearchBar.h"
#import "SearchViewController.h"
#import "ZWTagListView.h"
#import <Masonry/Masonry.h>
#import "CourseStudyViewController.h"
#import "FaceTeachingViewController.h"
#import <TPKeyboardAvoiding/TPKeyboardAvoidingTableView.h>
#import "UIViewController+PagesControl.h"

#import "SearchCoursrViewController.h"

#import "SearchInfoController.h"
#import "SearchSpecalViewController.h"
#import "SearchCerViewController.h"
#import "SearchCircleViewController.h"
#import "DynDetailsViewController.h"
#import "LeanCircleDetailController.h"
#import "CertificateDetailViewController.h"
#import "SpecialDetailViewController.h"
#import "PersonalDetailsViewController.h"


@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GetClickBtnText,ClearHistoryMark,ComDelegate> {
    
    NSArray* strArray; //保存标签数据的数组
    int str_length; //字符串实际长度
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) JZSearchBar* searchBar;
@property (nonatomic, strong) NSMutableArray * modelArr;
@property (nonatomic,strong) UIView * pageView;
@property (nonatomic,strong) NSMutableArray * viewPages;
@property (nonatomic,strong) NSMutableArray * hotKeys;
@property (nonatomic,strong) NSArray * myKeys;
@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,strong)  SearchCoursrViewController * v1 ;
@property (nonatomic,strong) SearchInfoController * v2 ;
@property (nonatomic,strong) SearchCircleViewController * v3 ;
@property (nonatomic,strong) SearchCerViewController * v4 ;
@property (nonatomic,strong) SearchSpecalViewController * v5  ;
@property (nonatomic,assign) BOOL isSearchAll;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
    
    _modelArr = [[NSMutableArray alloc]init];
    strArray = [[NSArray alloc]init];
    _dataArr = [[NSMutableArray alloc]init];
     _hotKeys = [[NSMutableArray alloc]init];
    NSUserDefaults * searchArr = [NSUserDefaults standardUserDefaults];
    [_dataArr addObjectsFromArray:[searchArr objectForKey:@"searchHistory"]];
 
    [self createSearch];
    [self setupTableView];
    [self createRefresh];
    [self fetchSearchKey];
    
    if(_type == SearchAll){
        
        
        NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
        
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
        NSDictionary *settingDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][identifier];
        
        self.isSearchAll = settingDict[@"isSearchAll"];
      
        [self createPagesView];
        
    }
    else{

    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak SearchViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchSearchKey];
    }];
    
  
}

-(void)fetchSearchKey
{
    NSDictionary * dic = @{@"userId":gUserID};
    [self.request requestSearchKeyWithDic:dic block:^(ZSSearchKeyModel *model, NSError *error) {
        if(model.isSuccess){
            SearchKeyWordModel * key = model.data;
            NSArray * arr = [key.hotkeys componentsSeparatedByString:@","];
            for (int i=0;i<arr.count;i++){
                NSString * str = arr[i];
                if(str.length>0){
                    [_hotKeys addObject:str];
                }
            }
            _myKeys = [key.mykeys componentsSeparatedByString:@","];
            
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
}


#pragma mark--- 创建ViewControllers
-(void)createPagesView
{
    
    NSMutableArray * titleArr = [[NSMutableArray alloc]init];
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    NSArray *homeArray = [Tool getAppHomeFunctionModule];
    for(int i= 0;i<arr.count;i++){
        NSString * str = arr[i];
        if([str isEqualToString:@"1"]){
       
          
            [titleArr addObject:homeArray[0]];
        } else if([str isEqualToString:@"2"]){
           
          
            [titleArr addObject:homeArray[1]];
        } else  if([str isEqualToString:@"3"]){
           
            [titleArr addObject:homeArray[2]];
        
        }  else  if([str isEqualToString:@"4"]){
          
       
            [titleArr addObject:homeArray[3]];
        } else  if([str isEqualToString:@"5"]) {
       
            [titleArr addObject:homeArray[4]];
        }
    }
    
    _pageView = [self pagesViewWithFrame:CGRectMake(0, 60 , SCREEN_WIDTH,SCREEN_HEIGHT - 60 ) andTitles:titleArr andTitleFontSize:15 andImages:nil andPageControllers:self.viewPages andSegmentColor:[UIColor whiteColor]];
    
    
}

#pragma mark---  containerView
-(NSMutableArray *)viewPages{
    
    if (!_viewPages) {
        

        _viewPages = [[NSMutableArray alloc]init];

        NSArray *arr = [indexfunc componentsSeparatedByString:@","];
        NSMutableArray * dataArr = [[NSMutableArray alloc]init];
   
        for(int i= 0;i<arr.count;i++){
            NSString * str = arr[i];
            if([str isEqualToString:@"1"]){
                
                _v1 = [[SearchCoursrViewController alloc]init];
                _v1.delegate = self;
                [dataArr addObject:_v1];
           
            } else if([str isEqualToString:@"2"]){
                _v2 = [[SearchInfoController alloc]init];
                _v2.delegate = self;
                [dataArr addObject:_v2];
            
            } else  if([str isEqualToString:@"3"]){
                
                _v5  = [[SearchSpecalViewController alloc]init];
                    _v5.delegate =self;
                [dataArr addObject:_v5];
             
                
            }  else  if([str isEqualToString:@"4"]){
                
                         _v3 = [[SearchCircleViewController alloc]init];
                        _v3.delegate =self;
                [dataArr addObject:_v3];
           
            } else  if([str isEqualToString:@"5"]) {
                        _v4 = [[SearchCerViewController alloc]init];
                        _v4.delegate =self;
                [dataArr addObject:_v4];
             
            }
        }

        [_viewPages addObjectsFromArray:dataArr];
       
//        if(self.isSearchAll){
//            _v1 = [[SearchCoursrViewController alloc]init];
//            _v1.delegate = self;
//            _v2 = [[SearchInfoController alloc]init];
//            _v2.delegate = self;
//          
//            _v5  = [[SearchSpecalViewController alloc]init];
//            _v5.delegate =self;
//             _viewPages = @[ _v2, _v1,_v5];
//        }
//        else{
//            _v1 = [[SearchCoursrViewController alloc]init];
//            _v1.delegate = self;
//            _v2 = [[SearchInfoController alloc]init];
//            _v2.delegate = self;
//            _v3 = [[SearchCircleViewController alloc]init];
//            _v3.delegate =self;
//            _v4 = [[SearchCerViewController alloc]init];
//            _v4.delegate =self;
//            _v5  = [[SearchSpecalViewController alloc]init];
//            _v5.delegate =self;
//            _viewPages = @[ _v1, _v2, _v3,_v4,_v5];
//        }
//        
    }
    return _viewPages;
}


- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView
{
    [self.view endEditing:YES];
}

- (void)setupTableView
{
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64-50) style:UITableViewStyleGrouped];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


- (void)createSearch
{
    NSMutableArray * titleArr = [[NSMutableArray alloc]init];
    NSArray *arr = [indexfunc componentsSeparatedByString:@","];
    NSArray *homeArray = [Tool getAppSearchModule];
    for(int i= 0;i<arr.count;i++){
        NSString * str = arr[i];
        if([str isEqualToString:@"1"]){
            
            
            [titleArr addObject:homeArray[0]];
        } else if([str isEqualToString:@"2"]){
            
            
            [titleArr addObject:homeArray[1]];
        } else  if([str isEqualToString:@"3"]){
            
            [titleArr addObject:homeArray[2]];
            
        }  else  if([str isEqualToString:@"4"]){
            
            
            [titleArr addObject:homeArray[3]];
        } else  if([str isEqualToString:@"5"]) {
            
            [titleArr addObject:homeArray[4]];
        }
    }
    NSString * str = [titleArr componentsJoinedByString:@"、"];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    self.searchBar = [JZSearchBar searchBar];
    self.searchBar.delegate = self;
   // @"搜索动态、课程、培训";
    self.searchBar.placeholder = [NSString stringWithFormat:@"搜索%@",str];
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.frame = CGRectMake(10, 10, SCREEN_WIDTH - 70, 30);
    self.searchBar.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [view addSubview:self.searchBar];
    [self.view addSubview:view];
    
    UIButton* button_back = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- 50.0f, 3,44.0f, 44.0f)];
    
    button_back.titleLabel.font = [UIFont systemFontOfSize:15];
    [button_back setTitle:@"取消" forState:UIControlStateNormal];
    [button_back setTitleColor:kMainThemeColor forState:UIControlStateNormal];
    [button_back.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button_back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button_back];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
//    if(_dataArr.count == 0){
//        if(_hotKeys.count == 0){
//            return 0;
//        }
//        else{
//            return 1;
//        }
//    }
//    else if(_hotKeys.count == 0){
//        if(_dataArr.count == 0){
//            return 0;
//        }
//        else{
//            return 1;
//        }
//    }
//    else{
//        return 2;
//    }
    return 2;
   
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if(_dataArr.count == 0){
            return 0;
        }
        else{
            return _dataArr.count+1;
        }
    }
    else{
        if(_hotKeys.count == 0){
            return 0;
        }
        return 1;
        
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            DemandChargeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"demandChargeCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DemandChargeCell" owner:nil options:nil] lastObject];
            }
            cell.titleLabel.text = @"历史搜索记录";
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.titleLabel.textColor = KMainOrange;
            cell.delegate = self;
            cell.clearBtn.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            DemandChargeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"demandChargeCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"DemandChargeCell" owner:nil options:nil] lastObject];
            }
            
            cell.titleLabel.text = _dataArr[indexPath.row-1];
            cell.titleLabel.font = [UIFont systemFontOfSize:15];
            cell.titleLabel.textColor = KMainBlack;
            cell.clearBtn.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    else {
        DemandChargeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"demandChargeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DemandChargeCell" owner:nil options:nil] lastObject];
        }
        cell.titleLabel.text = @"热门搜索";
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.titleLabel.textColor = KMainOrange;
        cell.clearBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if(indexPath.section==0 && indexPath.row !=0){
    [self.searchBar resignFirstResponder];
   
            [_tableView removeFromSuperview];
             self.searchBar.text = _dataArr[indexPath.row-1];
    
            if(_type == SearchAll){
                [self.view addSubview:_pageView];

                _v1.key =_dataArr[indexPath.row-1];
                _v2.key =_dataArr[indexPath.row-1];
                _v3.key =_dataArr[indexPath.row-1];
                _v4.key =_dataArr[indexPath.row-1];
                _v5.key =_dataArr[indexPath.row-1];
                _v1.height = 40;
                _v2.height = 40;
                _v3.height = 40;
                _v4.height = 40;
                _v5.height = 40;
                [_v1 searchFetchData];
                [_v2 searchFetchData];
                [_v3 searchFetchData];
                [_v4 searchFetchData];
                [_v5 searchFetchData];

            }
            else{
                
                if(_type == SearchSpecial){
                    [_v5.view removeFromSuperview];
                    _v5 = [[SearchSpecalViewController alloc]init];
                    _v5.delegate =self;
                        _v5.key  =  _dataArr[indexPath.row-1];
                    _v5.height = 0;
                    _v5.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                
                    [self.view addSubview:_v5.view];
                    
                }
                else if(_type == SearchLearnCircle){
                    [_v3.view removeFromSuperview];
                    _v3 = [[SearchCircleViewController alloc]init];
                    _v3.delegate =self;
                     _v3.key  =  _dataArr[indexPath.row-1];
                     _v3.height = 0;
                    _v3.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                   
                    [self.view addSubview:_v3.view];
                }
                else if(_type == SearchCertificate){
                    [_v4.view removeFromSuperview];
                    _v4 = [[SearchCerViewController alloc]init];
                    _v4.delegate =self;
                      _v4.key  =  _dataArr[indexPath.row-1];
                     _v4.height = 0;
                    _v4.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                  
                    [self.view addSubview:_v4.view];
                }
                else if(_type == SearchCourse){
                    [_v1.view removeFromSuperview];
               
                    
                    _v1 = [[SearchCoursrViewController alloc]init];
                     _v1.delegate =self;
                    _v1.key  = _dataArr[indexPath.row-1];
                     _v1.height = 0;
                    _v1.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                    
                    [self.view addSubview:_v1.view];
                }
                else{
                    [_v2.view removeFromSuperview];
                    _v2 = [[SearchInfoController alloc]init];
                    _v2.delegate = self;
                     _v2.key  =  _dataArr[indexPath.row-1];
                     _v2.height = 0;
                    _v2.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                   
                    [self.view addSubview:_v2.view];
                }
            }

    
                NSMutableArray * historyArr = [[NSMutableArray alloc]init];
                NSUserDefaults * searchArr = [NSUserDefaults standardUserDefaults];
                [historyArr addObjectsFromArray:[searchArr objectForKey:@"searchHistory"]];
                
                NSInteger num = 0;
                for(int i =0;i<historyArr.count;i++){
                    
                    if([historyArr[i] isEqualToString:_dataArr[indexPath.row-1]]){
                        [historyArr removeObjectAtIndex:i];
                        [historyArr insertObject:_dataArr[indexPath.row-1] atIndex:0];
                        num ++;
                    }
                    
                }
                if(num == 0){
                    if(historyArr.count<5){
                        [historyArr insertObject:_dataArr[indexPath.row-1] atIndex:0];
                    }
                    else{
                        [historyArr removeObjectAtIndex:4];
                        [historyArr insertObject:_dataArr[indexPath.row-1] atIndex:0];
                    }
                }
                
                NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
                [user setObject:_dataArr[indexPath.row-1] forKey:@"searchStr"];
                [user synchronize];
                
                
                NSArray * array = historyArr;
                NSUserDefaults * searchHistory = [NSUserDefaults standardUserDefaults];
                [searchHistory setObject:array forKey:@"searchHistory"];
                [searchHistory synchronize];
                
                NSUserDefaults * userType = [NSUserDefaults standardUserDefaults];
                [userType setObject:[NSString stringWithFormat:@"%ld",(long)self.index-1] forKey:@"searchType"];
                [userType synchronize];
                
                
                
                [_dataArr removeAllObjects];
                [_dataArr addObjectsFromArray:historyArr];
        
            [_tableView reloadData];
    }

}


- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        UIView* view = [[UIView alloc] init];
        ZWTagListView* tagList = [[ZWTagListView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH , 0)];
        tagList.delegate = self;
        tagList.signalTagColor = [UIColor grayColor];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [ZWTagListView getTagViewHeight:_hotKeys withWidth:SCREEN_WIDTH - 10]);
        [tagList setTagWithTagArray:_hotKeys];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:tagList];
        return view;
    }
    return nil;
}


- (void)clickGetText:(NSString*)tagName
{
 
    [self addSearchKeyWordWith:tagName];
    [self.searchBar resignFirstResponder];
    
    [_tableView removeFromSuperview];
    
    self.searchBar.text = tagName;

    if(_type == SearchAll){
      
          [self.view addSubview:_pageView];
        _v1.key =tagName;
        _v2.key =tagName;
        _v3.key =tagName;
        _v4.key =tagName;
        _v5.key =tagName;
        _v1.height = 40;
        _v2.height = 40;
        _v3.height = 40;
        _v4.height = 40;
        _v5.height = 40;
        [_v1 searchFetchData];
        [_v2 searchFetchData];
        [_v3 searchFetchData];
        [_v4 searchFetchData];
        [_v5 searchFetchData];
        
    }
    else{
        
        if(_type == SearchSpecial){
            [_v5.view removeFromSuperview];
            _v5 = [[SearchSpecalViewController alloc]init];
            _v5.delegate =self;
              _v5.key  =  tagName;
             _v5.height = 0;
            _v5.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
          
            [self.view addSubview:_v5.view];
            
        }
        else if(_type == SearchLearnCircle){
            [_v3.view removeFromSuperview];
            _v3 = [[SearchCircleViewController alloc]init];
            _v3.delegate =self;
             _v3.key  =  tagName;
             _v3.height = 0;
            _v3.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
           
            [self.view addSubview:_v3.view];
        }
        else if(_type == SearchCertificate){
            [_v4.view removeFromSuperview];
            _v4 = [[SearchCerViewController alloc]init];
            _v4.delegate =self;
                _v4.key  =  tagName;
             _v4.height = 0;
            _v4.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
        
            [self.view addSubview:_v4.view];
        }
        else if(_type == SearchCourse){
            [_v1.view removeFromSuperview];
            
            
            _v1 = [[SearchCoursrViewController alloc]init];
            _v1.delegate = self;
            _v1.key  =  tagName;
             _v1.height = 0;
            _v1.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
            
            [self.view addSubview:_v1.view];
        }
        else{
            [_v2.view removeFromSuperview];
            _v2 = [[SearchInfoController alloc]init];
            _v2.delegate =self;
             _v2.key  =  tagName;
             _v2.height = 0;
            _v2.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
           
            [self.view addSubview:_v2.view];
        }
    }
    
    
    NSMutableArray * historyArr = [[NSMutableArray alloc]init];
    NSUserDefaults * searchArr = [NSUserDefaults standardUserDefaults];
    [historyArr addObjectsFromArray:[searchArr objectForKey:@"searchHistory"]];
    
    NSInteger num = 0;
    for(int i =0;i<historyArr.count;i++){
        
        if([historyArr[i] isEqualToString:tagName]){
            [historyArr removeObjectAtIndex:i];
            [historyArr insertObject:tagName atIndex:0];
            num ++;
        }
        
    }
    if(num == 0){
        if(historyArr.count<5){
            [historyArr insertObject:tagName atIndex:0];
        }
        else{
            [historyArr removeObjectAtIndex:4];
            [historyArr insertObject:tagName atIndex:0];
        }
    }
    
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setObject:tagName forKey:@"searchStr"];
    [user synchronize];
    
    
    NSArray * array = historyArr;
    NSUserDefaults * searchHistory = [NSUserDefaults standardUserDefaults];
    [searchHistory setObject:array forKey:@"searchHistory"];
    [searchHistory synchronize];
    
    NSUserDefaults * userType = [NSUserDefaults standardUserDefaults];
    [userType setObject:[NSString stringWithFormat:@"%ld",(long)self.index-1] forKey:@"searchType"];
    [userType synchronize];
    
    
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:historyArr];
      [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        if(_modelArr.count ==0){
            return CGFLOAT_MIN;
        }
        else{
            return 10;
        }
    }
    return 10;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row > 0) {
            return 50;
        }
    }
    return 37;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==0){
        return CGFLOAT_MIN;
    }
    else{
        if(_hotKeys.count == 0){
            return CGFLOAT_MIN;
        }
        else{
           return [ZWTagListView getTagViewHeight:_hotKeys withWidth:SCREEN_WIDTH] + 20; 
        }
    }
    
}

//请求数据
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if (self.searchBar.text.length != 0) {
        
        

       
        if(_type == SearchAll){
         
             [self.view addSubview:_pageView];
            
            _v1.key =self.searchBar.text;
            _v2.key =self.searchBar.text;
            _v3.key =self.searchBar.text;
            _v4.key =self.searchBar.text;
            _v5.key =self.searchBar.text;
            _v1.height = 40;
            _v2.height = 40;
            _v3.height = 40;
            _v4.height = 40;
            _v5.height = 40;
            [_v1 searchFetchData];
            [_v2 searchFetchData];
            [_v3 searchFetchData];
            [_v4 searchFetchData];
            [_v5 searchFetchData];
           
            
        }
        else{
            
            if(_type == SearchSpecial){
                [_v5.view removeFromSuperview];
                _v5 = [[SearchSpecalViewController alloc]init];
                _v5.delegate =self;
                 _v5.key  =  self.searchBar.text;
                 _v5.height = 0;
                _v5.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                
                 [self.view addSubview:_v5.view];
                
            }
            else if(_type == SearchLearnCircle){
                [_v3.view removeFromSuperview];
                _v3 = [[SearchCircleViewController alloc]init];
                _v3.delegate =self;
                 _v3.key  =  self.searchBar.text;
                 _v3.height = 0;
                 _v3.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                
                 [self.view addSubview:_v3.view];
            }
            else if(_type == SearchCertificate){
                [_v4.view removeFromSuperview];
                _v4 = [[SearchCerViewController alloc]init];
                _v4.delegate =self;
                _v4.key  =  self.searchBar.text;
                 _v4.height = 0;
                 _v4.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
                
                 [self.view addSubview:_v4.view];
            }
            else if(_type == SearchCourse){
                [_v1.view removeFromSuperview];
               

                _v1 = [[SearchCoursrViewController alloc]init];
                _v1.delegate = self;
                 _v1.key  =  self.searchBar.text;
                 _v1.height = 0;
                 _v1.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-50);
              
                 [self.view addSubview:_v1.view];
            }
            else{
                [_v2.view removeFromSuperview];
                _v2 = [[SearchInfoController alloc]init];
                _v2.delegate = self;
                  _v2.key  =  self.searchBar.text;
                _v2.height = 0;
                 _v2.view.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT);
               
                 [self.view addSubview:_v2.view];
            }
        }
        
        if (self.searchBar.text.length != 0) {
            NSMutableArray * historyArr = [[NSMutableArray alloc]init];
            NSUserDefaults * searchArr = [NSUserDefaults standardUserDefaults];
            [historyArr addObjectsFromArray:[searchArr objectForKey:@"searchHistory"]];
            
            NSInteger num = 0;
            for(int i =0;i<historyArr.count;i++){
                
                if([historyArr[i] isEqualToString:self.searchBar.text]){
                    [historyArr removeObjectAtIndex:i];
                    [historyArr insertObject:self.searchBar.text atIndex:0];
                    num ++;
                }
                
            }
            if(num == 0){
                if(historyArr.count<5){
                    [historyArr insertObject:self.searchBar.text atIndex:0];
                }
                else{
                    [historyArr removeObjectAtIndex:4];
                    [historyArr insertObject:self.searchBar.text atIndex:0];
                }
            }
            
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:self.searchBar.text forKey:@"searchStr"];
            [user synchronize];
            
            
            NSArray * array = historyArr;
            NSUserDefaults * searchHistory = [NSUserDefaults standardUserDefaults];
            [searchHistory setObject:array forKey:@"searchHistory"];
            [searchHistory synchronize];
            
            NSUserDefaults * userType = [NSUserDefaults standardUserDefaults];
            [userType setObject:[NSString stringWithFormat:@"%ld",(long)self.index-1] forKey:@"searchType"];
            [userType synchronize];
            
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:historyArr];
        }
    [self.searchBar resignFirstResponder];
    
    [_tableView removeFromSuperview];
    

    [_tableView reloadData];
    }
    
   
    [self.searchBar resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    
    [self.searchBar resignFirstResponder];
}

//取消搜索
- (void)back:(id)sender
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.view addSubview:_tableView];
    [self.pageView removeFromSuperview];
    
    if(_type == SearchAll){
        [self createPagesView];
        
    }
    else{
        

    }
    

}

//清空历史记录
-(void)clearData:(UIButton *)btn
{
  
    NSUserDefaults * searchArr = [NSUserDefaults standardUserDefaults];
    [_dataArr removeAllObjects];
    [searchArr setObject:_dataArr forKey:@"searchHistory"];
    [_tableView reloadData];
    
    
}



-(void)clickCollectBtn:(UIButton *)btn
{
    NSLog(@"收藏");
}
#pragma mark -
#pragma mark - Private Methods
//监听TextField变化
//- (void)textFieldIsEditing:(NSNotification*)notfication
//{
//    NSLog(@"%@", self.searchBar.text);
//}

#pragma mark **** 添加搜索关键字接口  ***
-(void)addSearchKeyWordWith:(NSString *)keyWord
{
    NSDictionary * dic = @{@"userId":gUserID,@"Keyword":keyWord};
    [self.request requestAddSearchKey:dic block:^(ZSModel *model, NSError *error) {
        if(model.isSuccess){
            
        }
        else{
            
        }
    }];
}

-(void)interactData:(id)sender tag:(int)tag data:(id)data
{
    if(tag == 1){
    CourseStudyViewController *destVc = [CourseStudyViewController new];
    destVc.title = sender;
    destVc.courseId = data;
    [self.navigationController pushViewController:destVc animated:YES];
    }
    else if(tag == 2){
        DynDetailsViewController *vc =[DynDetailsViewController new];
        vc.ID = data;
     //   vc.isAdd = NO;
        vc.isCreateImg = NO;
//        DiscoveryInformation *model = sender;
//      //  CGFloat height = [GetHeight getHeightWithContent:model.title width:SCREEN_WIDTH-30 font:15];
//     
//     //   vc.height = 45+height;
//        vc.infoModel = sender;
        vc.type = 1;
       
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(tag == 3){
         LeanCircleDetailController * detail = [[LeanCircleDetailController alloc]init];
            detail.proId = data;
            detail.title = sender;
            detail.hidesBottomBarWhenPushed = YES;
            detail.title = [NSString stringWithFormat:@"%@详细",sender];
            [self.navigationController pushViewController:detail animated:YES];
            

    }
    else if(tag == 4){
        CertificateDetailViewController *vc = [[CertificateDetailViewController alloc]init];
        
        vc.cerId = data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
      
        
         ZSLearnCircleListModel *model =sender;
        
        if (model.joined) {
            PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
            vc.projectId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            SpecialDetailViewController *vc = [SpecialDetailViewController new];
            vc.projectId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }

       // SpecialDetailViewController *vc = [SpecialDetailViewController new];
      //  vc.projectId =data;

       
        

    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
