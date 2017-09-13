//
//  ReleaseHotelViewController.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ReleaseHotelViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "addHotelModel.h"
@interface ReleaseHotelViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    
    UIImagePickerController *imagePickerController;
}
@property (weak, nonatomic) IBOutlet UIButton *chooseHotelBtn;
- (IBAction)chooseHotelAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSMutableArray *pickerArr;

- (IBAction)yesAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *hotelPic;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UITextField *roomNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *breakfastLabel;
@property (weak, nonatomic) IBOutlet UITextField *bedTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *roomAreaLabel;
@property (weak, nonatomic) IBOutlet UITextField *roomPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *weekendsPriceLabel;
@property (strong, nonatomic) NSMutableArray *hotelNamePickerArr;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSArray *testArr;
@property (strong, nonatomic) NSString *imgUrl;

@end

@implementation ReleaseHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //将手势添加到hotelPic这个视图中
    [self addTapGestureRecognizer:_hotelPic];
    _hotelNamePickerArr = [NSMutableArray new];
    
    [self searchRequset];
    //addHotelModel *model = [[addHotelModel alloc] init];
    //NSLog(@"didi%@",model.hotelName);
    
    _pickerArr = [NSMutableArray new];
    [_pickView selectRow:1 inComponent:0 animated:YES];
    
    [_pickView reloadComponent:0];

    //_hotelNamePickerArr = model.hotelName;
    
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePickerController.allowsEditing = YES;
    
    [self btnStyle];
    [self naviConfig];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"酒店发布";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(15, 100, 240);
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置是否需要毛玻璃效果
    //self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(Issue)];
    self.navigationItem.rightBarButtonItem = right;
    
}

- (void)Issue{
    [self issueRequest];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"issue" object:self userInfo:@{@"hotelName":_roomNameLabel.text}];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}

#pragma mark - 选择酒店按钮样式
- (void)btnStyle{
    [_chooseHotelBtn.layer setBorderColor:[UIColor colorWithRed:0.19 green:0.57 blue:0.95 alpha:1].CGColor];//边框颜色
}

#pragma mark - 单击手势

- (void)addTapGestureRecognizer: (id)any{
    //初始化一个单击手势，设置它的响应事件为tapClick
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    //用户交互启用
    _hotelPic.userInteractionEnabled = YES;
    //将手势添加入参
    [any addGestureRecognizer:tap];
}

- (void)tapClick: (UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"你单击了");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选取相片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectImageFromCamera];
            
        }];
        
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self selectImageFromAlbum];
            //[self image:_hotelPic didFinishSavingWithError:nil contextInfo:nil];
           // _hotelPic = UIImagePickerControllerSourceTypePhotoLibrary;
        }];
        UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionA];
        [alert addAction:actionB];
        [alert addAction:actionC];
        [self presentViewController:alert animated:YES completion:^{
            
        }];

    }
}

#pragma mark - 相机拍照获取图片
//从相机中获取图片
- (void)selectImageFromCamera{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//设置类型为相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;//设置代理
        picker.allowsEditing = YES;//设置照片可编辑
        picker.sourceType = sourceType;
        //设置是否显示相机控制按钮 默认为YES
        picker.showsCameraControls = YES;
        
        //        //创建叠加层(例如添加的相框)
        //        UIView *overLayView=[[UIView alloc]initWithFrame:CGRectMake(0, 120, 320, 254)];
        //        //取景器的背景图片，该图片中间挖掉了一块变成透明，用来显示摄像头获取的图片；
        //        UIImage *overLayImag=[UIImage imageNamed:@"zhaoxiangdingwei.png"];
        //        UIImageView *bgImageView=[[UIImageView alloc]initWithImage:overLayImag];
        //        [overLayView addSubview:bgImageView];
        //        picker.cameraOverlayView=overLayView;
        
        //选择前置摄像头或后置摄像头
        picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
    else {  
        [Utilities popUpAlertViewWithMsg:@"该设备无相机" andTitle:@"提示" onView:self];
    }
}

//从相册中获取图片
- (void)selectImageFromAlbum{
    NSLog(@"相册");
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - 从相册选择图片后操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //NSLog(@"%@",info);
    
    //获取源图像（未经裁剪）
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //获取裁剪后的图像
    //UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //将照片存到媒体库
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    _hotelPic.image = image;
    
    //NSData *data = UIImageJPEGRepresentation(image, 1.0f);
    //_imgUrl = [data base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    //_imgUrl = [data base64Encoding];
    NSLog(@"URL:%@",_imgUrl);
    
    //将照片存到沙盒
    [self saveImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 照片存到本地后的回调
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"存储成功");
    } else {
        NSLog(@"存储失败：%@", error);
    }
}
#pragma mark - 保存图片
- (void) saveImage:(UIImage *)currentImage {
    //设置照片的品质
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    NSLog(@"%@",NSHomeDirectory());
    // 获取沙盒目录
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentImage.png"];
    // 将图片写入文件
    [imageData writeToFile:filePath atomically:NO];
    //将选择的图片显示出来
    //    [self.photoImage setImage:[UIImage imageWithContentsOfFile:filePath]];
    
}
#pragma mark - 取消操作时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

//#pragma mark 图片保存完毕的回调
//- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
//    
//}
#pragma mark - 键盘收回
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    //[UIView animateWithDuration:0.5 animations:^{
    //    self.view.transform = CGAffineTransformIsIdentity(self.view);
    //}]
    [self.view endEditing:YES];
    //[self.view _ endEditing:YES];
} 
- (IBAction)TextField_DidEndOnExit:(id)sender{
    [sender resignFirstResponder];
}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    int offset = self.view.frame.origin.y - 216.0;//iPhone键盘高
//    [UIView animateWithDuration:0.5 animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, -offset);
//    }];
//}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}
/*
- (void)keyboardWillChangeFrame: (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo [UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        
    }];
}
*/
#pragma mark - Request
- (void)issueRequest{
    
    //NSDictionary *para = @{@"business_id":@2,@"hotel_name":@"海天",@"hotel_type":
    NSInteger row = [_pickView selectedRowInComponent:0];
    NSString *title= _hotelNamePickerArr[row];
    [_chooseHotelBtn setTitle:title forState:UIControlStateNormal];
    _imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505461689&di=9c9704fab9db8eccb77e1e1360fdbef4&imgtype=jpg&er=1&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20150312%2Fhaixinghezhenzhubeikeshiliangbeijing_3937174.jpg";
    NSDictionary *para = @{@"business_id":@2,@"hotel_name":title ,@"hotel_type":_roomAreaLabel.text,@"room_imgs":_imgUrl,@"price":_roomPriceLabel.text};
    
    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        if ([responseObject[@"result"]integerValue] == 1){
            NSLog(@"issue:%@",responseObject[@"result"]);
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}

- (void)searchRequset{
    [RequestAPI requestURL:@"/searchHotelName" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        //NSLog(@"%@",responseObject[@"content"]);
        [_avi stopAnimating];
        //NSArray *arr = responseObject[@"content"];
        if ([responseObject[@"result"]integerValue] == 1)
        {
            _pickerArr = responseObject[@"content"];
            for (NSDictionary *dict in _pickerArr){
                NSString *str = dict[@"hotel_name"];
                [_hotelNamePickerArr addObject:str];
            }
            [_pickView reloadAllComponents];
        }
        else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
        
    }];
}
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self searchRequset];
}


//#pragma mark - reg & unreg notification
//
//- (void)regNotification
//
//{
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    
//}
//
//- (void)unregNotification
//
//{
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    
//}
//
//#pragma mark - notification handler
//
//- (void)keyboardWillChangeFrame:(NSNotification *)notification
//
//{
//    
//    NSDictionary *info = [notification userInfo];
//    
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    
//    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    
//    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
//    
//    CGRect roomAreaRect = self.roomAreaLabel.frame;
//    
//    CGRect roomPriceRect = self.roomPriceLabel.frame;
//    
//    roomAreaRect.origin.y += yOffset;
//    
//    roomPriceRect.origin.y += yOffset;
//    
//    [UIView animateWithDuration:duration animations:^{
//        
//        self.roomAreaLabel.frame = roomAreaRect;
//        
//        self.roomPriceLabel.frame = roomPriceRect;
//        
//    }];
//    
//}


- (IBAction)chooseHotelAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickView.hidden = NO;
    _grayView.hidden = NO;
    [self initializeData];
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickView.hidden = YES;
    _grayView.hidden = YES;
}

- (IBAction)yesAction:(UIBarButtonItem *)sender {
   // NSInteger row = [_pickView selectedRowInComponent:0];
    //NSString *title= _hotelNamePickerArr[row];
    
    NSInteger row = [_pickView selectedRowInComponent:0];
    NSString *title = _hotelNamePickerArr[row];
    [_chooseHotelBtn setTitle:title forState:UIControlStateNormal];
    
    _toolBar.hidden = YES;
    _pickView.hidden = YES;
    _grayView.hidden = YES;
}

#pragma mark - pickerView
//多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //addHotelModel *addModel = _hotelNamePickerArr[row];
    return _hotelNamePickerArr.count;
    
}
//设置每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return _hotelNamePickerArr[row];
    
}

//设置每列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return _pickView.frame.size.width/2.3;
}
@end
