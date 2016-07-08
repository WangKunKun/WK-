

#import "WKDatePickView.h"
#define CONTENTVIEWHEIGHT 185

//只能发三小时后的单
#define COUNT 3
@interface WKDatePickView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

//省 数组
@property (strong, nonatomic) NSMutableArray *dayArr;
//城市 数组
@property (strong, nonatomic) NSMutableArray *hourArr;

@property (strong, nonatomic) NSMutableArray<NSString *> * hourShowArr;

//区县 数组
@property (strong, nonatomic) NSMutableArray *minuteArr;

@property (strong, nonatomic) NSMutableArray<NSString *> *minuteShowArr;

//当前时间
@property (strong, nonatomic) NSString * persentDate;
@property (assign, nonatomic) NSString * persentHour;
@property (assign, nonatomic) NSString * persentHMinute;

//选中时间
@property (strong, nonatomic) NSString * selectedDay;
@property (strong, nonatomic) NSString * selectedHour;
@property (strong, nonatomic) NSString * selectedMinute;


@property (strong, nonatomic) IBOutlet UIView *BGView;

@end
@implementation WKDatePickView

- (instancetype)init{
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WKDatePickView" owner:nil options:nil]firstObject];
        self.frame = [UIScreen mainScreen].bounds;
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        
 
        
        self.persentDate = [self getPresentDateStr];//当前完整时间
        self.persentHour = [self getPresentHourStr];
        self.persentHMinute = [self getPresentMinuteStr];
        self.dayArr = [@[@"明天",@"今天",@"后天"] mutableCopy];
        self.hourArr = [NSMutableArray array];
        self.minuteArr = [NSMutableArray array];
        for (NSUInteger i = 0; i < 24; i ++) {
            if (i < 10) {
                [self.hourArr addObject:[NSString stringWithFormat:@"0%lu:00",(unsigned long)i]];
            }
            else
            {
                [self.hourArr addObject:[NSString stringWithFormat:@"%lu:00",(unsigned long)i]];
            }
        }
        
        for (NSUInteger i = 0; i < 6; i ++) {
            [self.minuteArr addObject:[NSString stringWithFormat:@"%lu0分",(unsigned long)i]];
        }
        self.hourShowArr = [self.hourArr mutableCopy];
        self.minuteShowArr = [self.minuteArr mutableCopy];
        [self customView];
        
        //两个才能初始化
        [self.pickView selectRow:1 inComponent:0 animated:YES];
        [self pickerView:_pickView didSelectRow:1 inComponent:0];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_BGView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self hide];
}

- (NSString *)getPresentDateStr
{
    return [self getPresentDateWithStyle:@"yyyy/MM/dd HH:mm:ss"];
}

- (NSString *)getPresentHourStr
{
    return [self getPresentDateWithStyle:@"HH"];

}

- (NSString *)getPresentMinuteStr
{
    return [self getPresentDateWithStyle:@"mm"];
}


- (NSString *)getPresentDateWithStyle:(NSString *)style
{
    return [self getPresentDateWithStyle:style delayTime:60 * 60 * COUNT];
}

- (NSString *)getPresentDateWithStyle:(NSString *)style delayTime:(NSUInteger)time
{
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:time];
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:style];
    NSString *locationString=[formatter stringFromDate:date];
    return locationString;
}

- (void)customView{
    self.contentViewBottom.constant = -CONTENTVIEWHEIGHT;
    [self layoutIfNeeded];
}

#pragma mark - setter && getter

#pragma mark - action

//选择完成
- (IBAction)finishBtnPress:(UIButton *)sender {
    if (self.block) {
    
        //特殊情况今天不能选了，23：50后
        if (self.hourShowArr.count == 0) {
            _selectedHour = @"0";
            _selectedMinute = @"00";
            _selectedDay = @"明天";
        }
        else{
            _selectedHour = _selectedHour == nil ? [self.hourShowArr[0] componentsSeparatedByString:@":"][0] : _selectedHour;
            _selectedDay = _selectedDay == nil ? [self dayArr][0] : _selectedDay;
            _selectedMinute = _selectedMinute == nil ? [self.minuteShowArr[0] substringToIndex:self.minuteShowArr[0].length - 1] : _selectedMinute;
        }
        NSString * date = [self dayConvertToDate:_selectedDay];
        date = [date stringByAppendingString:[NSString stringWithFormat:@" %@:%@",_selectedHour,_selectedMinute]];


        
        self.block(self,date);
    }
    [self hide];
}



#pragma  mark - function

- (void)show{
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    UIView *topView = [win.subviews firstObject];
    [topView addSubview:self];
//    [self pickerView:_pickView didSelectRow:1 inComponent:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.contentViewBottom.constant = 0;
        [self layoutIfNeeded];
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.contentViewBottom.constant = -CONTENTVIEWHEIGHT;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {

        case 0:
            return self.dayArr.count;
            break;
        case 1:
        {


            return self.hourShowArr.count;
        }
            break;
        case 2:
            if (self.minuteShowArr.count) {
                return self.minuteShowArr.count;
                break;
            }
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {

        case 0:
            return [self.dayArr objectAtIndex:row] ;
            break;
        case 1:{
            if (self.hourShowArr.count > 0) {
                return [self.hourShowArr objectAtIndex:row];
            }
            return @"今天都玩完了";
        }
            break;
        case 2:
            if (self.minuteShowArr.count) {
                return [self.minuteShowArr objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}
#pragma mark - UIPickerViewDelegate

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.minimumScaleFactor = 8.0;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    }
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            if (row == 1) {//今天特殊处理
                //count 要减
                NSUInteger count = [self.persentHour integerValue] ;
                NSUInteger minuteCount = [self.persentHMinute integerValue] / 10 + 1;
                //当前时间超过50分，小时显示再减少1一个
                
                if (minuteCount >= 5) {
                    count += 1;
                }
                self.hourShowArr = [self.hourArr mutableCopy];
                [self.hourShowArr removeObjectsInRange:NSMakeRange(0, count)];
                
                [self.pickView reloadComponent:1];
                [self.pickView selectRow:0 inComponent:1 animated:YES];
                
                if(minuteCount < 5){
                    self.minuteShowArr = [self.minuteArr mutableCopy];
                    [self.minuteShowArr removeObjectsInRange:NSMakeRange(0, minuteCount)];
                    [self.pickView reloadComponent:2];
                    [self.pickView selectRow:0 inComponent:2 animated:YES];
                }
                
            }
            else
            {
                self.hourShowArr = [self.hourArr mutableCopy];
                [self.pickView reloadComponent:1];
                self.minuteShowArr = [self.minuteArr mutableCopy];
                [self.pickView reloadComponent:2];

            }
            
            _selectedDay = _dayArr[row];
            break;
        }
        case 1:{
            NSUInteger temp = [[self.hourShowArr[row] componentsSeparatedByString:@":"][0] integerValue] ;

            if (row == 0 && [_selectedDay isEqualToString:@"今天"]) {

                if( temp == [_persentHour integerValue])
                {
                    NSUInteger minuteCount = [self.persentHMinute integerValue] / 10 + 1;

                    self.minuteShowArr = [self.minuteArr mutableCopy];
                    [self.minuteShowArr removeObjectsInRange:NSMakeRange(0, minuteCount)];
                    [self.pickView reloadComponent:2];
                    [self.pickView selectRow:0 inComponent:2 animated:YES];
                }
            }
            else
            {
                self.minuteShowArr = [self.minuteArr mutableCopy];
                [self.pickView reloadComponent:2];

            }
            
            _selectedHour = [self.hourShowArr[row] componentsSeparatedByString:@":"][0];
            break;
        }
        case 2:{

            _selectedMinute = [self.minuteShowArr[row] substringToIndex:self.minuteShowArr[row].length - 1];
            break;
        }
        default:
            break;
    }
}

- (NSString *)dayConvertToDate:(NSString *)day
{
    if ([day isEqualToString:@"今天"]) {
        return [self.persentDate componentsSeparatedByString:@" "][0];
    }
    else if([day isEqualToString:@"明天"])
    {
        return [self getPresentDateWithStyle:@"yyyy/MM/dd" delayTime:60 * 60 * 24];
    }
    else
    {
        return [self getPresentDateWithStyle:@"yyyy/MM/dd" delayTime:60 * 60 * 24 * 2];
    }
    
}

@end
