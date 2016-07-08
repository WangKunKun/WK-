//
//  WKCostDetailView.m
//  Example
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKCostDetailView.h"
#import "CostDetailCell.h"

#define TABLEVIEWHEIGHT 144
@interface WKCostDetailView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
//金钱图标
@property (strong, nonatomic) IBOutlet UIImageView *iconIV;

@property (strong, nonatomic) IBOutlet UIImageView *line;
//用于显示和隐藏
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;
@property (strong, nonatomic) IBOutlet UIView *topView;
//初始220
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconIVBottom;

@end

@implementation WKCostDetailView


+ (instancetype)viewFromNIB{
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    WKCostDetailView * view = (WKCostDetailView *)views[0];
    [view setInterFace];
    view.contentViewBottom.constant = - (view.contentView.heightS + view.iconIV.heightS / 2.0);
    view.iconIVBottom.constant = - view.iconIV.heightS;
    view.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0];
    
    view.heightS = SCREEN_Height;
    
    return view;
}

-(void)awakeFromNib
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [self.topView addGestureRecognizer:tap];
    self.hidden = YES;
}

- (void)click
{
    self.show = NO;
}

- (void)setInterFace
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_line.leftS, _line.bottomS, _line.widthS, TABLEVIEWHEIGHT)];
    [self.contentView addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CostDetailCell" bundle:nil] forCellReuseIdentifier:@"CostDetailCell"];

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

//默认为3
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    if (_datasource == nil) {
        return 0;
    }
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"CostDetailCell";
    CostDetailCell * cell = (CostDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title = _datasource[indexPath.row][@"title"];
    cell.money = _datasource[indexPath.row][@"price"];
    return cell;
}

- (void)setDatasource:(NSArray *)datasource
{
    _datasource = datasource;
    [_tableView reloadData];
}

- (void)setShow:(BOOL)show
{
    _show = show;
    //显示之前先不隐藏
    if (show) {
        self.hidden = NO;
    }

    
    self.contentViewBottom.constant = show ? 0 : - (self.contentView.heightS + self.iconIV.heightS / 2.0) ;
    self.iconIVBottom.constant = show ? 220 : - self.iconIV.heightS;
    CGFloat alpha = show ? 0.5 : 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:alpha];
    } completion:^(BOOL finished) {
        if (finished && !show) {
            //隐藏之后不显示
            self.hidden = YES;
        }
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
