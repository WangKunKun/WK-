//
//  WKAudioManager.h
//  WKCircleAnimationForLoading
//
//  Created by qitian on 16/5/20.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WKAudioType)//音频样式
{
   
    WKAudioType_CountDowOne = 0,
    WKAudioType_CountDowTwo,
    WKAudioType_CountDowThree,
    WKAudioType_SportStart,
    WKAudioType_SportPause,
    WKAudioType_SportResume,
    WKAudioType_SportStop
};

@interface WKAudioManager : NSObject


+ (WKAudioManager *)sharedAudioManager;

//播放音效
- (void)playSoundWithType:(WKAudioType)type;

//播放合成音乐
//km 以公里为单位 timestr 样式为 6:10:30 时:分:秒
- (void)playSoundWithKm:(NSUInteger)count time:(NSString *)timeStr;
@end
