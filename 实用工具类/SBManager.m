//
//  SBManager.m
//  Example
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 Monospace Ltd. All rights reserved.
//

#import "SBManager.h"

@implementation SBManager

+ (SBManager *)sharedSBManager
{
    static SBManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SBManager alloc] init];
    });
    return manager;
}


- (void)storyboardWithName:(NSString *)sbName
              vcIdentifier:(NSString *)vcIdentifier
                     isNav:(BOOL)isNav
                 presentVC:(UIViewController *)presnetVC
{
    UIViewController *vc  = [self getVCWithVCIdentifier:vcIdentifier SBName:sbName];
    UIViewController *nav = isNav ? [[UINavigationController alloc] initWithRootViewController:vc] : nil;
    [presnetVC presentViewController:(nav == nil ? vc : nav) animated:YES completion:nil];
}


- (UIViewController *)getVCWithVCIdentifier:(NSString *)vcIdentifier SBName:(NSString *)sbName
{
    UIStoryboard *board   = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *vc  = [board instantiateViewControllerWithIdentifier:vcIdentifier];
    return vc;
}


//nav 推送 vc
- (void)storyboardWithName:(NSString *)sbName
              vcIdentifier:(NSString *)vcIdentifier
                    pushVC:(UINavigationController *)pushVC
                 delayTime:(CGFloat)time
{
    if ([vcIdentifier isEqualToString:@""]) {
        return ;
    }
    UIViewController *vc  = [self getVCWithVCIdentifier:vcIdentifier SBName:sbName];
    [pushVC pushViewController:vc animated:YES];
    
}

/**
 *  通过sb获得vc进行推送 —— 均在主线程使用模态推送
 *
 *  @param sbName       故事板标识
 *  @param vcIdentifier 控制器标识
 *  @param isNav        是否包含nav
 *  @param presentVC    推送主体
 *  @param time         推送延时时长——用户体验平滑度
 */
- (void)storyboardWithName:(NSString *)sbName
              vcIdentifier:(NSString *)vcIdentifier
                     isNav:(BOOL)isNav
                 presentVC:(UIViewController *)presnetVC
                 delayTime:(CGFloat)time
{
    
    if ([vcIdentifier isEqualToString:@""]) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self storyboardWithName:sbName vcIdentifier:vcIdentifier isNav:isNav presentVC:presnetVC];
    });
}



@end
