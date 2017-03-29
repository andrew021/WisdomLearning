//
//  ZSPopUpSortView.m
//  WisdomLearning
//
//  Created by Shane on 17/1/12.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "ZSPopUpSortView.h"
#import "SortCell.h"

@interface ZSPopUpSortView()<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titles;

@end

@implementation ZSPopUpSortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithFrame:(CGRect)frame withTitles:(NSArray*)titles
{
    if (self = [super initWithFrame:frame]){
        _titles = titles;
        _selectedIndex = -1;
        
        if (titles.count <= 2) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 45*titles.count) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 135) style:UITableViewStylePlain];
        }
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib:[UINib nibWithNibName:@"SortCell" bundle:nil] forCellReuseIdentifier:@"SortCell"];
        self.tableView.rowHeight = 45;
        self.tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SortCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SortCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titles[indexPath.row];
    if (_selectedIndex == indexPath.row) {
        cell.titleLabel.textColor = kMainThemeColor;
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.sortButton.selected = NO;
        [cell.sortButton setBackgroundImage:[UIImage imageNamed:@"arrows_gray"] forState:UIControlStateNormal];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SortCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_selectedIndex == indexPath.row) {
        cell.sortButton.selected = !(cell.sortButton.selected);
        
    }else{
        _selectedIndex = indexPath.row;
        cell.titleLabel.textColor = kMainThemeColor;
        [cell.sortButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"arrow_down_selected"] forState:UIControlStateSelected];
        [cell.sortButton setBackgroundImage:[ThemeInsteadTool imageWithImageName:@"arrow_up_selected"] forState:UIControlStateNormal];
    }
    
    [tableView reloadData];
    
    if (_theDelegate && [_theDelegate respondsToSelector:@selector(clickSortViewIndex:)]) {
        _bSortUp = cell.sortButton.selected;
        [_theDelegate clickSortViewIndex:indexPath.row];
    }
}


@end
