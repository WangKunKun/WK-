//
//  WKPaymentMethodView.m
//  Example
//
//  Created by apple on 16/3/4.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKPaymentMethodBtn.h"

@interface WKPaymentMethodBtn ()

@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectIV;

@property (assign, nonatomic) PaymentMethod style;

@end

@implementation WKPaymentMethodBtn


+ (instancetype)viewFromNIBWithStyle:(PaymentMethod)style {
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    WKPaymentMethodBtn * btn = (WKPaymentMethodBtn *)views[0];
    btn.style = style;
    btn.widthS = SCREEN_Width;
    return btn;
}

- (void)awakeFromNib
{
    self.widthS = SCREEN_Width;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [self addGestureRecognizer:tap];
}

- (void)btnClick:(UITapGestureRecognizer *)tap
{
    if (_delegate && [_delegate respondsToSelector:@selector(paymentMethodBtnClick:)]) {
        [_delegate paymentMethodBtnClick:self];
    }
}

- (void)setStyle:(PaymentMethod)style
{
    _style = style;
    switch (_style) {
        case PaymentMethodWXPay:
            _iconIV.image = [UIImage imageNamed:@"recharge_ico_wechat"];
            _titleLabel.text = @"微信支付";
            break;
        case PaymentMethodAliPay:
            _iconIV.image = [UIImage imageNamed:@"recharge_ico_alipay"];
            _titleLabel.text = @"支付宝支付";
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    _selectIV.highlighted = _selected;
}

@end
