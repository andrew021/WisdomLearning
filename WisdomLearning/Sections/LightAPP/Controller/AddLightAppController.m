//
//  AddLightAppController.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AddLightAppController.h"
#import "LightAppAddCell.h"

@interface AddLightAppController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic,strong)UITableView * tableView;
@property (strong,nonatomic) NSMutableArray * showGridTitleArray; // 标题
@property (strong,nonatomic) NSMutableArray * showImageGridArray; // 图片
@property (strong,nonatomic) NSMutableArray * showGridIDArray;//ID
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL showEmptyView;
@property (nonatomic,strong) LightAppModel * model;

@end

@implementation AddLightAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加轻应用";
    
    
    [self setTableView];
    _dataArr = [[NSMutableArray alloc]init];
    [self createRefresh];
    [self fetchData];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
}

#pragma mark---创建刷新和加载更多
- (void)createRefresh
{
    __weak AddLightAppController* weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf fetchData];
    }];
 
}

#pragma mark---请求数据
- (void)fetchData
{
    NSDictionary * dic = @{@"userId":gUserID};
    [self showHudInView:self.view hint:@"加载中..."];
    [self.request requestAllLightAppListWithDic:dic block:^(ZSLightAppModel *model, NSError *error) {
        [self hideHud];
        self.showEmptyView = YES;
        [self.dataArr removeAllObjects];
        [self showHint:model.message];
        if(model.isSuccess){
            [self.dataArr addObjectsFromArray:model.pageData];
        }
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView reloadData];
    }];
   

    
}

-(void)setTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 ) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 60;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
   // _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
      [_tableView registerNib:[UINib nibWithNibName:@"LightAppAddCell" bundle:nil] forCellReuseIdentifier:@"lightAppAddCell"];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    

    LightAppAddCell *cell =[tableView dequeueReusableCellWithIdentifier:@"lightAppAddCell" forIndexPath:indexPath];
    [cell.addBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.addBtn.tag = indexPath.row;

    cell.model = _dataArr[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)clickBtn:(UIButton*)btn
{

    
    _model = _dataArr[btn.tag];
    NSString * str = nil;
    if(gUserID.length == 0){
        str = @"0";
    }
    else{
        str = gUserID;
    }
    [self showHudInView:self.view hint:@"正在添加..."];
    NSDictionary * dic = @{@"userId":gUserID,@"appId":_model.Id,@"type":@"1"};
    
    [self.request requestAddOrReduceLightAppWithDic:dic block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if(model.isSuccess){
            [btn setBackgroundImage:[UIImage imageNamed:@"app_added"] forState:UIControlStateNormal];
                btn.enabled = NO;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"getLightAppData" object:self];
            if(_delegate){
                [self.delegate fetchDataGetLightApp];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
