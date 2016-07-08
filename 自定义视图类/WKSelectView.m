//
//  WKSelectView.m
//  Example
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKSelectView.h"

@interface WKSelectView ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WKSelectView

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
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    
    WKSelectView * view = (WKSelectView *)views[0];

    return view;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick
{
    if (self.click) {
        self.click();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
}

@end
