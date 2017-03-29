//
//  ChooseCourseController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/11.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ChooseCourseController.h"
#import "ITTSegement.h"
#import "ZSIntelligentSegment.h"
#import "ChooseCourseCell.h"
#import "ButtonWithIcon.h"
#import "SeeMoreView.h"
#import "SearchViewController.h"
#import "ZSMultiselectMenuView.h"
#import "QualityView.h"
#import "CourseStudyViewController.h"

#import <YYKit/YYKit.h>
#import "ZSRequest+Categories.h"
#import "ZSCategoryListModel.h"
#import "ZSLearnCircleModel.h"
#import "ZSFilterMultiChooseView.h"
#import "ZSPopUpSortView.h"
#import "UIImage+rotation.h"
#import "ZSFilterView.h"
#import "ZSFilterSegmentView.h"



@interface ChooseCourseController ()<UITableViewDelegate, UITableViewDataSource, SeeMoreViewDelegate, ZSMultiselectMenuViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,ComDelegate, ZSIntelligentSegmentDelegate, ZSPopUpSortViewDelegate, ZSFilterViewDelegate>{
    NSArray<ZSCategoryInfo *> *categories;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SeeMoreView *seeMoreView;
@property (nonatomic, strong) NSMutableArray<ZSCurriculumInfo *> *courses;
@property (nonatomic, assign) BOOL bShowMore;
@property (nonatomic, strong) ZSMultiselectMenuView *dropDownMenu;
@property (nonatomic, strong) KLCPopup *menuPopup;
//@property (nonatomic, strong) ITTSegement *segment;
@property (nonatomic, strong) ZSIntelligentSegment *iSegment;
@property (nonatomic, strong) NSMutableArray *clickItems;
@property (nonatomic, strong) NSMutableArray *imageItems;
@property (nonatomic, strong) NSMutableArray *imageSelectedItems;
@property (nonatomic, copy) NSArray *sortItems;
@property (nonatomic, copy) NSString *sortBy;
@property (nonatomic, copy) NSString *categoryIds;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic,strong) QualityView * qualityView;
@property (nonatomic, strong) ZSPopUpSortView *sortView;
@property (nonatomic,strong) IntelligentOrderModel * model;

@property (nonatomic, strong) ZSFilterView *myFilterView;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, strong) NSMutableArray *selectTags;
@property (nonatomic, strong) NSMutableArray <ZSCategoryInfo *> *selectCategories;
@property (nonatomic, copy) NSString *filterItem;
@property (nonatomic, copy) NSString *filterValue;

@property (nonatomic, assign) CGFloat filterViewInitialHeight;

@end

@implementation ChooseCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _order = @"";
    _filterItem = @"";
    _filterValue = @"";
    _filterViewInitialHeight = 0;
    
    if(_tenantId == nil){
        _tenantId = @"";
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    
    self.selectCategories = [NSMutableArray array];
    ZSCategoryInfo *info = [ZSCategoryInfo new];
    info.id = @"";
    info.name = @"全部课程";
    info.busCount = @"0";
    info.childCount = @"0";
    info.subs = [NSMutableArray arrayWithCapacity:0];
    [self.selectCategories addObject:info];

    
    self.title = [Tool getSelfStudyTitle];
    [self initials];
    [self setupNavItem];
    [self.view addSubview:self.iSegment];
//    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self fetchData];
    [self createRefresh];
    
   // NSLog(@"++ %@", [TypeManager sharedAPI].IntelligentOrder);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark  ---初始化属性---
-(void)initials{
        _clickItems = @[@"课程分类", @"排序", @"筛选"].mutableCopy;
    _imageItems = @[[UIImage imageNamed:@"arrow_gray"], [UIImage imageNamed:@"arrow_gray"], [UIImage imageNamed:@"filter_unselect"]].mutableCopy;
    _imageSelectedItems = @[[UIImage imageNamed:@"arrow_gray"], [UIImage imageNamed:@"arrow_gray"], [ThemeInsteadTool imageWithImageName:@"filter_selected"]].mutableCopy;
        _sortItems = @[@"learnNum", @"commentRate", @"price", @"date"];
        _categoryIds = @"";
        _sortBy = @"";
        _bShowMore = NO;
        categories = [[Config Instance] getCategories];
    
}


#pragma mark ---lazy method---
-(UIView *)seeMoreView{
    if (!_seeMoreView) {
        _seeMoreView = [[SeeMoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _seeMoreView.theDelegate = self;
    }
    return _seeMoreView;
}


-(ZSMultiselectMenuView *)dropDownMenu{
    if (!_dropDownMenu) {
        _dropDownMenu = [[ZSMultiselectMenuView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 110.0) andItemsArray:categories selectItemsArray:self.selectCategories];
//        _dropDownMenu = [[ZSDropDownMenu alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 110.0) andItemsArray:categories];
        _dropDownMenu.theDelegate = self;
    }
    return _dropDownMenu;
}

-(ZSIntelligentSegment *)iSegment{
    if (!_iSegment) {
        _iSegment = [[ZSIntelligentSegment alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35) andTitles:_clickItems andImages:_imageItems andSelectedImages:_imageSelectedItems andTitleFont:[UIFont systemFontOfSize:14]];
        _iSegment.theDelegate = self;
    }
    return _iSegment;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10+35, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"ChooseCourseCell" bundle:nil] forCellReuseIdentifier:@"ChooseCourseCell"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}

-(ZSPopUpSortView *)sortView{
    if (!_sortView) {

        NSMutableArray *titles = @[].mutableCopy;
        [[TypeManager sharedAPI].IntelligentOrder enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            IntelligentOrderModel *model = (IntelligentOrderModel *)obj;
            [titles addObject:model.fieldName];
        }];
        _sortView = [[ZSPopUpSortView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3,135) withTitles:titles];
        _sortView.theDelegate = self;
    }
    return _sortView;
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak ChooseCourseController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

#pragma mark ---右边搜索---
-(void)setupNavItem{
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

#pragma mark ---请求数据---
-(void)fetchData{
    kPageNum = 1;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];

    
        NSDictionary * dic = @{@"curPage":curPage ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"categoryIds":_categoryIds, @"sortBy":_sortBy,@"order":_order, @"userId":gUserID, @"filterItem":_filterItem, @"filterValue":_filterValue,@"tenantId":_tenantId};
    
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestCourseListWithData:dic withBlock:^(ZSCurriculumModel *model, NSError *error) {
        self.showEmptyView = YES;
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            _courses = model.pageData.mutableCopy;
            if (_courses.count == model.totalRecords) {
                _bShowMore = NO;
            }
            if (_courses.count < model.totalRecords) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            [self.tableView reloadData];
        }else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)fetchMoreData
{
    kPageNum++;
//    [self showHudInView:self.view hint:@"加载中..."];
    NSString * str = [NSString stringWithFormat: @"%ld", (long)kPageNum];

    
    NSDictionary * dic = @{@"curPage":str ,@"perPage":[NSString stringWithFormat: @"%ld", (long)kPageSize],@"categoryIds":_categoryIds, @"sortBy":_sortBy,@"order":_order, @"userId":gUserID, @"filterItem":_filterItem, @"filterValue":_filterValue,@"tenantId":_tenantId};
    
    [self.request requestCourseListWithData:dic withBlock:^(ZSCurriculumModel *model, NSError *error){
        if(model.isSuccess){
            [self showHint:model.message];
            [_courses addObjectsFromArray:model.pageData];
            
            if (_courses.count < model.totalRecords) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
            [self.tableView reloadData];
            
        }
        else{
            [self showHint:model.message];
            
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark ---UITableViewDataSource,UITableViewDelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_bShowMore == NO) {
        return _courses.count;
    }
    return (_courses.count == 0) ? 0 : _courses.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _courses.count && _courses.count != 0) {
        static NSString* cellIdentifier = @"cell";
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.seeMoreView.currentIndexPath = indexPath;
        [cell.contentView addSubview:self.seeMoreView];
       
        return cell;
    }else{
        ChooseCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseCourseCell" forIndexPath:indexPath];
        cell.curriculum = _courses[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_courses && indexPath.row == _courses.count){
        return 40.f;
    }else{
        return 130.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row != _courses.count) {
        CourseStudyViewController *destVc = [CourseStudyViewController new];
        destVc.courseId = _courses[indexPath.row].courseId;
        destVc.title = _courses[indexPath.row].courseName;
        [self.navigationController pushViewController:destVc animated:YES];
    }
}

#pragma mark ---ZSDropDownMenu delegate---
-(void)clickMenuItemInSelectItemArray:(NSArray *)selectItemArray
{
    if (selectItemArray.count < 1) {
        [self showHint:@"至少选中一个条件"];
        return;
    }
    [_menuPopup dismiss:YES];
    _dropDownMenu = nil;
    [self.selectCategories removeAllObjects];
    [self.selectCategories addObjectsFromArray:selectItemArray];
    
    ZSCategoryInfo *info = [selectItemArray firstObject];
    NSString *titleStr ;
    if (info.subs.count >= 1) {
        titleStr = [info.subs firstObject].name;
    } else {
        titleStr = info.name;
    }
    [_clickItems replaceObjectAtIndex:0 withObject:titleStr];
    [_iSegment changeTitles:_clickItems];
    
    for (NSInteger i = 0; i < selectItemArray.count; i ++) {
        ZSCategoryInfo *aInfo = selectItemArray[i];
        if (i == 0) {
            if (aInfo.subs.count > 0) {
                for (NSInteger j = 0; j < aInfo.subs.count; j ++) {
                    if (j == 0) {
                        self.categoryIds = aInfo.subs[j].id;
                    } else {
                        self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.subs[j].id];
                    }
                }
            } else {
                self.categoryIds = aInfo.id;
            }
        } else {
            if (aInfo.subs.count > 0) {
                for (NSInteger k = 0; k < aInfo.subs.count; k ++) {
                    self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.subs[k].id];
                }
            } else {
                self.categoryIds = [NSString stringWithFormat:@"%@,%@",self.categoryIds,aInfo.id];
            }
        }
    }
//    _sortBy = @"";
    [self fetchData];
}


#pragma mark --ZSIntelligentSegmentDelegate
-(void)clickTheSegmentIndex:(NSInteger)index{
    if (index == 0) {
        _menuPopup = [KLCPopup popupWithContentView:self.dropDownMenu];
        [_menuPopup showAtCenter:CGPointMake(self.view.width/2, (SCREEN_HEIGHT - 30.0)/2.0) inView:self.view];
    }else if (index == 1){
        
        if ([TypeManager sharedAPI].IntelligentOrder.count != 0) {
            KLCPopup * popView = [KLCPopup popupWithContentView:self.sortView showType:KLCPopupShowTypeGrowIn dismissType:KLCPopupDismissTypeGrowOut maskType:KLCPopupMaskTypeDimmed dismissOnBackgroundTouch:YES dismissOnContentTouch:NO];
            
            [popView showAtCenter:CGPointMake(self.view.centerX, 105) inView:self.view];
            popView.didFinishDismissingCompletion = ^{
                
                //  请求
                //  _qualityView.fieldCode 请求码
                //  _qualityView.isUp 是否升序
            };

        }
        
    }else if (index == 2){
        NSArray<FilterFieldModel *> *filterFields = [TypeManager sharedAPI].filterFields;
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
                    
                    [self fetchData];
                }
            };
        }
    }
}


-(void)sureDataInFileterView:(ZSFilterView *)filterView{
    [_myFilterView dismissPresentingPopup];
   
    _iSegment.selectedIndex = 2;
    [_imageItems replaceObjectAtIndex:2 withObject:[ThemeInsteadTool imageWithImageName:@"filter_selected"]];
    [_iSegment reloadData];

}

-(void)clickTheQualityViewAtIndex:(NSInteger)index{
    [_qualityView dismissPresentingPopup];
    IntelligentOrderModel * model = [TypeManager sharedAPI].IntelligentOrder[index];
    [_clickItems replaceObjectAtIndex:1 withObject:model.fieldName];
    [_iSegment changeTitles:_clickItems];
    _sortBy = model.fieldCode;
    [self fetchData];
}

-(void)clickSortViewIndex:(NSInteger)index{
    _iSegment.selectedIndex = 1;
    [_sortView dismissPresentingPopup];
    IntelligentOrderModel * model = [TypeManager sharedAPI].IntelligentOrder[index];
    [_clickItems replaceObjectAtIndex:1 withObject:model.fieldName];
    [_iSegment changeTitles:_clickItems];
    if (_sortView.bSortUp == YES) {
        _order = @"desc";
        UIImage *image = [UIImage image:[ThemeInsteadTool imageWithImageName:@"arrow_up"] rotation:UIImageOrientationDown];
         [_imageItems replaceObjectAtIndex:1 withObject:image ];
    }else{
        _order = @"asc";
        [_imageItems replaceObjectAtIndex:1 withObject:[ThemeInsteadTool imageWithImageName:@"arrow_up"]];
    }
   
    [_iSegment changeSelectedImages:_imageItems];
    _sortBy = model.fieldCode;
    [self fetchData];
}


#pragma mark ---搜索---
-(void)doSearch:(UIButton *)sender{
    SearchViewController * VC = [[SearchViewController alloc]init];
    VC.type = SearchCourse;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---点击查看全部---
-(void)seeMore:(NSIndexPath *)indexPath{
    _bShowMore = NO;
    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self adds];
    
}


-(void)adds{
//    [_data addObject:@""];
//    [_data addObject:@""];
//    [_data addObject:@""];
//    [_data addObject:@""];
//    [_tableView reloadData];
//    _tableView insertRowsAtIndexPaths:<#(nonnull NSArray<NSIndexPath *> *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
//    [_tableView reloadSections:[ NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark --- 暂无数据
- (UIImage*)imageForEmptyDataSet:(UIScrollView*)scrollView{
    UIImage* img = [ThemeInsteadTool imageWithImageName:@"Dia_NoContent"];
    return img;
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -70.0f;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 30.0f;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView{
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.showEmptyView;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
