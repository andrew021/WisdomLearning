//
//  TrainingSeminarViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/10.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "TrainingSeminarViewController.h"
#import "SpecialDetailViewController.h"
#import "LearnCircleCell.h"
#import "SearchViewController.h"
#import "PersonalDetailsViewController.h"
#import "SpecailListCell.h"
#import "ZSIntelligentSegment.h"
#import "QualityView.h"
#import "UIImage+rotation.h"
#import "FilterView.h"
#import "ZWTagListView.h"
#import "ZSPopUpSortView.h"
#import "ProjectFilterView.h"
#import "ZSFilterView.h"
#import "ZSFilterSegmentView.h"
#import "ZSFilterMultiChooseView.h"
#import "ZSIntelligentSegment.h"

@interface TrainingSeminarViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,ComDelegate,SendPriceAndProgram,ZSPopUpSortViewDelegate,ZSFilterViewDelegate
,ZSIntelligentSegmentDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign)CGFloat tableViewHeight;
@property (nonatomic, assign)CGFloat tableViewBottom;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic,strong) NSString * searchKey;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic,strong) QualityView * qualityView;
@property (nonatomic,strong) ProjectFilterView * filterView;
@property (nonnull,strong) NSArray * titleArr;
@property (nonatomic, strong) ZSPopUpSortView *sortView;
@property (nonatomic,strong) ZSIntelligentSegment * iSegment;


@property (nonatomic, strong) NSMutableArray *imageItems;
@property (nonatomic, strong) NSMutableArray *imageSelectedItems;

@property (nonatomic,strong) NSString * downString;
@property (nonatomic,strong) NSString * highString;
@property (nonatomic,strong) NSMutableArray * selectCodeArr;
@property (nonatomic,strong) NSString * code;
@property (nonatomic,assign) NSInteger  type;

@property (nonatomic, copy) NSString *order;


@property (nonatomic, strong) ZSFilterView *myFilterView;

@property (nonatomic, copy) NSString *filterItem;
@property (nonatomic, copy) NSString *filterValue;

@property (nonatomic, assign) CGFloat filterViewInitialHeight;



@end

@implementation TrainingSeminarViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *homeArray = [Tool getAppHomeFunctionModule];
    self.navigationItem.title = homeArray[2];
    [self initials];
    self.selectCodeArr = [[NSMutableArray alloc]init];
 
    _order = @"";

    _filterItem = @"";
    _filterValue = @"";
    if(_tenantId == nil){
        _tenantId = @"";
    }
    _filterViewInitialHeight = 0;
    
    if(!_isTabbarHide){
         self.titleArr = @[@"排序",@"筛选"];

        _tableViewHeight = 35;
        _tableViewBottom = 0;
        _iSegment = [[ZSIntelligentSegment alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35) andTitles:self.titleArr andImages:_imageItems andSelectedImages:_imageSelectedItems andTitleFont:[UIFont systemFontOfSize:14]];
        _iSegment.theDelegate = self;
        [self.view addSubview:_iSegment];
        
    } else{
        _tableViewHeight = 0;
        _tableViewBottom = 90;
    }
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClick)];
    [self.view addSubview:self.tableView];
    
    _dataArr = [[NSMutableArray alloc]init];
//    _searchKey = @"date";
    _searchKey = @"";
    [self createRefresh];
    [self fetchDataWith:_searchKey];
}


-(ZSPopUpSortView *)sortView{
    if (!_sortView) {
        
        NSMutableArray *titles = @[].mutableCopy;
        [[TypeManager sharedAPI].proIntelligentOrder enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IntelligentOrderModel *model = (IntelligentOrderModel *)obj;
            [titles addObject:model.fieldName];
        }];
        _sortView = [[ZSPopUpSortView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3,135) withTitles:titles];
        _sortView.theDelegate = self;
    }
    return _sortView;
}

#pragma mark --ZSIntelligentSegmentDelegate
-(void)clickTheSegmentIndex:(NSInteger)index{
    //  NSString * str = nil;
    if(index == 0){
        
        KLCPopup * popView = [KLCPopup popupWithContentView:self.sortView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
        
        [popView showAtCenter:CGPointMake(self.view.centerX-SCREEN_WIDTH/5, 100) inView:self.view];
        popView.didFinishDismissingCompletion = ^{
            
            //  请求
            //  _qualityView.fieldCode 请求码
            //  _qualityView.isUp 是否升序
        };
        
    } else {
        NSArray<FilterFieldModel *> *filterFields = [TypeManager sharedAPI].proFilterFields;
        if (filterFields != 0) {
            if (_myFilterView == nil) {
                for (FilterFieldModel *model in filterFields){
                    if ([model.filterType isEqualToString:@"area"]){
                        _filterViewInitialHeight += [ZSFilterSegmentView getHeight];
                    }else if ([model.filterType isEqualToString:@"enum"]){
                        NSArray *arr = [model.enumItems componentsSeparatedByString:@","];
                        _filterViewInitialHeight += [ZSFilterMultiChooseView getTagViewHeight:arr withWidth:SCREEN_WIDTH*0.7];
                    }
                }
                
                _myFilterView = [[ZSFilterView alloc] initWithContentHeight:_filterViewInitialHeight andData:filterFields];
                _myFilterView.theDelegate = self;
            }
            
            KLCPopup * popView = [KLCPopup popupWithContentView:_myFilterView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
//            [popView showAtCenter:CGPointMake(SCREEN_WIDTH-(SCREEN_WIDTH*0.7)/2,SCREEN_HEIGHT/2-15) inView:self.view];
            
            CGFloat centerY = (_filterViewInitialHeight+64+40)/2;
            if (_filterViewInitialHeight+40 > SCREEN_HEIGHT-35-64) {
                centerY = SCREEN_HEIGHT/2-15;
            }
            [popView showAtCenter:CGPointMake(SCREEN_WIDTH-(SCREEN_WIDTH*0.7)/2,centerY) inView:self.view];
            popView.didFinishDismissingCompletion = ^{
                if ([_filterItem isEqualToString:_myFilterView.filterItems] && [_filterValue isEqualToString:_myFilterView.filterValues]) {
                    
                }else{
                    _filterItem = _myFilterView.filterItems;
                    _filterValue = _myFilterView.filterValues;
                    
                    [self fetchDataWith:_searchKey];
                }
            };
        }
    }

}


#pragma mark  ---初始化属性---
-(void)initials{
  
    _imageItems = @[ [UIImage imageNamed:@"arrow_gray"], [UIImage imageNamed:@"filter_unselect"]].mutableCopy;
    _imageSelectedItems = @[ [UIImage imageNamed:@"arrow_gray"], [ThemeInsteadTool imageWithImageName:@"filter_selected"]].mutableCopy;
    
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
    __weak TrainingSeminarViewController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchDataWith:weakSelf.searchKey];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark---请求数据
- (void)fetchDataWith:(NSString*)searchKey
{
    kPageNum = 1;
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"sortBy":searchKey, @"order":_order, @"userId":gUserID, @"filterItem":_filterItem, @"filterValue":_filterValue,@"tenantId":_tenantId};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestSpecialListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        if(model.isSuccess){
            [self showHint:model.message];
             _curPage = model.curPage;
             _totalPage = model.totalPages;
            [self.dataArr addObjectsFromArray:model.pageData];
            if (model.curPage < model.totalPages) {
                [self.tableView setShowsInfiniteScrolling:YES];
            }
            else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
        } else{
            [self showHint:model.message];
            [self.tableView setShowsInfiniteScrolling:NO];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
}

#pragma mark--- 上拉加载更多
- (void)fetchMoreData
{
    
     NSInteger page = _curPage+1;
    if(page>_totalPage){
        [self.tableView.infiniteScrollingView stopAnimating];
        return [self  showHint:@"已经是最后一页了"];
    }
    [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)page];
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"sortBy":_searchKey, @"order":_order, @"userId":gUserID, @"filterItem":_filterItem, @"filterValue":_filterValue,@"tenantId":_tenantId};
    
    [self.request requestSpecialListWith:dic withBlock:^(ZSLearnCircleModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
            _curPage = model.curPage;
            [self.dataArr addObjectsFromArray:model.pageData];
            [self.tableView reloadData];
        } else{
            [self showHint:model.message];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


#pragma mark ---- setup tableView
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tableViewHeight, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0-_tableViewHeight-_tableViewBottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 100;
        self.tableView.emptyDataSetDelegate = self;
        self.tableView.emptyDataSetSource = self;
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _tableView;
}

#pragma mark --- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"SpecailListCellIdentity";
   SpecailListCell* cell = (SpecailListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecailListCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZSLearnCircleListModel *model = _dataArr[indexPath.row];
    
    if (model.joined) {
        PersonalDetailsViewController *vc = [PersonalDetailsViewController new];
        vc.projectId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SpecialDetailViewController *vc = [SpecialDetailViewController new];
        vc.projectId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)sureDataInFileterView:(ZSFilterView *)filterView{
    [_myFilterView dismissPresentingPopup];

    
    [_imageItems replaceObjectAtIndex:1 withObject:[ThemeInsteadTool imageWithImageName:@"filter_selected"]];
    _iSegment.selectedIndex = 1;
    [_iSegment reloadData];
}


-(void)clickSureInFilterView:(FilterView *)filterView{
    
}
-(void)clickSortViewIndex:(NSInteger)index{
    _iSegment.selectedIndex = 0;
    [_sortView dismissPresentingPopup];
    IntelligentOrderModel * model = [TypeManager sharedAPI].proIntelligentOrder[index];
//    [_clickItems replaceObjectAtIndex:1 withObject:model.fieldName];
//    [_iSegment changeTitles:_clickItems];
    if (_sortView.bSortUp == YES) {
        _order = @"desc";
        UIImage *image = [UIImage image:[ThemeInsteadTool imageWithImageName:@"arrow_up"] rotation:UIImageOrientationDown];
        [_imageItems replaceObjectAtIndex:0 withObject:image ];
    }else{
        _order = @"asc";
        [_imageItems replaceObjectAtIndex:0 withObject:[ThemeInsteadTool imageWithImageName:@"arrow_up"]];
    }
    
    
    if(model.fieldName.length == 0){
                                // arr = @[@"排序",@"筛选"];
    }
    else{
        self.titleArr = @[model.fieldName,@"筛选"];
    }
       

//    [_headerView changeSelectedImages:_imageItems];
    [_iSegment changeTitles:self.titleArr];
    [_iSegment changeSelectedImages:_imageItems];
    _searchKey = model.fieldCode;
    [self fetchDataWith:model.fieldCode];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)searchBtnClick{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchSpecial;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
