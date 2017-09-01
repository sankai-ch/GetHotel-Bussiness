//
//  ReleaseHotelViewController.m
//  GetHotel Bussiness
//
//  Created by admin on 2017/8/30.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "ReleaseHotelViewController.h"

@interface ReleaseHotelViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *chooseHotelBtn;
- (IBAction)chooseHotelAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) NSArray *pickerArr;
@property (strong, nonatomic) NSArray *arr;
- (IBAction)yesAction:(UIBarButtonItem *)sender;

@end

@implementation ReleaseHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerArr = @[@"天马行空大酒店",@"滴滴滴大酒店",@"南京家园大酒店"];
    _arr = @[@"无锡火车站路500号",@"无锡中央车站对面",@"无锡滨湖区五湖大道100号",@"南京市学府路300号"];
    [_pickView selectRow:2 inComponent:0 animated:NO];
    [_pickView reloadComponent:0];
    [_pickView reloadComponent:1];
    
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
    //设置边框颜色
//   _chooseHotelBtn.layer.borderColor = [[UIColor redColor] CGColor];
//    //设置边框宽度
//    _chooseHotelBtn.layer.borderWidth = 1.0f;
//   _chooseHotelBtn.layer.masksToBounds = YES;
}
- (void)Issue{
    
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

#pragma mark - pickerView
//多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _pickerArr.count;
    }else{
        return _arr.count;
    }
    
}
//设置每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    if (component ==0) {
        return _pickerArr[row];
    }else{
        return _arr[row];
    }
}
//设置每列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return _pickView.frame.size.width/2.3;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseHotelAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden=NO;
    _pickView.hidden=NO;
}
- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden=YES;
    _pickView.hidden=YES;
}
- (IBAction)yesAction:(UIBarButtonItem *)sender {
    NSInteger row = [_pickView selectedRowInComponent:0];
    NSString *title= _pickerArr[row];
    //拿到某一列中选中的行号
    NSInteger raw =[_pickView selectedRowInComponent:1];
    //根据上面拿到的行号，找到对应的数据（选中行的标题）
    NSString *ti= _arr[raw];
    //把拿到的标题显示在button
    [_chooseHotelBtn setTitle:[title stringByAppendingString:ti] forState:UIControlStateNormal];
    
    // [_popupBtn setTitle:ti forState:UIControlStateNormal];
    _toolBar.hidden=YES;
    _pickView.hidden=YES;
}
@end
