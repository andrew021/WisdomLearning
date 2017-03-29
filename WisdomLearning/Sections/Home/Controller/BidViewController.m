//
//  BidViewController.m
//  BigMovie
//
//  Created by DiorSama on 16/4/25.
//  Copyright © 2016年 zhisou. All rights reserved.
//发布资讯

#import "BidViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "ZSButton.h"
#import "ZSUploader.h"
static NSInteger addNum = 4;


@interface BidViewController ()<SelectImages, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITextField * textField;
@property (nonatomic, strong) NSMutableArray* imageArray;
@property (nonatomic, strong) UITapGestureRecognizer* tap;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIView * keyView;

@end

@implementation BidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"资讯发布";
    self.delegate = self;
    [Tool hideKeyBoard];
    
    self.imageArray = [[NSMutableArray alloc] init];
    
    [self createHeadView];
    [self setupBarButton];
  
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.homeNav setNavigationBarHidden:YES animated:animated];
    
}
#pragma mark--- 创建导航栏右边按钮
-(void)setupBarButton
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发表" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;
  
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 45, 23);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
}


#pragma mark--- 发布资讯
-(void)uploadClick
{
    [Tool hideKeyBoard];
    if([_textField.text isEqualToString:@""]){
        [self showHint:@"没有填写标题!" yOffset:-230];
        return;
    }
    
    if([self getHTML].length == 0){
        [self showHint:@"请编辑内容!" yOffset:-230];
       
        return;
    }
    
    
    [self showHudInView:self.view hint:@"正在发表..."];
    NSDictionary * dic = @{@"newsId":@"",@"userId":gUserID,@"title":_textField.text,@"content":[self getHTML]};
    [self.request requestAddInfoWithDic:dic block:^(ZSModel *model, NSError *error) {
        [self hideHud];
        [self showHint:model.message];
        if(model.isSuccess){
            [self.navigationController popViewControllerAnimated:YES];
            if(self.delegate){
                [self.delegate interactData:nil tag:1 data:nil];
            }
        }
    }];
}


//拍照
-(void)insertImage
{
    [self insertImageWithType:1];
}

//相册
- (void)insertLink
{
    [self insertImageWithType:2];
}
//拍照，相册

-(void)selectImagesInsertWithTag:(NSInteger)tag
{
    [self.toolBarScroll addSubview:self.toolbar];
}


- (void)setBold {
    NSString *trigger = @"zss_editor.setBold();";
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


-(void)headingReduce
{
   addNum ++;
    //NSLog(@"%ld",(long)reduceNum);
    NSString * trigger = [NSString stringWithFormat:@"zss_editor.setHeading('h%ld');",(long)addNum];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];

}

- (void)headingAdd {
    addNum--;
    //NSLog(@"%ld",(long)addNum);
    NSString * trigger = [NSString stringWithFormat:@"zss_editor.setHeading('h%ld');",(long)addNum];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
   
   
}

//插入图片
- (void)insertImageWithType:(NSInteger)type{
    
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //设置可编辑
    
    if (type == 1) {
        //        拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持拍照功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else  {
        MLSelectPhotoPickerViewController* pickerVC = [[MLSelectPhotoPickerViewController alloc] init];
        pickerVC.status = PickerViewShowStatusCameraRoll;
        pickerVC.maxCount = 10 - self.imageArray.count;
        [pickerVC showPickerVc:self];
        pickerVC.callBack = ^(NSArray* array) {
            //图片转化
            UIImage* image = nil;
            NSData* data = nil;
            for (int i = 0; i < array.count; i++) {
                image = [MLSelectPhotoPickerViewController getImageWithImageObj:array[i]];
                data = UIImageJPEGRepresentation(image, 1.0);
                
//                [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
//                
//                [self showInsertImageDialogWithLink:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2299165671,2554860548&fm=116&gp=0.jpg" alt:@"112312" ];
                [[ZSUploader sharedInstance] uploadImage:data token:gUserID userid:gUserID completeHandler:^(ZSUploaderRespModel *respModel) {
                    if (respModel.url !=nil) {
                        [self showHint:respModel.msg];
                        [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
                     
                      
                        [self showInsertImageDialogWithLink:respModel.url alt:respModel.filename ];
                    }
                    else {
                        [self showHint:respModel.msg];
                    }
                }];
                
            };
        };
        
    }
    [self presentViewController:picker animated:YES completion:nil]; //进入照相界面

    
}


//- (void)showInsertImageDialogWithLink:(NSString *)url alt:(NSString *)alt withType:(NSInteger)type
//{
//    }

-(void)createHeadView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
   // _backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 30)];
    titleLabel.text = @"添加标题:";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = KMainBlack;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH-90, 30)];
    //_textField.keyboardType = UIKeyboardTypeNumberPad;
    _textField.delegate = self;
   // _textField.backgroundColor = [UIColor whiteColor];
    _textField.placeholder = @"请输入标题....";
    _textField.font = [UIFont systemFontOfSize:15];
    

   
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = KMainLine;
    [view addSubview:lineView];
    [view addSubview:titleLabel];
    // [view addSubview:numLabel];
    [view addSubview:_textField];
    [self.view addSubview:view];
    

}

-(void)dismissKeyBoard
{
    [_textField resignFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField becomeFirstResponder];
    return YES;
}

//文本输入框随键盘移动
 - (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
   // [self buildToolbar];
    [self.toolbar removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        _backView.frame=CGRectMake(0, SCREEN_HEIGHT-164-216, SCREEN_WIDTH, 50);
    }];
    
}

//文本输入框收回
-(void)dismissKeyboard
{
    [UIView animateWithDuration:0.3f animations:^{
        _backView.frame=CGRectMake(0, SCREEN_HEIGHT-164, SCREEN_WIDTH, 50);
    }];
   [self.view endEditing:YES];

}



-(void)deleClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectImagesInsert
{
    [self selectLogImage];
}

- (void)selectLogImage
{
//    [self.view endEditing:YES];
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择文件操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
//    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate M
- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController* picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //设置可编辑
    
    if (buttonIndex == 0) {
        //        拍照
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不支持拍照功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1) {
        MLSelectPhotoPickerViewController* pickerVC = [[MLSelectPhotoPickerViewController alloc] init];
        pickerVC.status = PickerViewShowStatusCameraRoll;
        pickerVC.maxCount = 10 - self.imageArray.count;
        [pickerVC showPickerVc:self];
        pickerVC.callBack = ^(NSArray* array) {
            //图片转化
            UIImage* image = nil;
            NSData* data = nil;
            for (int i = 0; i < array.count; i++) {
                image = [MLSelectPhotoPickerViewController getImageWithImageObj:array[i]];
                data = UIImageJPEGRepresentation(image, 1.0);
                [[ZSUploader sharedInstance] uploadImage:data token:gUserID userid:gUserID completeHandler:^(ZSUploaderRespModel *respModel) {
                    if (respModel.url) {
                        [self showHint:respModel.msg];
                        [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
                        
                        [self showInsertImageDialogWithLink:respModel.url alt:respModel.filename ];                    }
                    else {
                        [self showHint:respModel.msg];
                    }
                }];

            };
        };
        [self presentViewController:picker animated:YES completion:nil]; //进入照相界面
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage* editedImage;
        editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        // [self.tableView reloadData];
        NSData* data = nil;
        data = UIImageJPEGRepresentation(editedImage, 1.0);
        
        
        [[ZSUploader sharedInstance] uploadImage:data token:gUserID userid:gUserID completeHandler:^(ZSUploaderRespModel *respModel) {
            if (respModel.url) {
            
                [self showHint:respModel.msg];
                [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
                
                [self showInsertImageDialogWithLink:respModel.url alt:respModel.filename ];
            }
            else {
                [self showHint:respModel.msg];
            }
        }];

        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
