//
//  ZSMultiselectMenuView.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/12/13.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSMultiselectMenuView.h"
#import "ZSCategoryListModel.h"
#import "CustomCollectionViewCell.h"
#import "EqualSpaceFlowLayout.h"

@interface ZSMultiselectMenuView ()<UITableViewDelegate, UITableViewDataSource, EqualSpaceFlowLayoutDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<ZSCategoryInfo *> *itemsArray;
@property(nonatomic, strong) NSMutableArray<ZSCategoryInfo *> *selectItemsArray;
@property(nonatomic, assign) CGRect tableViewFrame;
@property(nonatomic, assign) CGRect scrollViewFrame;
@property(nonatomic, assign) NSInteger leftSelIndex;
@property(nonatomic, strong) UIScrollView *scrollView;
@end


@implementation ZSMultiselectMenuView

-(instancetype)initWithFrame:(CGRect)frame andItemsArray:(NSArray *)itemsArray selectItemsArray:(NSArray *)selectItemsArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _itemsArray = itemsArray;
        [self.selectItemsArray addObjectsFromArray:selectItemsArray];;
        UIButton *sender = [[UIButton alloc]initWithFrame:CGRectMake(10.0, 3, 40.0, 24.0)];
        [sender setTitle:@"确定" forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        sender.layer.borderColor = [Tool getMainColor].CGColor;
        sender.layer.borderWidth = 1.0;
        [sender setTitleColor:[Tool getMainColor] forState:UIControlStateNormal];
        [sender addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sender];
        
        _leftSelIndex = 0;
        
        _tableViewFrame = CGRectMake(0, 30, CGRectGetWidth(frame)*0.3, CGRectGetHeight(frame) - 30.0);
        _scrollViewFrame = CGRectMake(CGRectGetMaxX(_tableViewFrame)+10, 30.0, CGRectGetWidth(frame)*0.7-10, CGRectGetHeight(frame) - 30.0);
        [self addSubview:self.tableView];
        [self addSubview:self.scrollView];
    }
    return self;
}
-(NSMutableArray *)selectItemsArray
{
    if (!_selectItemsArray) {
        _selectItemsArray = [NSMutableArray array];
    }
    return _selectItemsArray;
}

-(void)sure
{
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickMenuItemInSelectItemArray:)]) {
        [_theDelegate clickMenuItemInSelectItemArray:self.selectItemsArray];
    }
//    if (_itemsArray[_leftSelIndex].subs.count < 1)
//    {
//        if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickMenuItemInRow:)]) {
//            [_theDelegate clickMenuItemInRow:_leftSelIndex];
//        }
//    } else {
//        if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickMenuItemInSection:andRow:)]) {
//            [_theDelegate clickMenuItemInSection:_leftSelIndex andRow:_backIndex];
//        }
//    }
}


#pragma mark -- create tableview && collectionview
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_tableViewFrame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _tableView;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:_scrollViewFrame];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(_scrollViewFrame.size.width * _itemsArray.count, _scrollViewFrame.size.height);
        for (NSInteger i = 0; i < _itemsArray.count; i ++) {
            EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
            flowLayout.delegate = self;
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0 + _scrollViewFrame.size.width * i, 0, _scrollViewFrame.size.width, _scrollViewFrame.size.height) collectionViewLayout:flowLayout];
    
            _collectionView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
            _collectionView.tag = i + 1;
            [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            [_scrollView addSubview:_collectionView];
        }
        
    }
    return _scrollView;
}

#pragma mark -- UITableView delegate  && UITableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_itemsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (NSInteger i = 0; i < self.selectItemsArray.count; i ++ ) {
        ZSCategoryInfo *info = self.selectItemsArray[i];
        if ([info.id isEqualToString:_itemsArray[indexPath.row].id]) {
            if (info.subs.count > 0) {
                cell.textLabel.textColor = KMainTextBlack;
            } else {
                cell.textLabel.textColor = [Tool getMainColor];
            }
        }
    }
    cell.textLabel.text = _itemsArray[indexPath.row].name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _leftSelIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ZSCategoryInfo *info = _itemsArray[indexPath.row];
    if ([cell.textLabel.textColor isEqual:[Tool getMainColor]]) {
        cell.textLabel.textColor = KMainTextBlack;
        for (NSInteger i = 0; i < self.selectItemsArray.count; i ++) {
            ZSCategoryInfo *seInfo = self.selectItemsArray[i];
            if ([seInfo.id isEqualToString:info.id]) {
                [self.selectItemsArray removeObject:seInfo];
                break;
            }
        }
    } else {
        if (_itemsArray[indexPath.row].subs.count > 0) {
            cell.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
            cell.textLabel.textColor = KMainTextBlack;
        } else {
            cell.textLabel.textColor = [Tool getMainColor];
            [self.selectItemsArray addObject:info];
        }
    }
    for (NSInteger i = 0; i < _itemsArray.count; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        if (![path isEqual:indexPath]) {
            UITableViewCell *otherCell = [tableView cellForRowAtIndexPath:path];
            otherCell.backgroundColor = [UIColor whiteColor];
        }
    }
//    NSLog(@"______%ld",self.selectItemsArray.count)
    _scrollView.contentOffset = CGPointMake(indexPath.row * _scrollViewFrame.size.width, 0);
}

#pragma mark --UICollectionViewDelegate && UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemsArray[collectionView.tag - 1].subs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *moreCellIdentifier = @"CellIdentifier";
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreCellIdentifier forIndexPath:indexPath];
    ZSCategoryInfo *info = _itemsArray[collectionView.tag - 1].subs[indexPath.item];
    cell.content = info.name;

    ZSCategoryInfo *itemInfo = _itemsArray[collectionView.tag - 1];
    for (ZSCategoryInfo * zsInfo in self.selectItemsArray) {
        if ([zsInfo.id isEqualToString:itemInfo.id]) {
            for (ZSCategoryInfo *seInfo in zsInfo.subs) {
                if ([info.id isEqualToString:seInfo.id]) {
                    cell.label.textColor = [Tool getMainColor];
                }
            }
        }
    }
    [cell setNeedsLayout];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = _itemsArray[collectionView.tag - 1].subs[indexPath.item].name;
    
    CGSize size=[text boundingRectWithSize:CGSizeMake(LONG_MAX, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    
    return CGSizeMake(size.width+10, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0.0, 10.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == _leftSelIndex + 1) {
        CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        ZSCategoryInfo *info = _itemsArray[_leftSelIndex].subs[indexPath.item];
        ZSCategoryInfo *superInfo = _itemsArray[_leftSelIndex];
        if ([cell.label.textColor isEqual:[Tool getMainColor]]) {
            cell.label.textColor = KMainTextBlack;
            for (NSInteger i = 0; i < self.selectItemsArray.count; i ++) {
                ZSCategoryInfo *curInfo = self.selectItemsArray[i];
                if ([superInfo.id isEqualToString:curInfo.id]) {
                    for (NSInteger j = 0; j < curInfo.subs.count; j ++) {
                        ZSCategoryInfo *sInfo = curInfo.subs[j];
                        if ([sInfo.id isEqualToString:info.id]) {
                            if (curInfo.subs.count > 1) {
                                [curInfo.subs removeObject:sInfo];
                                break;
                            } else {
                                if (j == curInfo.subs.count - 1) {
                                    [self.selectItemsArray removeObject:curInfo];
                                }
                            }
                            break;
                        }
                    }
                }
            }
        } else {
            cell.label.textColor = [Tool getMainColor];
            if (self.selectItemsArray.count > 0) {
                for (NSInteger i = 0; i < self.selectItemsArray.count; i ++) {
                    ZSCategoryInfo *bInfo = self.selectItemsArray[i];
                    if ([superInfo.id isEqualToString:bInfo.id]) {
                        [bInfo.subs addObject:info];
                        break;
                    } else {
                        if (i == self.selectItemsArray.count - 1) {
                            ZSCategoryInfo * cInfo = [ZSCategoryInfo new];
                            cInfo.id = superInfo.id;
                            cInfo.childCount = superInfo.childCount;
                            cInfo.busCount = superInfo.busCount;
                            cInfo.name = superInfo.name;
                            cInfo.subs = [NSMutableArray arrayWithObject:info];
                            [self.selectItemsArray addObject:cInfo];
                            break;
                        }
                    }
                }
            } else {
                ZSCategoryInfo * cInfo = [ZSCategoryInfo new];
                cInfo.id = superInfo.id;
                cInfo.childCount = superInfo.childCount;
                cInfo.busCount = superInfo.busCount;
                cInfo.name = superInfo.name;
                cInfo.subs = [NSMutableArray arrayWithObject:info];
                [self.selectItemsArray addObject:cInfo];
            }
        }
    }
//    NSLog(@"%ld______%ld",self.selectItemsArray.count,[self.selectItemsArray lastObject].subs.count)
}


@end
