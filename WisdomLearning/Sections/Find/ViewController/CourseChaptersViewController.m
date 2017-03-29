//
//  CourseChaptersViewController.m
//  WisdomLearning
//
//  Created by Shane on 17/1/4.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "CourseChaptersViewController.h"
#import "ChaptersListCell.h"
#import "CourseStudyViewController.h"

extern const CGFloat playerViewHeight;
extern const CGFloat commentViewHeight;

@interface CourseChaptersViewController ()<UITableViewDelegate, UITableViewDataSource>




@end

@implementation CourseChaptersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.theTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     _courseStduyCotroller.bShowCommentView = YES;
}

-(UITableView *)theTableView{
    if (!_theTableView ) {
        _theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-playerViewHeight-commentViewHeight-40-64) style:UITableViewStylePlain];
        _theTableView.dataSource = self;
        _theTableView.delegate = self;
        _theTableView.bounces = YES;
        _theTableView.scrollEnabled = NO;
        _theTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_theTableView registerNib:[UINib nibWithNibName:@"ChaptersListCell" bundle:nil] forCellReuseIdentifier:@"ChaptersListCell"];
    }
    return _theTableView ;
}

-(void)setChapters:(NSMutableArray<ZSChaptersInfo *> *)chapters{
    _chapters = chapters;
    [_theTableView reloadData];
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
//    CGFloat yyy = scrollView.contentOffset.y;
//    if (yyy == 0) {
////        _theTableView.scrollEnabled = NO;
//    }
//    
////    else{
////        _theTableView.scrollEnabled = YES;
////    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    CGFloat yyy = scrollView.contentOffset.y;
    if (yyy == 0) {
        _theTableView.scrollEnabled = YES;
    }

}

#pragma mark --UITableview Datasource && UITableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _chapters.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChaptersListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChaptersListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.charpterInfo = _chapters[indexPath.row];
    if ([_chapters[indexPath.row].chapterId isEqualToString:_choseChapterId]) {
        cell.isChoose = YES;
    }else{
        cell.isChoose = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSChaptersInfo *chapter = _chapters[indexPath.row];
    _choseChapterId = chapter.chapterId ;
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickTheIndex:)]) {
        [_theDelegate clickTheIndex:indexPath.row];
    }
//    [UIView animateWithDuration:0.1 animations:^{
//        self.theTableView.contentOffset = CGPointMake(0, 0);
//    }];
    [tableView reloadData];
}

-(void)setBBounce:(BOOL)bBounce{
    _bBounce = bBounce;
    _theTableView.scrollEnabled = bBounce;
}

@end
