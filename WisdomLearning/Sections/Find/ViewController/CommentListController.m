//
//  CommentListController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "CommentListController.h"
#import "CommentListHeaderCell.h"
#import "CommentsListCell.h"
#import "NSString+Utilities.h"
#import "IndividualHomepageController.h"
#import "CourseStudyViewController.h"
#import "KeyboardView.h"

extern const CGFloat playerViewHeight;
extern const CGFloat keyboardViewHeight;

@interface CommentListController ()<UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITextFieldDelegate>{

}

@property (nonatomic, strong) UITextField *keyboardView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign)BOOL flag;  //用于键盘出现时函数调用多次的情况
@property (nonatomic,assign)float replyViewDraw;
@property (nonatomic, strong) NSMutableArray<ZSReplyListInfo *> *commentList;
@property (nonatomic, assign) CGPoint tableviewOriginalPoint;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];

//    NSLog(@"_______%f",_offset)
    
    [self.view addSubview:self.tableView];
    
    
//    [self.view addSubview:self.keyboardView];
    
    
    if ([_resourceType isEqualToString:@"course"]) {
        [_courseStduyCotroller.keyboardView addSubview:self.keyboardView];
    } else {
        _bottomView = [UIView new];
        _bottomView.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 55.0);
        if (SCREEN_HEIGHT == 480) {
            _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, self.offset - 75.0 + 25.0);
        } else if (SCREEN_HEIGHT == 568){
            _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, self.offset - 30.0);//5s
        } else if (SCREEN_HEIGHT == 667) {
            _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, self.offset + 71.0);//6
        } else {
            _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, self.offset + 140.0);//6p
        }
        
        [_bottomView setBackgroundColor:[UIColor colorWithRed:247/255.0 green:248/255.0 blue:250/255.0 alpha:1]];
        [self.view addSubview:_bottomView];
        [_bottomView addSubview:self.keyboardView];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offsetCenter:) name:@"SCROLLVIEW" object:nil];
    
    [self fetchData];
    
    [self createRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(immobilization:) name:@"IMMOBILIZATION" object:nil];
    
    if ([_resourceType isEqualToString:@"course"] == NO) {
        Offset *set = [Offset sharedInstance];
        if (set.offset > 432.4) {
            _tableView.scrollEnabled = YES;
        } else {
            _tableView.scrollEnabled = NO;
        }
    }
   
}

- (void)immobilization:(NSNotification *)note
{
    CGFloat offset = [note.userInfo[@"OFFSET"] floatValue];
    if (offset > 432.4) {
        _tableView.scrollEnabled = YES;
    } else {
        _tableView.scrollEnabled = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([_resourceType isEqualToString:@"course"]) {
        _courseStduyCotroller.bShowCommentView = NO;
    }
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    _keyboardView.userInteractionEnabled = YES;
    
}

-(void)offsetCenter:(NSNotification *)note
{
    CGFloat offset = [note.userInfo[@"OFFSET"] floatValue];
    
    if (SCREEN_HEIGHT == 480) {
        _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, offset - 75.0 + 25.0);
    } else if (SCREEN_HEIGHT == 568){
        _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, offset - 30.0);//5s
    } else if (SCREEN_HEIGHT == 667) {
        _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, offset + 71.0);
    } else {
        _bottomView.center = CGPointMake(SCREEN_WIDTH / 2.0, offset + 140.0);
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.keyboardView.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tap:(UITapGestureRecognizer*)sender{
    CGPoint point = [sender locationInView:sender.view];
    NSLog(@"%f", point.x);
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak CommentListController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
    
    [weakSelf.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf fetchMoreData];
    }];
}

-(void)fetchData{
    kPageNum = 1;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];
    if (_objectId == nil) {
        _objectId = @"";
    }
    if (_resourceType == nil) {
        _resourceType = @"";
    }
    NSDictionary *userDict = @{@"objectId":_objectId, @"curPage":curPage, @"perPage":@"10", @"objectType":_resourceType};
    [self.request requestCommentListWithData:userDict withBlock:^(ZSReplyListModel *model, NSError *error) {
        self.showEmptyView = YES;
        if (model.isSuccess) {
            _commentList = model.pageData.mutableCopy;
            if (_commentList.count < model.totalRecords) {
                [self.tableView setShowsInfiniteScrolling:YES];
            } else {
                [self.tableView setShowsInfiniteScrolling:NO];
            }
            
        }else{
            [self showHint:model.message];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        
        
        [self.tableView reloadData];
        
    }];
}

- (void)fetchMoreData
{
    kPageNum++;
    NSString * curPage = [NSString stringWithFormat: @"%ld", (long)kPageNum];
//    [self showHudInView:self.view hint:@"加载中..."];
     NSDictionary *userDict = @{@"objectId":_objectId, @"curPage":curPage, @"perPage":@"10", @"objectType":_resourceType};
    
    [self.request requestCommentListWithData:userDict withBlock:^(ZSReplyListModel *model, NSError *error) {
//        [self hideHud];
        if(model.isSuccess){
            [_commentList addObjectsFromArray:model.pageData];
            if (_commentList.count < model.totalRecords) {
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
#pragma mark -- lazy method
-(UITableView *)tableView{
    if (!_tableView) {
        if ([_resourceType isEqualToString:@"course"]) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-playerViewHeight-keyboardViewHeight-40-64) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50-64-_tableViewHeight) style:UITableViewStylePlain];
        }
        

        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        if ([_resourceType isEqualToString:@"course"]) {
            _tableView.scrollEnabled = NO;
        }
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"CommentListHeaderCell" bundle:nil] forCellReuseIdentifier:@"CommentListHeaderCell"];
    }
    return _tableView;
}

-(UITextField *)keyboardView{
    if (!_keyboardView) {
        _keyboardView = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, SCREEN_WIDTH-10, 30)];
        _keyboardView.returnKeyType = UIReturnKeySend;
        _keyboardView.backgroundColor = [UIColor whiteColor];
        _keyboardView.placeholder = @"评论";
        _keyboardView.delegate = self;
        
    }
    return _keyboardView;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [Tool hideKeyBoard];
    NSString *text = textField.text;
    if (text.length == 0) {
        [self showHint:@"评论内容不能为空"];
    }else{
        if (gUserID.length == 0) {
            [self directLoginWithSucessBlock:^{

            }];
        }else{
            NSDictionary *dict = @{@"objectId":_objectId, @"objectType":_resourceType, @"content":[text base64Encode], @"score":@"100", @"userId":gUserID};
            [self.request toCommentWith:dict withBlock:^(ZSModel *model, NSError *error) {
                if (model.isSuccess) {
                    [self showHint:model.message];
                    textField.text = @"";
                    [self fetchData];
                }else{
                    [self showHint:model.message];
                }
            }];

        }
        
    }
    return YES;
}

// tableview delegate && tableview datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *content = [_commentList[indexPath.section].content base64Decode];
        CGSize size=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70.0, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]} context:nil].size;
        
        return 60 + size.height;
    }else{
        ZSReplyInfo *reply = _commentList[indexPath.section].replyList[indexPath.row-1];
        NSString *content =  [NSString stringWithFormat:@"%@回复%@：%@", reply.replyerName, reply.userName, reply.content];
        CGSize size=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 70.0, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil].size;
        
        return size.height+10;
      
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _commentList.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentList[section].replyList.count+1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CommentListHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentListHeaderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.replyInfo = _commentList[indexPath.section];
        return cell;
    }else{
        static NSString* iden = @"CommentsListCell";
        CommentsListCell* cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[CommentsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
        ZSReplyInfo *reply = _commentList[indexPath.section].replyList[indexPath.row-1];
        cell.summaryText =  [NSString stringWithFormat:@"%@回复%@：%@", reply.replyerName, reply.userName, reply.content];
        cell.replyModel = reply;
        
        cell.summaryLabel.delegate = self;
        cell.userInteractionEnabled = YES;
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    self.replyViewDraw = [cell convertRect:cell.bounds toView:self.view.window].origin.y + cell.frame.size.height;
//    
//    if (indexPath.row == 0) {
//        ZSReplyListInfo *reply = _commentList[indexPath.section];
//        [self toReply:reply.userName];
//    }else{
//        ZSReplyInfo *reply = _commentList[indexPath.section].replyList[indexPath.row-1];
//        [self toReply:reply.replyerName];
//    }
}


-(void)toReply:(NSString *)who{
    BOOL isFirstResponder = [_keyboardView.inputView isFirstResponder];
    if (!isFirstResponder) {
        self.flag = YES;
        _bDirectComment = NO;
        [_keyboardView becomeFirstResponder];
//        NSString *sss = [NSString stringWithFormat:@"回复%@:", who];
//        [_keyboardView setInputViewPlaceholderText:sss];
    }else{
//        [self setKeyboardViewToComment];
    }

}

-(void)keyboardWillShow:(NSNotification *) notify
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCROLLVIEWTOP" object:nil userInfo:nil];
//    NSDictionary *dic = notify.userInfo;
//    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    if (keyboardRect.size.height >250 && self.flag) {
//        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
//            
////            CGRect frame = _keyboardView.frame;
////            if ([_resourceType isEqualToString:@"course"]) {
////                frame.origin.y = frame.origin.y + 60;
////            }else{
////                frame.origin.y = frame.origin.y + 60 + 80;
////            }
////            
////            
////            CGPoint point = self.tableView.contentOffset;
////            
////            point.y -= (frame.origin.y - self.replyViewDraw);
////            if (point.y < 0) {
////                point.y = 0;
////            }
////            self.tableView.contentOffset = point;
//            _bottomView.center = CGPointMake(SCREEN_WIDTH/2.0, keyboardRect.size.height + 25.0);
//        }];
//        self.flag = NO;
//    }
}


-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url{

}

-(void)setBBounce:(BOOL)bBounce{
    _bBounce = bBounce;
    self.tableView.scrollEnabled = bBounce;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_resourceType isEqualToString:@"course"] == YES) {
        NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
        CGFloat yyy = scrollView.contentOffset.y;
        if (yyy == 0) {
            _tableView.scrollEnabled = YES;
        }
    }
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
    if ([_resourceType isEqualToString:@"course"]) {
        return -10;
    }
    return -40.0f;
}
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    if ([_resourceType isEqualToString:@"course"]) {
        return 10;
    }
    return 30.0f;
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView*)scrollView{
    return YES;
}
-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.showEmptyView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView.contentOffset.y < 0.1) {
        _tableView.scrollEnabled = NO;
    } else {
        _tableView.scrollEnabled = YES;
    }
}

@end
