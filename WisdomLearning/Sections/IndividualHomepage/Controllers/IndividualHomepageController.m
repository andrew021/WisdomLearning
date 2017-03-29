//
//  IndividualHomepageController.m
//  WisdomLearning
//
//  Created by Shane on 16/10/29.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "IndividualHomepageController.h"
#import "CourseHeaderReusableView.h"
#import "HomepageHeaderView.h"
#import "ZSImagesView.h"
#import "HomepageDynamicTextCell.h"
#import "HomepageDynamicTextImagesCell.h"
#import "ZSHorThreeImagesView.h"
#import "ChatViewController.h"
#import "UIViewController+ModifyPhoto.h"
#import "ZSUploader.h"

extern NSString *userhomeimguploadurl;


static const NSInteger vistorNum = 6;

@interface IndividualHomepageController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZSImagesViewDelegate, HomepageHeaderViewDelegate>{
    CGFloat addButtonHeight;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) HomepageHeaderView *headerView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) ZSIndividualDetail *individualDetail;
@property (nonatomic, copy) NSArray<ZSVistorsInfo *> *vistors;
@property (nonatomic, copy) NSArray<ZSFreshInfo *> *freshList;


@end

@implementation IndividualHomepageController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([_userID isEqualToString:gUserID]) {
        self.navigationItem.title = @"我的主页";
        addButtonHeight = 0;
    }else{
        self.navigationItem.title = [_nickName add:@"的主页"];
        addButtonHeight = 55;
    }
    
    _titleArray = @[@"", @"动态：", @"最近访客："];
    [self.view addSubview:self.collectionView];
    if (![_userID isEqualToString:gUserID]) {
        [self.view addSubview:self.addButton];
    }
    if(_userID == nil){
        _userID = @"";
    }
    NSDictionary *dict = @{@"userId":_userID};
    [self.request requestIndividalDetailtWith:dict withBlock:^(ZSIndividualDetailModel *model, NSError *error) {
        if (model.isSuccess) {
            [self showHint:model.message];
            _individualDetail = model.data;
            _headerView.homeImageUrl = _individualDetail.homeImage;
            _vistors = _individualDetail.visterList;
            _freshList = _individualDetail.freshList;
            [_collectionView reloadData];
        }else{
            [self showHint:model.message];
           
        }
    }];
    
    IMRequest * request = [[IMRequest alloc]init];
    [request requestWhetherShielding:_userID gp_id:@"" block:^(ZSIsFriendOrShieldModel *model, NSError *error) {
        if(model.isSuccess){
            ZSIsFriendModel * zsModel = model.data;
            if(!zsModel.FRIEND_STATUS){
                //不是
                [_addButton setTitle:@"加为好友" forState:UIControlStateNormal];
                _addButton.tag =2;
                
            }
            else{
               
                
                [_addButton setTitle:@"去聊天" forState:UIControlStateNormal];
                _addButton.tag =1;
                
            }
        }
        else{
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- lazy method
//创建collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - addButtonHeight-64) collectionViewLayout:flowLayout];
        flowLayout.minimumLineSpacing = 1.0;
        flowLayout.minimumInteritemSpacing = 1.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(1.0, 0.0, 0.0, 0.0);
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell2"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"HomepageDynamicTextCell" bundle:nil] forCellWithReuseIdentifier:@"HomepageDynamicTextCell"];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"HomepageDynamicTextImagesCell" bundle:nil] forCellWithReuseIdentifier:@"HomepageDynamicTextImagesCell"];
       
        [_collectionView registerClass:[CourseHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];

        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"ReusableFooterView"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f4f4f4"];
    }
    return _collectionView;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.collectionView.frame)+5, SCREEN_WIDTH-20, 40)];
        [_addButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [_addButton setBackgroundColor:kMainThemeColor];
        [_addButton addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.cornerRadius = 4;
    }
    return _addButton;
}

-(HomepageHeaderView *)headerView{
    if (!_headerView) {
        _headerView = (HomepageHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"HomepageHeaderView" owner:nil options:nil] lastObject];
        _headerView.theDelegate = self;
        _headerView.isSelf = [_userID isEqualToString:gUserID];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    }
    return _headerView;
}

//UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 1) {
        return _freshList.count;
    }
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CourseHeaderReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
        reusableView.backgroundColor = [UIColor whiteColor];
        reusableView.titleLabel.text = _titleArray[indexPath.section];
        reusableView.moreBtn.hidden = YES;
        reusableView.moreBtn.enabled = NO;
        return reusableView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ReusableFooterView" forIndexPath:indexPath];
//        reusableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        return reusableView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 0);
    } else {
        return CGSizeMake(SCREEN_WIDTH, 35.0);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 13.0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ){
        return CGSizeMake(SCREEN_WIDTH, 200.0);
    }else if (indexPath.section == 1){
        ZSFreshInfo *info = _freshList[indexPath.row];
//        info.imgStr = @"http://h.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=4cbd7a3bfa1986184112e7827add024b/b812c8fcc3cec3fd03a5582fd488d43f869427d5.jpg,http://pic.meirishentie.com/picture/10048/100484824/medium/100484824.jpg,http://s6.sinaimg.cn/bmiddle/c450f2d7gdd93bbf95f35&690,http://gaoxiao.zhutou.com/html/UploadPic/2010-8/20108417221989.jpg";
        if ([info.imgStr isEqualToString:@""]) {
             return CGSizeMake(SCREEN_WIDTH, 50.0);
        }else{
            NSArray *images = [info.imgStr componentsSeparatedByString:@","];
            float height = [ZSHorThreeImagesView getHorThreeImagesViewHeight:images withWidth:100 withVerticalSpacing:15];
            return CGSizeMake(SCREEN_WIDTH, height+50);
        }
        
    }else if (indexPath.section == 2){
        return CGSizeMake(SCREEN_WIDTH, 80.0);
    }
    return CGSizeZero;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        self.headerView.nickLabel.text = _individualDetail.userNick;
        self.headerView.friendLabel.text = _individualDetail.friendNum;
        self.headerView.descLabel.text = _individualDetail.signDesc;
        [self.headerView.avaterImageView sd_setImageWithURL:[_individualDetail.userAvater stringToUrl] placeholderImage:[UIImage imageNamed:@"default_icon"]];
        
        [cell.contentView addSubview:self.headerView];
        return cell;
    }else if (indexPath.section == 1){
        ZSFreshInfo *info = _freshList[indexPath.row];
//        info.imgStr = @"http://h.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=4cbd7a3bfa1986184112e7827add024b/b812c8fcc3cec3fd03a5582fd488d43f869427d5.jpg,http://pic.meirishentie.com/picture/10048/100484824/medium/100484824.jpg,http://s6.sinaimg.cn/bmiddle/c450f2d7gdd93bbf95f35&690,http://gaoxiao.zhutou.com/html/UploadPic/2010-8/20108417221989.jpg";
        if ([info.imgStr isEqualToString:@""]) {
            HomepageDynamicTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomepageDynamicTextCell" forIndexPath:indexPath];
            cell.info = info;
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }else{
            HomepageDynamicTextImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomepageDynamicTextImagesCell" forIndexPath:indexPath];
             cell.backgroundColor = [UIColor whiteColor];
             cell.info = info;
            
            NSArray *images = [info.imgStr componentsSeparatedByString:@","];
            CGFloat imHeight = [ZSHorThreeImagesView getHorThreeImagesViewHeight:images withWidth:100 withVerticalSpacing:15];

            ZSHorThreeImagesView *imagesView = [[ZSHorThreeImagesView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, imHeight) withPadding:15 withHorizontalSpacing:10 withVerticalSpacing:15];
            imagesView.images = images;
            [cell.contentView addSubview:imagesView];
           
            return cell;
        }
    }else if (indexPath.section == 2){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
        NSMutableArray<NSString *> *images = @[].mutableCopy;
        
        [_vistors enumerateObjectsUsingBlock:^(ZSVistorsInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 7) {
                *stop = YES;
            }
            NSString *iconUrl = [gIconHost add:obj.avater];
            [images addObject:iconUrl];
        }];
        
        
        NSInteger picWidth = (SCREEN_WIDTH-2*10-(vistorNum-1)*10)/vistorNum;
        ZSImagesView *imagesView = [[ZSImagesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80) imageArray:images andPadding:10 andImageWidth:picWidth andImageHeight:picWidth andCorner:YES andFixedGap:10];
        imagesView.delegate = self;
        [cell.contentView addSubview:imagesView];
        return cell;
    }
    
    
    return nil;

}


-(void)clickAdd:(UIButton *)sender{
    //[self showHint:@"土豪，我们做朋友吧!"];
    if(sender.tag==1){
        if([gUsername isEqualToString:@"hy_px_demo"]){
            return [self showHint:@"访客账号不能聊天!"];
        }
        
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:_individualDetail.userId conversationType:EMConversationTypeChat];
        chatController.ID = _individualDetail.userId;       
        chatController.nickName =  _individualDetail.userNick;
        chatController.title =  _individualDetail.userNick;
        [self.navigationController pushViewController:chatController animated:YES];
    }
    else{
        
    if([gUsername isEqualToString:@"hy_px_demo"]){
        return [self showHint:@"访客账号不能加好友!"];
    }
    IMRequest * requset = [[IMRequest alloc]init];
    [self showHudInView:self.view hint:@"发送申请中..."];
    [requset requestDealFriend:_individualDetail.userId status:@"0" block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        if(model.isSuccess){
            [self showHint:model.message];
        }
        else{
            [self showHint:model.message];
        }
    }];
    }

}

-(void)clickImgaeView:(UIButton *)sender{
    NSInteger index = sender.tag;
    IndividualHomepageController * view = [[IndividualHomepageController alloc]init];
    
    view.userID = _vistors[index].id;
    view.nickName = _vistors[index].name;
    [self.navigationController pushViewController:view animated:YES];
}

-(void)clickBackgroundImage{
    [self toChoosePhotoSucessBlock:^(UIImage *imageChoose) {
        NSData * data = UIImageJPEGRepresentation(imageChoose, 1.0);
        [[ZSUploader sharedInstance] uploadImage:data url:userhomeimguploadurl token:gUserID userid:gUserID completeHandler:^(ZSUploaderRespModel *respModel) {
            if (respModel.url !=nil) {
                
            }else {
                [self showHint:respModel.msg];
            }
        }];
        
        _headerView.backgroundIv.image = imageChoose;
    }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
