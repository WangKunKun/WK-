//
//  WKDeliveryView.m
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKDeliveryView.h"
@interface WKDeliveryView ()

//距离
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
//费用
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;

//费用明显点击按钮
@property (strong, nonatomic) IBOutlet UIImageView *tipDetailIV;

@end


@implementation WKDeliveryView


+ (instancetype)viewFromNIB {
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    WKDeliveryView * view = (WKDeliveryView *)views[0];
    view.widthS = SCREEN_Width;
    return view;
}

- (void)awakeFromNib {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [_tipDetailIV addGestureRecognizer:tap];
    self.isClick = NO;
}

- (void)click:(UITapGestureRecognizer *)tap
{
    if (!self.isClick) {
        return;
    }
    //正常逻辑
    if (self.detailClick) {
        self.detailClick();
    }
}

- (void)setMoney:(NSString *)money
{
    _moneyLabel.text = money;
}

- (void)setDistance:(NSString *)distance
{
    _distanceLabel.text = distance;
}


- (void)setIsClick:(BOOL)isClick
{
    _isClick = isClick;
    _distanceLabel.textColor = isClick ? COLOR(29, 114, 253) : COLOR(189, 189, 189);
    _moneyLabel.textColor = isClick ? COLOR(29, 114, 253) : COLOR(189, 189, 189);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
