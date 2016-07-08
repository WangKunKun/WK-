//
//  QueryBtn.m
//  Example
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "QueryBtn.h"

@interface QueryBtn ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftIVleadConstraint;

@property (strong, nonatomic) IBOutlet UILabel *hintLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIV;
@property (strong, nonatomic) IBOutlet UIImageView *locationIV;
@property (strong, nonatomic) IBOutlet UILabel *integralLabel;
@property (strong, nonatomic) IBOutlet UIImageView *separateLine;

//原本是10
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowIVWidth;
//原本是8
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowIVLeading;
//原本14
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *arrowIVHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationIVTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationBottom;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationIVHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *locationIVWidth;


//投诉样式中作为计数开关
@property (assign, nonatomic) NSUInteger complaintCount;
@end

@implementation QueryBtn

+ (instancetype)viewFromNIBWithStyle:(WKQueryBtnStyle)style {
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    QueryBtn * btn = (QueryBtn *)views[0];
    btn.style = style;
    btn.isClose = YES;
    
    btn.complaintCount = 0;
    
    return btn;
}

- (void)awakeFromNib {
    // 视图内容布局
    
    
    _hintLabel.textColor = COLOR(51, 51, 51);
    UITapGestureRecognizer * oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
    [self addGestureRecognizer:oneTap];
}

- (void)setStyle:(WKQueryBtnStyle)style
{
    _style = style;
    switch (_style) {
        case WKQueryBtnStyleHint:
        {
            self.leftIVleadConstraint.constant = 8;
            self.arrowIV.hidden = YES;
            self.userInteractionEnabled = NO;
            self.hintLabel.text = @"远距离订单不在接单范围内，无法接单。";
            self.locationIV.image = [UIImage imageNamed:@"task_ico_prompt.png"];
            self.integralLabel.hidden = YES;
            
            
        }
            
            break;
        case WKQueryBtnStyleHintAndClick:
        {
            
            self.leftIVleadConstraint.constant = 8;
            self.userInteractionEnabled = YES;
            self.hintLabel.text = @"您的附近没有订单了吗？看看其它地方！";
            self.locationIV.image = [UIImage imageNamed:@"task_ico_position"];
            self.integralLabel.hidden = YES;
//            self.arrowIV.image = [UIImage imageNamed:@"coffers_img_designator"];
//            self.arrowIV.backgroundColor = [UIColor blueColor];

        }
            break;
            
        case WKQueryBtnStyleExchange:
        {
            self.leftIVleadConstraint.constant = 8;
            self.locationIV.image = [UIImage imageNamed:@"exchange_ico"];

            self.arrowIV.hidden = YES;
            self.arrowIVLeading.constant = 0;
            self.arrowIVWidth.constant = 0;
            
            self.userInteractionEnabled = NO;
            self.hintLabel.text = @"您的当前积分:";
            self.integralLabel.hidden = NO;
            

            
        }
            break;
        case WKQueryBtnStyleMargin:
        {
            //箭头图标
            self.arrowIV.image = [UIImage imageNamed:@"coffers_img_designator"];
            
            
            //最左边视图
            self.leftIVleadConstraint.constant = 8;
            self.locationIVHeight.constant = 15;
            self.locationIVWidth.constant = 15;
            self.locationIVTop.constant = 12.5;
            self.locationBottom.constant = 12.5;
            self.locationIV.image = [UIImage imageNamed:@"coffers_ico"];

            //是否可点击
            self.userInteractionEnabled = YES;

            
            self.hintLabel.text = @"当前未结算保证金:";
            self.hintLabel.textColor = [UIColor whiteColor];
            
            //积分和金额按钮
            self.integralLabel.hidden = NO;
            self.integralLabel.text = @"2025(元)";
            self.integralLabel.textColor = [UIColor whiteColor];
            //分割线
            self.separateLine.hidden = YES;
            //背景色
            self.backgroundColor = [UIColor clearColor];
            


            
        }
            break;
        case WKQueryBtnStyleMarginDetail:
        {
            self.leftIVleadConstraint.constant = 8;
            self.locationIVHeight.constant = 15;
            self.locationIVWidth.constant = 15;
            self.locationIVTop.constant = 12.5;
            self.locationBottom.constant = 12.5;
            
            self.arrowIV.hidden = YES;
            self.arrowIVLeading.constant = 0;
            self.arrowIVWidth.constant = 0;
            
            self.userInteractionEnabled = NO;
            self.hintLabel.text = @"当前未结算保证金:";
            self.locationIV.image = [UIImage imageNamed:@"coffers_ico_deduction"];
            self.integralLabel.hidden = NO;
            self.integralLabel.text = @"2025(元)";
            self.hintLabel.textColor = COLOR(51, 51, 51);
            self.integralLabel.textColor = COLOR(29, 114, 254);
            self.integralLabel.font = [UIFont italicSystemFontOfSize:13];
            self.backgroundColor = [UIColor clearColor];
            self.separateLine.hidden = YES;
            


        }
            break;
            
        case WKQueryBtnStyleComplaint:
        {
            self.integralLabel.hidden = YES;

            self.locationIV.image = [UIImage imageNamed:@"task_ico_prompt.png"];
            self.arrowIVWidth.constant = 12.5;
            self.arrowIVHeight.constant = 8;
            self.arrowIV.image = [UIImage imageNamed:@"complaint_btn_indicator_dn"];
            
            self.leftIVleadConstraint.constant = 8;
            self.hintLabel.text = @"配送中有问题，客服打不通怎么办?";
        }
            break;
        default:
            break;
    }
    
    

    
}




- (void)setIsClose:(BOOL)isClose
{
    _isClose = isClose;
    
    NSString * imageStr = _isClose ? @"complaint_btn_indicator_dn" : @"complaint_btn_indicator_up";
    if (_style == WKQueryBtnStyleComplaint) {
        self.arrowIV.image = [UIImage imageNamed:imageStr];
    }

}

- (void)btnClick:(UIGestureRecognizer *)tap
{
    
    NSLog(@"qBtn 被点击");
    if (self.click) {
        self.click();
    }
}

- (void)setIntegral:(NSString *)integral
{
    _integral = integral;
    self.integralLabel.text = [NSString stringWithFormat:@"%@",integral];
}

@end
