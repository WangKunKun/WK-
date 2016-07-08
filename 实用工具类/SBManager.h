//
//  SBManager.h
//  Example
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBManager : NSObject

+(SBManager *) sharedSBManager;

- (void)storyboardWithName:(NSString *)sbName
              vcIdentifier:(NSString *)vcIdentifier
                     isNav:(BOOL)isNav
                 presentVC:(UIViewController *)presnetVC
                 delayTime:(CGFloat)time;

- (void)storyboardWithName:(NSString *)sbName
              vcIdentifier:(NSString *)vcIdentifier
                    pushVC:(UINavigationController *)pushVC
                 delayTime:(CGFloat)time;

- (UIViewController *)getVCWithVCIdentifier:(NSString *)vcIdentifier SBName:(NSString *)sbName;
@end
