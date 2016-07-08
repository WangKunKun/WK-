//
//  MapAddressView.m
//  Example
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 Monospace Ltd. All rights reserved.
//

#import "MapAddressView.h"
#import "MapNavigationManager.h"

typedef enum : NSUInteger {
    Apple = 0,
    Baidu,
    Google,
    Gaode,
    Tencent
} MapSelect;


@interface MapAddressView ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btn;
//商家名字 OR 送货地址（不是地址就是送货地址四个字）
@property (strong, nonatomic) IBOutlet UILabel *storeLabel;
//商家详细地址 OR 送货详细地址（实际地址）
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) NSString * storeAddress;
@property (strong, nonatomic) NSString * endAddress;


@end

static MapAddressView * mav = nil;

@implementation MapAddressView


+ (instancetype)viewFromNIB{
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray<UIView *> *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
//做成单例 才不会泡泡多
    if (!mav) {
        mav = (MapAddressView *)views[0];
        mav.navState = 0;
        mav.isClick = YES;
    }
    
    
    return mav;
}


- (void)awakeFromNib {
    self.image = [UIImage imageNamed:@"navigation_allbg"] ;

    
}

- (IBAction)navClick:(UIButton *)sender {
    NSString * startStr = _navState == 0 ? USERINFOManager.currentFullLoc : _storeAddress;
    NSString * endStr = _endAddress;
    [MapNavigationManager showSheetWithCity:USERINFOManager.currentCity start:startStr end:endStr];
}


- (void)setStoreName:(NSString *)storeName
{
    _storeLabel.text = storeName;
}

- (void)setAddress:(NSString *)address
{
    NSString * text = address;
    if(address.length >= 20)
        text = [address substringToIndex:19];
    _addressLabel.text = text;
    _endAddress = address;
    if (_navState == 0) {
        _storeAddress = address;
    }

}




- (void)setIsClick:(BOOL)isClick
{
    _btn.enabled = isClick;
}
@end
