//
//  AdviceBackViewController.m
//  BigMovie
//
//  Created by martin on 16/3/18.
//  Copyright © 2016年 zhisou. All rights reserved.
//意见反馈

#import "AdviceBackViewController.h"

@interface AdviceBackViewController ()<UITextViewDelegate>

@property (nonatomic,retain)UITextView *textView;
@property (nonatomic , assign) UILabel *placeHolderLabel;

@end

@implementation AdviceBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendMansage)];
    self.navigationItem.rightBarButtonItem = leftItem;
    [self creatTextView];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.homeNav setNavigationBarHidden:YES animated:animated];
//    
//}
- (void)creatTextView{
    self.textView=[[UITextView
                     alloc] initWithFrame:self.view.frame]; //初始化大小并自动释放
    self.textView.textColor
    = [UIColor blackColor];//设置textview里面的字体颜色
    self.textView.font
    = [UIFont fontWithName:@"Arial"size:15.0];//设置字体名字和字体大小
    self.textView.delegate= self;//设置它的委托方法
    self.textView.backgroundColor= [UIColor whiteColor];//设置它的背景颜色
    self.textView.returnKeyType= UIReturnKeyDefault;//返回键的类型
    self.textView.keyboardType= UIKeyboardTypeDefault;//键盘类型
    self.textView.scrollEnabled= YES;//是否可以拖动
    self.textView.autoresizingMask= UIViewAutoresizingFlexibleHeight;//自适应高度
    
    UILabel *myPlaceHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel = myPlaceHolderLabel;
    self.placeHolderLabel.backgroundColor = [UIColor whiteColor];
    self.placeHolderLabel.numberOfLines = 0;
    self.placeHolderLabel.enabled = NO;
    self.placeHolderLabel.text = @"写下你的意见与使用反馈，以帮助我们更好的改进产品。";
    self.placeHolderLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1];
    self.placeHolderLabel.y = 8;
    self.placeHolderLabel.x = 8;
    self.placeHolderLabel.width = SCREEN_WIDTH - self.placeHolderLabel.y *2.0;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15];
    [self.placeHolderLabel sizeToFit];
    [self.textView addSubview:self.placeHolderLabel];
    [self.view addSubview: self.textView];//加入到整个页面中
    [self.textView becomeFirstResponder];
//    self.textView.keyboardAppearance = UIKeyboardAppearanceAlert;
//    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
//    self.textView.keyboardType = UIKeyboardTypeWebSearch;
//    self.textView.returnKeyType = UIReturnKeyYahoo;
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"------");
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    } else {
        self.placeHolderLabel.hidden = YES;
    }
    if (textView.text.length >= 200) {
        [self showHint:@"输入的内容超过200字"];
        [self.view endEditing:YES];
        if (textView.text.length > 200) {
            textView.text = [textView.text substringToIndex:200];
        }
    } else {
        self.textView.editable = YES;
    }

}

- (void)sendMansage{
    [self.view endEditing: YES];
    if(self.textView.text.length <15){
        [self showHint:@"反馈内容小于15个字"];
        return;
    }
   // [self showHudInView:self.view hint:@"正在提交"];
    NSDictionary *dic =@{@"FD_CONTENT":self.textView.text};
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self.request requestAddviceBackWith:dic withBlock:^(ZSModel *model, NSError *error) {
//        if (model.isSuccess) {
//            [self showHint:@"提交成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            [self showHint:model.message];
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
