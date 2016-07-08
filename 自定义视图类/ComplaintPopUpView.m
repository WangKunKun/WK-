//
//  complaintPop-upView.m
//  Example
//
//  Created by apple on 16/2/23.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "ComplaintPopUpView.h"

@implementation ComplaintPopUpView

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
    
    ComplaintPopUpView * popView = (ComplaintPopUpView *)views[0];
    
    
    return popView;
}

@end
