//
//  MyCertificateViewController.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/10/18.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "MyCertificateViewController.h"
#import "CertificateDetailViewController.h"
#import "HeaderCerView.h"


@interface MyCertificateViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) long num;
@property (nonatomic, assign) BOOL isRight;
@end

@implementation MyCertificateViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRight = YES;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"我的证书";
    
    [self getData];
}

#pragma mark ---- 获取数据
- (void)getData
{
    [self showHudInView:self.view hint:@"加载中..."];
    NSDictionary *dic = @{
                          @"curPage":@"1",
                          @"perPage":@"20",
                          @"userId":gUserID,
                          };
    [self.request requestMyCertificateListWithDic:dic block:^(MyCertificateListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self showHint:model.message];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            if (model.totalRecords > 20) {
                self.num = model.totalRecords;
                [self loadData];
            } else {
                if (self.dataArray.count == 1) {
                    [_timer invalidate];
                    _timer = nil;
                }
                [self.scrollView removeFromSuperview];
                [self.pageControl removeFromSuperview];
                [self.view addSubview:self.scrollView];
                [self.view addSubview:self.pageControl];
                if (self.dataArray.count < 1) {
                    UILabel *label = [UILabel new];
                    label.center = CGPointMake(self.view.centerX, self.view.centerY - 64.0);
                    label.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 20);
                    label.textAlignment = NSTextAlignmentCenter;
                    label.textColor = KMainTextGray;
                    label.text = @"没有获得任何证书";
                    [self.view addSubview:label];
                }
            }
        } else {
            [self showHint:model.message];
        }
    }];
}

- (void)loadData
{
    NSDictionary *dic = @{
                          @"curPage":@"1",
                          @"perPage":[NSString stringWithFormat:@"%ld",self.num],
                          @"userId":gUserID,
                          };
    [self.request requestMyCertificateListWithDic:dic block:^(MyCertificateListModel *model, NSError *error) {
        [self hideHud];
        if (model.isSuccess) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:model.pageData];
            
            [self.scrollView removeFromSuperview];
            [self.pageControl removeFromSuperview];
            [self.view addSubview:self.scrollView];
            [self.view addSubview:self.pageControl];
        }
    }];
}


//设置滚动视图
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20.0, SCREEN_WIDTH, 380.0)];
        _scrollView.delegate = self;//设置代理
        
        for (int i = 0; i < self.dataArray.count; i ++) {
            HeaderCerView *view =  (HeaderCerView *)[[[NSBundle mainBundle]loadNibNamed:@"HeaderCerView" owner:self options:nil]lastObject];
            view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 380.0);
            view.backgroundColor = [UIColor clearColor];
            view.tag = i;
            
            MyCertificateList *list = self.dataArray[i];
            view.titleLabel.text = list.certificateName;
            [view.avaterUrl sd_setImageWithURL:[list.myAvater stringToUrl] placeholderImage:KPlaceHeaderImage];
            view.nameLabel.text = list.myName;
            view.codeLabel.text = [NSString stringWithFormat:@"NO.%@",list.certNo];
            view.contentLabel.text = list.getCertDesc;
            
            [_scrollView addSubview:view];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView:)];
            [view addGestureRecognizer:tap];
            
        }
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.dataArray.count, 280.0);//设置内容大小
        _scrollView.contentOffset = CGPointMake(0, 0);//设置内容偏移量
        _scrollView.pagingEnabled = YES;//打开整屏滑动
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(void)clickView:(UITapGestureRecognizer *)tap
{
    CertificateDetailViewController *vc = [CertificateDetailViewController new];
    MyCertificateList *list = self.dataArray[tap.view.tag];
    vc.cerId = list.certificateId;
    [self.navigationController pushViewController:vc animated:YES];
}
//设置pageControl
-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:(CGRectMake(0, ViewMaxY(self.scrollView) + 20.0, SCREEN_WIDTH,20.0))];
        _pageControl.numberOfPages = self.dataArray.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = KMainGray;
        _pageControl.currentPageIndicatorTintColor = kMainThemeColor;
        [_pageControl addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _pageControl;
}

#pragma mark -滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;
    if (x == (self.dataArray.count - 1) * SCREEN_WIDTH) {//最后一张图 再次滑动 重置 把偏移量置为（0，0）
        self.isRight = NO;
    }
    if (x == 0) {//当为第一张图时 再滑动把偏移量置为最后一张图
        self.isRight = YES;
    }
}
// 滚动动画结束的时候更改pageControl
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;//获取当前的偏移量
    NSInteger page = x / SCREEN_WIDTH;//对应的pageControl值
    //如果page小于0 说明是衔接图 pageControl下标为最后
    if (page < 0) {
        _pageControl.currentPage = self.dataArray.count;
    }else {
        _pageControl.currentPage = page;
    }
}
//滚动视图后更改对应pageControl 的点
//滚动视图代理方法 拖拽，将要停止，已经停止，方法是针对用户操作的拖拽动作的，如果只是更改了偏移量，并不会执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat x = scrollView.contentOffset.x;//获取当前的偏移量
    NSInteger page = x / SCREEN_WIDTH;//对应的pageControl值
    //如果page小于0 ，说明是衔接图，pageControl下标为最后
    if (page < 0) {
        _pageControl.currentPage = self.dataArray.count;
    }else {
        _pageControl.currentPage = page;
    }
}

#pragma mark  pageControl 触发方法
- (void)valueChanged:(UIPageControl *)pageControl {
    NSInteger page = pageControl.currentPage;
    CGFloat x = (page + 1) * SCREEN_WIDTH;
    [self.scrollView setContentOffset:(CGPointMake(x, 0)) animated:YES];
}

#pragma mark --定时器自动轮播方法----
- (void)autoPlay {
    //更改scrollView   countOffSet
    //如果偏移量>=contentSize.width 要先把偏移量置为（0， 0） 再加上一个width
    CGFloat x = _scrollView.contentOffset.x;//获取偏移量
    
    if (self.isRight) {
        [_scrollView setContentOffset:(CGPointMake(x + SCREEN_WIDTH, 0)) animated:YES];
    } else {
        [_scrollView setContentOffset:(CGPointMake(x - SCREEN_WIDTH, 0)) animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //定时轮播
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

@end
