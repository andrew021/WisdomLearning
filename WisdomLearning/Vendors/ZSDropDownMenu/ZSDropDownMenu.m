//
//  ZSDropDownMenu.m
//  WisdomLearning
//
//  Created by Shane on 16/10/28.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSDropDownMenu.h"
#import "ZSCategoryListModel.h"
#import "CustomCollectionViewCell.h"
#import "EqualSpaceFlowLayout.h"

@interface ZSDropDownMenu() <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, EqualSpaceFlowLayoutDelegate>{
}

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, copy) NSArray<ZSCategoryInfo *> *itemsArray;
@property(nonatomic, assign) CGRect collectionViewFrame;
@property(nonatomic, assign) CGRect tableViewFrame;
@property(nonatomic, assign) NSInteger leftSelIndex;
@property(nonatomic, strong) NSIndexPath *curTableViewIndexPath;
@property(nonatomic, strong) NSIndexPath *curCollectionViewIndexPath;

@end

@implementation ZSDropDownMenu

-(instancetype)initWithFrame:(CGRect)frame andItemsArray:(NSArray *)itemsArray{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _itemsArray = itemsArray;
        _tableViewFrame = CGRectMake(0, 0, CGRectGetWidth(frame)*0.3, CGRectGetHeight(frame));
        _collectionViewFrame = CGRectMake(CGRectGetMaxX(_tableViewFrame)+10, 0, CGRectGetWidth(frame)*0.7-10, CGRectGetHeight(frame));
        
        [self addSubview:self.tableView];
        
        [self.tableView reloadData];
        [_tableView selectRowAtIndexPath:_curTableViewIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];


    }
    return self;
}


#pragma mark -- create tableview && collectionview
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:_tableViewFrame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _curTableViewIndexPath = nil;
    }
    
    return _tableView;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
        flowLayout.delegate = self;

        _collectionView = [[UICollectionView alloc] initWithFrame:_collectionViewFrame collectionViewLayout:flowLayout];
        
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _curCollectionViewIndexPath = nil;
    }
   
    return _collectionView;
}

#pragma mark -- UITableView delegate  && UITableView datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_itemsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    
    cell.textLabel.text = _itemsArray[indexPath.row].name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (_curTableViewIndexPath == indexPath) {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1c8be2"];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_curTableViewIndexPath == indexPath) {
        return ;
    }
    _leftSelIndex = indexPath.row;
    
    if (_itemsArray[_leftSelIndex].subs.count < 1) {
        if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickMenuItemInRow:)]) {
            [_theDelegate clickMenuItemInRow:_leftSelIndex];
        }
    } else {
        _leftSelIndex = indexPath.row;
        [_collectionView removeFromSuperview];
        _collectionView = nil;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"1c8be2"];
        cell = [tableView cellForRowAtIndexPath:_curTableViewIndexPath];
        cell.textLabel.textColor = [UIColor blackColor];
        _curTableViewIndexPath = indexPath;
        
        [self addSubview:self.collectionView];
    }
}

#pragma mark --UICollectionViewDelegate && UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itemsArray[_leftSelIndex].subs.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *moreCellIdentifier = @"CellIdentifier";
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreCellIdentifier forIndexPath:indexPath];
    
    cell.content = _itemsArray[_leftSelIndex].subs[indexPath.row].name;
    [cell setNeedsLayout];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = _itemsArray[_leftSelIndex].subs[indexPath.row].name;
    
    CGSize size=[text boundingRectWithSize:CGSizeMake(LONG_MAX, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
    
    return CGSizeMake(size.width+10, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0.0, 10.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld____%ld",indexPath.section,indexPath.item);
    if (_curCollectionViewIndexPath == indexPath) {
        return ;
    }
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.label.textColor = [UIColor colorWithHexString:@"1c8be2"];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:_curCollectionViewIndexPath];
    cell.label.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    
    _curCollectionViewIndexPath = indexPath;
    
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickMenuItemInSection:andRow:)]) {
        [_theDelegate clickMenuItemInSection:_leftSelIndex andRow:indexPath.row];
    }
}






@end
