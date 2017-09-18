//
//  OfferViewController.m
//  GetHotel Bussiness
//
//  Created by admin1 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "OfferViewController.h"
#import "quoteTableViewCell.h"
#import "POP.h"
#import "CityListViewController.h"
#import "SelectOfferModel.h"
@interface OfferViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    BOOL tags;
}
@property (weak, nonatomic) IBOutlet UITableView *quoteTable;
- (IBAction)depart:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)destination:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *departButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIView *datePickView;
@property (weak, nonatomic) IBOutlet UIButton *selecCabin;
- (IBAction)cabinAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property(strong,nonatomic)NSMutableArray *selectOfferArr;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;
- (IBAction)confirmAction:(UIBarButtonItem *)sender;
- (IBAction)departuretime:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)arrivaltime:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *arrivaltimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *departuretimeBtn;
@property (weak, nonatomic) IBOutlet UITextField *finalPrice;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *aviationCompany;
@property (weak, nonatomic) IBOutlet UITextField *flightNo;
@property (weak, nonatomic) IBOutlet UITextField *aviationCabin;
@property (weak, nonatomic) IBOutlet UIView *cabinPicker;
@property(strong,nonatomic)NSArray *cabinnamearr;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerview;
@property(nonatomic)NSTimeInterval startTime;
@property(nonatomic)NSTimeInterval arrTime;
@property(nonatomic)NSTimeInterval tempTime;
- (IBAction)cancel2:(UIBarButtonItem *)sender;
- (IBAction)confirm2:(UIBarButtonItem *)sender;



@end

@implementation OfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    _startTime = [NSDate.date timeIntervalSince1970];
    _arrTime = [NSDate.dateTomorrow timeIntervalSince1970];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDepartCity:) name:@"depart" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkDestinationCity:) name:@"destination" object:nil];
    self.quoteTable.tableFooterView = [UIView new];
    tags=nil;
    _selectOfferArr=[NSMutableArray new];
    [self selectOfferRequest];
    self.cabinnamearr=@[@"头等舱",@"商务舱",@"经济舱"];
    NSLog(@"%@",[[StorageMgr singletonStorageMgr]objectForKey:@"id"]);
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
#pragma mark - Navigation
//这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题的文字
    self.navigationItem.title = @"报价";
    
    
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
    
    //设置边框颜色
    //   _chooseHotelBtn.layer.borderColor = [[UIColor redColor] CGColor];
    //    //设置边框宽度
    //    _chooseHotelBtn.layer.borderWidth = 1.0f;
    //   _chooseHotelBtn.layer.masksToBounds = YES;
}
//用model的方式返回上一页
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];//用push返回上一页
}
#pragma mark -request
//删除网络请求
- (void)deleteRequest:(NSIndexPath *)indexPath {
    SelectOfferModel *seModel = _selectOfferArr[indexPath.row];
    NSDictionary *para = @{@"id":@(seModel.Id)};
   
    [RequestAPI requestURL:@"/deleteHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"delete responseObject = %@",responseObject);
        
        [_quoteTable reloadData];
        
        //        if ([responseObject[@"result"] integerValue] == 1){
        //            [_hotelTableView reloadData];
        //        }else{
        //        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
        NSLog(@"删除error:%ld",(long)statusCode);
    }];
}
-(void)offerRequst{
    double finalPrice=[_finalPrice.text doubleValue];
    NSInteger weight=[_weight.text integerValue];
    NSString *aviationcompany=_aviationCompany.text;
    NSString *aviationcabin=_selecCabin.titleLabel.text;
    NSString *intimestr=_departuretimeBtn.titleLabel.text;
    NSString *outtimestr=_arrivaltimeBtn.titleLabel.text;
    NSString *departurestr=_departButton.titleLabel.text;
    NSString *destinationstr=_destinationButton.titleLabel.text;
    NSString *flightNostr=_flightNo.text;
    
    NSDictionary *para=@{@"business_id":@2,@"aviation_demand_id":[[StorageMgr singletonStorageMgr]objectForKey:@"id"],@"final_price":@(finalPrice),@"weight":@(weight),@"aviation_company":aviationcompany,@"aviation_cabin":aviationcabin,@"in_time_str":intimestr,@"out_time_str":outtimestr,@"departure":departurestr,@"destination":destinationstr,@"flight_no":flightNostr};
    [RequestAPI requestURL:@"/offer_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        NSLog(@"result=%@",responseObject[@"result"]);
        [_quoteTable reloadData];
    } failure:^(NSInteger statusCode, NSError *error) {
          NSLog(@"cuowu :%ld",(long)statusCode);
    }];
}

-(void)selectOfferRequest{
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:@{@"Id":[[StorageMgr singletonStorageMgr]objectForKey:@"id"]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        if([responseObject[@"result"]integerValue]==1){
             NSLog(@"%@",responseObject[@"content"]);
            NSArray *list=responseObject[@"content"];
            
            [_selectOfferArr removeAllObjects];
            for(NSDictionary *result in list){
               
                SelectOfferModel *offer=[[SelectOfferModel alloc]initWithDict:result];
                
                [_selectOfferArr addObject:offer];
            }
            [_quoteTable reloadData];
        }
        else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:@"错误" andTitle:@"警报" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}
#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
}
//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//设置每组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectOfferArr.count;
}

-(UITableView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    quoteTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OfferCell" forIndexPath:indexPath];
    SelectOfferModel *selectOfferModel=_selectOfferArr[indexPath.row];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.PriceLabel.text=[NSString stringWithFormat:@"%ld",(long)selectOfferModel.finalprice];
    NSString *inTime=selectOfferModel.in_time_str;
    NSString *outTime=selectOfferModel.out_time_str;
    cell.TimeLabel.text=[NSString stringWithFormat:@"%@——%@",inTime,outTime];
    cell.flightLabel.text=[NSString stringWithFormat:@"%@ %@ %@",selectOfferModel.aviationCompany,selectOfferModel.flightNo,selectOfferModel.aviationCabin];
    cell.weight.text=[NSString stringWithFormat:@"%ld",(long)selectOfferModel.weight];
    return cell;
}

////创建左滑删除按钮
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        
//        //先删数据 再删UI
//       
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }];
//    return @[deleteAction];
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该条航空发布吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteRequest:indexPath];
            [_selectOfferArr removeObjectAtIndex:indexPath.row];//删除数据
            //移除tableView中的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }];
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionA];
        [alert addAction:actionB];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//修改delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return @"删除";
}

#pragma -action
- (IBAction)ConfirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    if([_departButton.titleLabel.text isEqualToString:@"选择出发地"]){
        [Utilities popUpAlertViewWithMsg:@"请填写出发地" andTitle:@"提示" onView:self];
        
    }else if([_destinationButton.titleLabel.text isEqualToString:@"选择目的地"]){
        [Utilities popUpAlertViewWithMsg:@"请填写目的地" andTitle:@"提示" onView:self];
    }else if ([_departuretimeBtn.titleLabel.text isEqualToString:@"选择出发日期"]){
        [Utilities popUpAlertViewWithMsg:@"请填写出发日期" andTitle:@"提示" onView:self];
    }else if ([_arrivaltimeBtn.titleLabel.text isEqualToString:@"选择到达日期"]){
        [Utilities popUpAlertViewWithMsg:@"请填写到达日期" andTitle:@"提示" onView:self];
    }else if ([_selecCabin.titleLabel.text isEqualToString:@"选择舱位"]){
        [Utilities popUpAlertViewWithMsg:@"请填写舱位" andTitle:@"提示" onView:self];
    }else if ([_finalPrice.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:@"提示" onView:self];
    }else if ([_aviationCompany.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写航空公司" andTitle:@"提示" onView:self];
    }else if ([_flightNo.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写航班" andTitle:@"提示" onView:self];
    }else if ([_weight.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写行李重量" andTitle:@"提示" onView:self];
    }else{
        [self offerRequst];
        [_departButton setTitle:@"选择出发地" forState:UIControlStateNormal];
        [_destinationButton setTitle:@"选择目的地" forState:UIControlStateNormal];
        [_departuretimeBtn setTitle:@"选择出发日期" forState:UIControlStateNormal];
        [_arrivaltimeBtn setTitle:@"选择到达日期" forState:UIControlStateNormal];
        [_selecCabin setTitle:@"选择舱位" forState:UIControlStateNormal];
        _finalPrice.text=@"";
        _aviationCompany.text=@"";
        
        _flightNo.text=@"";
        _weight.text=@"";
        [self selectOfferRequest];
}
//    UITouch *touch=[[event allTouches] anyObject];
//    //触摸实例在特定坐标系中的位置
//    CGPoint location=[touch locationInView:_confirmButton];
//    //创一个视图座位涟漪效果的展示体，以point为中心
//    UIView *ripple=[[UIView alloc]initWithFrame:CGRectMake(location.x-10, location.y-10, 20, 20)];
//    ripple.layer.cornerRadius=10;
//    ripple.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.2];
//    [_confirmButton addSubview:ripple];
//    POPBasicAnimation *rippleSizeAnimation=[POPBasicAnimation animation];
//    rippleSizeAnimation.property=[POPAnimatableProperty propertyWithName:kPOPLayerSize];
//    rippleSizeAnimation.duration=0.5;
//    rippleSizeAnimation.toValue=[NSValue valueWithCGSize:CGSizeMake((_confirmButton.frame.size.width+_confirmButton.frame.size.height)*2, (_confirmButton.frame.size.width+_confirmButton.frame.size.height)*2)];
//    [ripple pop_addAnimation:rippleSizeAnimation forKey:@"rippleSizeAnimation"];
//    
//    POPBasicAnimation *rippleCRAnimation =[POPBasicAnimation animation];
//    rippleCRAnimation.property=[POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
//    rippleCRAnimation.duration=0.5;
//    rippleCRAnimation.toValue=@(_confirmButton.frame.size.width+_confirmButton.frame.size.height);
//    [ripple.layer pop_addAnimation:rippleCRAnimation forKey:@"rippleCRAnimation"];
//    rippleCRAnimation.completionBlock = ^(POPAnimation *anim, BOOL additive) {
//        
//        
//        
//
//    
//        
//        
//       
//        
//    };

}
#pragma mark - Action
- (IBAction)depart:(UIButton *)sender forEvent:(UIEvent *)event {
      NSNumber  *tag=@0;
   // [self performSegueWithIdentifier:@"departAction" sender:tag];
    CityListViewController *cityListVC=[Utilities getStoryboardInstance:@"AirPrice" byIdentity:@"CityListID"];
    [cityListVC setTag:tag];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:cityListVC];
    [self presentViewController:nc animated:YES completion:nil];
}


- (IBAction)destination:(UIButton *)sender forEvent:(UIEvent *)event {
    NSNumber  *tag=@1;
    // [self performSegueWithIdentifier:@"departAction" sender:tag];
    CityListViewController *cityListVC=[Utilities getStoryboardInstance:@"AirPrice" byIdentity:@"CityListID"];
    [cityListVC setTag:tag];
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:cityListVC];
    [self presentViewController:nc animated:YES completion:nil];
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    CityListViewController *CityListViewController=[segue destinationViewController];
//    if ([segue.identifier isEqualToString:@"departAction"]) {
//        CityListViewController.tag=sender;
//    }else{
//        CityListViewController.tag=sender;
//    }
//}
#pragma  mark - notification
-(void)checkDepartCity:(NSNotification *)note{
    NSString *cityStr=note.object;
    if(![_departButton.titleLabel.text isEqualToString:cityStr]){
        [_departButton setTitle:cityStr forState:UIControlStateNormal];
    }
}
-(void)checkDestinationCity:(NSNotification *)note{
    NSString *cityStr=note.object;
    if(![_destinationButton.titleLabel.text isEqualToString:cityStr]){
        [_destinationButton setTitle:cityStr forState:UIControlStateNormal];
}
}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _datePickView.hidden=YES;
}

- (IBAction)confirmAction:(UIBarButtonItem *)sender {
    //NSDate *datetemp=[NSDate new];
    if(tags){
        NSDate *pickerDate= _datePicker.date;
        //datetemp=_datePicker.date;
        _tempTime = [pickerDate timeIntervalSince1970];
        if (_startTime > _arrTime) {
            [Utilities popUpAlertViewWithMsg:@"时间有误" andTitle:nil onView:self];
            return;
        }
        NSDateFormatter *pickerFormatter =[[NSDateFormatter alloc ]init];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *startString =[pickerFormatter stringFromDate:pickerDate];
        [_departuretimeBtn setTitle:startString forState:UIControlStateNormal];
        _datePickView.hidden=YES;
    }
    
    else{
        
        NSDate *pickerDate= _datePicker.date;
        _tempTime = [pickerDate timeIntervalSince1970];
        if (_tempTime < _arrTime) {
            [Utilities popUpAlertViewWithMsg:@"时间有误" andTitle:nil onView:self];
            return;
        }
        NSDateFormatter *pickerFormatter =[[NSDateFormatter alloc ]init];
        [pickerFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *arrString =[pickerFormatter stringFromDate:pickerDate];
        [_arrivaltimeBtn setTitle:arrString forState:UIControlStateNormal];
     
        _datePickView.hidden=YES;
      
    }
}

- (IBAction)departuretime:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePickView.hidden=NO;
    tags=YES;
}

- (IBAction)arrivaltime:(UIButton *)sender forEvent:(UIEvent *)event {
    _datePickView.hidden=NO;
    tags=NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _datePickView.hidden=YES;
    _cabinPicker.hidden=YES;
}
- (IBAction)cabinAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _cabinPicker.hidden=NO;
}
#pragma mark - pickerview
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _cabinnamearr.count;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    return _cabinnamearr[row];
    
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  _pickerview.frame.size.width/2.3;
}
- (IBAction)cancel2:(UIBarButtonItem *)sender {
    _cabinPicker.hidden=YES;
}

- (IBAction)confirm2:(UIBarButtonItem *)sender {
    _cabinPicker.hidden=YES;
    NSInteger row=[_pickerview selectedRowInComponent:0];
    NSString *title=_cabinnamearr[row];
    [_selecCabin setTitle:title forState:UIControlStateNormal];
}
@end
