//
//  WKServerCardView.m
//  Example
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "WKServerCardView.h"
#import "ServerDetailModel.h"

@interface WKServerCardView ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *oneLabel;
@property (strong, nonatomic) IBOutlet UILabel *twoLabel;
@property (strong, nonatomic) IBOutlet UILabel *threeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *headIV;
@property (strong, nonatomic) IBOutlet UIImageView *VBGIV;

@property (strong, nonatomic) ServerDetailModel * model;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VBGIVWidth;

@property (strong, nonatomic) NSArray<UILabel *> * labelArray;
@property (strong, nonatomic) NSArray<UIImage *> * imageArray;


@end


#define THREE 155
#define TWO 120
#define ONE 85

@implementation WKServerCardView

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
    
    WKServerCardView * view = (WKServerCardView *)views[0];
    return view;
}

- (void)setInterFaceWithModel:(ServerDetailModel *)model
{
    _model = model;
    _nameLabel.text = model.serverName;
    _scoreLabel.text = [NSString stringWithFormat:@"(评分 %.1lf分)",[model.serverScore floatValue]];
    _remarkLabel.text = model.serverDescription;
    _headIV.image = model.headImage;
    _headIV.layer.cornerRadius = 5;
    
    
    
    _imageArray = @[[UIImage imageNamed:@"one_transportation"],[UIImage imageNamed:@"two_transportation"],[UIImage imageNamed:@"three_transportation"]];
    _labelArray = @[_twoLabel,_oneLabel,_threeLabel];
    
    NSUInteger count = model.vehicleArray.count;
    

    [self setVehicle:count];
    
    

}
//??? 数据问题？
#warning 问题
- (void)setVehicle:(NSUInteger)count
{
    CGFloat width[3] = {ONE,TWO,THREE};
    
    NSUInteger index = count == 0 ? 0 : count - 1;
    

    _VBGIVWidth.constant = width[index];
    _VBGIV.image = _imageArray[index];
    for (NSUInteger i = 0;i < count;i ++) {
        _labelArray[i].text = _model.vehicleArray[i];
        _labelArray[i].hidden = NO;
    }
    
}

- (void)awakeFromNib
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick
{
    if (self.click) {
        self.click(_model.serverID);
    }
}

@end
