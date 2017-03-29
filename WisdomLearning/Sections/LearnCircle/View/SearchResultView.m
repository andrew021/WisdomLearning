//
//  SearchResultView.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/10/19.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "SearchResultView.h"
#import "SearchResultListCell.h"
#import "LearnCircleCell.h"
#import "ChooseCourseCell.h"
#import "CertificateListCell.h"

@interface SearchResultView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation SearchResultView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64.0-60) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 250;
        _dataArr = [[NSMutableArray alloc]init];
        [self addSubview:_tableView];
        switch (self.vctype) {
            case 1:
                
                break;
                
            default:
                break;
        }
        
    }
    return self;
}




- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(_vctype == VCLearnCircle){
        static NSString* cellIdentifier = @"LearnCircleCellIdentity";
        LearnCircleCell* cell = (LearnCircleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LearnCircleCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(_vctype == VCCourse){
        static NSString* cellIdentifier = @"ChooseCourseCell";
        ChooseCourseCell* cell = (ChooseCourseCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseCourseCell" owner:nil options:nil] lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        if(indexPath.section == 1){
        //            cell.likeBtn.hidden = YES;
        //        }
        //        else{
        //            cell.likeBtn.hidden = NO;
        //        }
        //    [cell.likeBtn addTarget:self action:@selector(clickLikeBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if(_vctype == VCSpecial){
        static NSString* cellIdentifier = @"LearnCircleCellIdentity";
        LearnCircleCell* cell = (LearnCircleCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LearnCircleCell" owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tagLeftLabel.hidden = YES;
        cell.tagMidLabel.hidden = YES;
        cell.tagRightLabel.hidden = YES;
        cell.layoutTitleLabelTop.constant = 10;
        cell.numLabelLayout.constant = 12;
        cell.hotLabelLayout.constant = 12;
        cell.hotImageLayout.constant = 16;
        cell.layoutLocationLabelTop.constant = 12;
        cell.locationLabelTop.constant = 10;
        return cell;
    }
    else if(_vctype == VCInformation){
        static NSString* cellIdentifier = @"DynCellIdentifire";
        DynCell* cell = (DynCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"DynCell" owner:nil options:nil] lastObject];
        }
        return cell;
    }
    else {
        static NSString* cellIdentifier = @"CertificateListCell";
        CertificateListCell* cell = (CertificateListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CertificateListCell" owner:nil options:nil] lastObject];
        }
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_vctype == VCInformation){
        return 85;
    }
    return 110;
}



-(UIView*)createHeadViewWithTitle:(NSString*)title {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH, 35)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_delegate){
        [self.delegate pushViewControllerWithSection:indexPath.section andRow:indexPath.row];
    }
}

-(void)clickLikeBtn:(UIButton*)btn{
    if(_delegate){
        [self.delegate clickCollectBtn:btn];
    }
}
@end
