//
//  NavigationBar.m
//  Example
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "NavigationBar.h"

@interface NavigationBar ()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
@property (strong, nonatomic) UIView * contentView;

@property (strong, nonatomic) IBOutlet UIImageView *separateLine;
@property (strong, nonatomic) IBOutlet UIImageView *arrowIV;

@end

@implementation NavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)leftBtnClick:(UIButton *)sender {
    NSLog(@"left");
    if (_leftClick) {
        self.leftClick();
    }

}

- (IBAction)rightBtnClick:(UIButton *)sender {
    NSLog(@"right");
    if (_rightClick) {
        self.rightClick();
    }
}

+ (instancetype)viewFromNIB{
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    NavigationBar * navBar = (NavigationBar *)views[0];
    navBar.backgroundColor = [UIColor clearColor];
    navBar.separateLine.hidden = YES;
    return navBar;
}

-(void)setWkTitle:(NSString *)wkTitle
{
    self.titleLabel.text = wkTitle;
}

- (void)setWkRightStr:(NSString *)wkRightStr
{
    [self.rightBtn setTitle:wkRightStr forState:UIControlStateNormal];
}

- (void)setIsRightBtnHidde:(BOOL)isRightBtnHidde
{
    _rightBtn.hidden = isRightBtnHidde;
}

@end
