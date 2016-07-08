//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view delay:(NSTimeInterval)time
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    CGFloat delayTime = 0;
    if (view == nil) {
        return;
    }
    

        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = text;
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
        // time秒之后再消失
        [hud hide:YES afterDelay:time];


}

+ (void)showError:(NSString *)error toView:(UIView *)view delay:(NSTimeInterval)time
{
    [self show:error icon:@"error.png" view:view delay:time];

}
+ (void)showSuccess:(NSString *)success toView:(UIView *)view delay:(NSTimeInterval)time
{
    [self show:success icon:@"success.png" view:view delay:time];
}


#pragma mark 默认主window
+ (void)showSuccess:(NSString *)success delay:(NSTimeInterval)time
{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    [self showSuccess:success toView:view delay:time];
}
+ (void)showError:(NSString *)error  delay:(NSTimeInterval)time
{
    UIView * view = [UIApplication sharedApplication].keyWindow;
    [self showError:error toView:view delay:time];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view delay:0.7];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view delay:0.7];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    if (view == nil) {
        return nil;
    }

    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;


}

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view delay:(NSTimeInterval)time
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    if (view == nil) {
        return nil;
    }
        // 快速显示一个提示信息
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.labelText = message;
        // 设置图片
        
        
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        //    hud.dimBackground = YES;
        // time秒之后再消失
        [hud hide:YES afterDelay:time];
        return hud;


}
@end
