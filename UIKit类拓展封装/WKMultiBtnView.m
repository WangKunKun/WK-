//
//  WKMultiBtnView.m
//  Example
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKMultiBtnView.h"
@interface WKMultiBtnView ()

@property (nonatomic, strong) NSMutableArray * offsetXArray;
@property (nonatomic, strong) NSMutableArray * btnArray;
@property (nonatomic, strong) UIImageView * blueLine;

@property (nonatomic, assign) WKMultiBtnViewModel model;

@end

@implementation WKMultiBtnView

+ (WKMultiBtnView *)multiBtnViewWithTitleArray:(NSArray *)titleArray
{
    return [self multiBtnViewWithTitleArray:titleArray model:WKMultiBtnViewModelForMyOrderVC];
}

+ (WKMultiBtnView *)multiBtnViewWithTitleArray:(NSArray *)titleArray model:(WKMultiBtnViewModel)model
{
    WKMultiBtnView * temp = [[WKMultiBtnView alloc] init];
    [temp setInterFaceWithArray:titleArray];
    temp.model = model;
    return temp;
}

- (void)setInterFaceWithArray:(NSArray *)titleArray
{
    _offsetXArray = [NSMutableArray array];
    _btnArray = [NSMutableArray array];
    self.bounds = CGRectMake(0, 0, SCREEN_Width, 41);
    CGFloat btnWidth = (SCREEN_Width - (titleArray.count - 1)) / titleArray.count;
    CGFloat lineWidth = 1;
    CGFloat offsetX = 0;
    for (NSUInteger i = 0; i < titleArray.count; i ++) {
        
        [_offsetXArray addObject:[NSNumber numberWithFloat:offsetX]];
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, 0, btnWidth, 40)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self addSubview:btn];
        btn.tag = STARTTAG + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:btn.titleLabel.font.pointSize - 2];
        [_btnArray addObject:btn];

        
        offsetX += btnWidth;
        
        if (i == titleArray.count - 1) {
            break;
        }
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 10, lineWidth, 20)];
        line.image = [UIImage imageNamed:@"gray_vertical_split"];
        [self addSubview:line];
        
        offsetX += lineWidth;

    }
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 1)];
    line.image = [UIImage imageNamed:@"gray_horizontal_split"];
    [self addSubview:line];

    _blueLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, btnWidth, 1)];
    _blueLine.image = [UIImage imageNamed:@"blue_horizontal_split"];
    [self addSubview:_blueLine];
    
    self.backgroundColor = COLOR(230, 230, 230);
    
    [self btnClick:_btnArray[0]];
    
}

//0起始
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _blueLine.leftS = [_offsetXArray[selectedIndex] floatValue];
    for (UIButton * tempBtn in _btnArray) {
       tempBtn.selected = [_btnArray indexOfObject:tempBtn] == selectedIndex;
    }
}

- (void)btnClick:(UIButton *)btn
{
    self.selectedIndex = btn.tag - STARTTAG;
    if (self.btnClick) {
        self.btnClick(btn.tag - STARTTAG);
    }
}

- (void)setModel:(WKMultiBtnViewModel)model
{
    _model = model;
    switch (model) {
        case WKMultiBtnViewModelForMyOrderVC:
            for (UIButton * btn in _btnArray) {
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            }
            break;
        case WKMultiBtnViewModelForStartVC:
            self.backgroundColor = [UIColor whiteColor];
            for (UIButton * btn in _btnArray) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:FONT_BLUE forState:UIControlStateSelected];
            }
            break;
        default:
            break;
    }
}


@end
