//
//  WKAddTipsView.m
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKAddTipsView.h"


@interface WKAddTipsView ()<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;
//确认按钮
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (strong, nonatomic) NSMutableArray<UIButton *> * btnArray;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
//底部
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

@property (assign, nonatomic) AddViewModel model;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;

@property (strong, nonatomic) UIButton * selectButton;

@end

@implementation WKAddTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)viewFromNIB{
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    return [self viewFromNIBWithStyle:AddViewModelTips];
}

+(instancetype)viewFromNIBWithStyle:(AddViewModel)model
{
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    WKAddTipsView * view = (WKAddTipsView *)views[0];
    view.contentViewBottom.constant  =  -view.contentView.heightS;
    view.heightS = SCREEN_Height;
    view.model = model;
    
    return view;
}

#define BTNSTARTTAG (50)

- (void)setModel:(AddViewModel)model
{
    _model = model;
    //后缀
    NSString * suffixStr = _model == AddViewModelHour ? @"小时" : @"元";
    //基值
    NSUInteger base = _model == AddViewModelHour ? 1 : 5;
    
    NSString * title = _model == AddViewModelHour ? @"选择服务时长" : @"增加消费";
    
    _titleLabel.text = title;
    _unitLabel.text = suffixStr;
    _moneyTextField.text = [NSString stringWithFormat:@"%lu",base];
    _btnArray = [NSMutableArray array];
    //装btn，根据tag装
    for (NSUInteger i = BTNSTARTTAG; i < BTNSTARTTAG + 4; i ++) {
        [_btnArray addObject:[_contentView viewWithTag:i]];
    }
    for (UIButton * btn in _btnArray) {
        [btn setTitle:[NSString stringWithFormat:@"%lu%@",(btn.tag - BTNSTARTTAG + 1) * base,suffixStr] forState:UIControlStateNormal];
        [btn setTitle:[NSString stringWithFormat:@"%lu%@",(btn.tag - BTNSTARTTAG + 1) * base,suffixStr] forState:UIControlStateSelected];

    }
    
    [self moneyBtnClick:_btnArray[0]];
}


- (void)awakeFromNib
{

    
    _moneyTextField.delegate = self;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.bgView addGestureRecognizer:tap];
    self.hidden = YES;
}

- (void)tapClick
{
    self.show = NO;
}
- (IBAction)moneyBtnClick:(UIButton *)sender {
    
    
    if ([sender isEqual:_selectButton] && sender.selected) {
        _selectButton.selected = NO;
        //并且
        _moneyTextField.text = @"0";
        return;
    }
    
    
    NSUInteger base = _model == AddViewModelHour ? 1 : 5;
    
    _moneyTextField.text = [NSString stringWithFormat:@"%lu",(sender.tag - BTNSTARTTAG + 1) * base];
    for (UIButton * btn in _btnArray) {
        btn.selected = btn.tag == sender.tag;
    }
    
    _selectButton = sender;

    
}
- (IBAction)okBtnClick:(UIButton *)sender {
    self.show = NO;
    [self endEditing:YES];

    if (self.click) {
        
//        NSString * suffixStr = _model == AddViewModelHour ? @"小时" : @"元";
        
        
        self.click([NSString stringWithFormat:@"%@",_moneyTextField.text]);
    }
    NSLog(@"确认");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _contentViewBottom.constant  = KEYBOARDHEIGHT;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _contentViewBottom.constant  = 0;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange tempRange = [@"0123456789" rangeOfString:string];
    
    NSUInteger limit =  _model == AddViewModelHour ? 1 : 2;

    
    
    return (tempRange.length > 0 && textField.text.length <= (limit - 1))  || string.length == 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)setShow:(BOOL)show
{
    _show = show;
    //显示之前先不隐藏
    if (show) {
        self.hidden = NO;
    }
    _contentViewBottom.constant  = _show ? 0 : - _contentView.heightS;
    CGFloat alpha = show ? 0.5 : 0;
    
    NSLog(@"bottom = %lf, alpha = %lf",_contentViewBottom.constant,alpha);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        [self.contentView layoutIfNeeded];
        _bgView.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:alpha];
    } completion:^(BOOL finished) {
        if (finished && !_show) {
            //隐藏之后不显示
            self.hidden = YES;
        }
    }];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
