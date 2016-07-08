//
//  WKAudioManager.m
//  WKCircleAnimationForLoading
//
//  Created by qitian on 16/5/20.
//  Copyright © 2016年 WangKunKun. All rights reserved.
//

#import "WKAudioManager.h"
#include <AudioToolbox/AudioToolbox.h>
#include <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, WKAudioInsertStyle)//音频样式
{
    
    WKAudioInsertStyle_Distance = 0,
    WKAudioInsertStyle_TimeHour,
    WKAudioInsertStyle_TimeMinute,
    WKAudioInsertStyle_TimeSecond
};

@interface WKAudioManager ()<AVAudioPlayerDelegate>

//存放的是短音，运动开始，3，2，1等
@property (nonatomic, strong) NSMutableArray * sounds;

//合成音
@property (nonatomic, strong) NSMutableArray * audios;
//播放合成音
@property (nonatomic, strong) AVAudioPlayer * player;

@end

@implementation WKAudioManager

+ (WKAudioManager *)sharedAudioManager
{
    static WKAudioManager * am = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        am = [[WKAudioManager alloc] init];
        am.sounds = [NSMutableArray array];
        am.audios = [NSMutableArray array];
        [am createAudio];
    });
    return am;
}

- (void)createAudio
{
    NSArray * soundsArr = @[@"11",@"22",@"33",@"运动开始",@"运动暂停",@"运动恢复",@"运动停止"];
    
    NSString * path = [[NSBundle mainBundle] bundlePath];
    
    SystemSoundID wkid;
    for (NSString * soundName in soundsArr) {
        NSString * realName = [soundName stringByAppendingString:@".wav"];
        NSURL *soundfileURL=[NSURL fileURLWithPath:[path stringByAppendingPathComponent:realName]];
        //建立音效对象
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundfileURL, &wkid);
        [self.sounds addObject:@(wkid)];
    }
}

- (void)playSoundWithType:(WKAudioType)type
{
    if(![UserInformationManager getVoiceModel])
        return;
    
    NSNumber * number = _sounds[type];
    AudioServicesPlaySystemSound([number unsignedIntValue]);
}

- (void)playSoundWithKm:(NSUInteger)count time:(NSString *)timeStr
{
    
    if(![UserInformationManager getVoiceModel])
        return;
    
    [self.audios removeAllObjects];
    
    //插入距离前缀
    NSString * tempName = @"road";
    [self.audios  addObject:tempName];
    //插入距离
    [self wkInsertAudioWithNumber:count forStyle:WKAudioInsertStyle_Distance];
    //插入时间前缀
    tempName = @"time";
    [self.audios  addObject:tempName];
    
    //分割时间
    NSArray * timeArr = [timeStr componentsSeparatedByString:@":"];
    //时分秒 有序的
    for (NSUInteger i = 0; i < timeArr.count; i ++) {
        NSString * str = timeArr[i];
        [self wkInsertAudioWithNumber:[str integerValue] forStyle:i+1];
    }
    
    //合并音频
    NSURL * url = [self mergeAudios];

    //合并成功则播放
    if(url)
        [self innerPlayAudioWithPath:url];
}

- (void)wkInsertAudioWithNumber:(NSUInteger)count forStyle:(WKAudioInsertStyle)style
{
    if (count <= 0) {
        return;
    }
    
    NSUInteger qian = count / 1000;
    NSUInteger bai = (count % 1000) / 100;
    NSUInteger shi = (count % 100) / 10;
    NSUInteger ge  = count % 10;
    
    NSString * tempName = nil;
    if (qian > 0) {
        tempName = [NSString stringWithFormat:@"%lu",qian];
        [_audios addObject:tempName];
        [_audios addObject:@"qian"];
        
    }
    
    if (bai > 0) {
        tempName = [NSString stringWithFormat:@"%lu",bai];
        [_audios addObject:tempName];
        [_audios addObject:@"bai"];
        
    }
    
    if (shi > 0) {
        tempName = [NSString stringWithFormat:@"%lu",shi];
        [_audios addObject:tempName];
        [_audios addObject:@"shi"];
        
    }
    
    if (ge > 0) {
        tempName = [NSString stringWithFormat:@"%lu",ge];
        [_audios addObject:tempName];
    }
    
    switch (style) {
        case WKAudioInsertStyle_Distance: {
            [_audios addObject:@"km"];
            break;
        }
        case WKAudioInsertStyle_TimeHour: {
            [_audios addObject:@"hour"];

            break;
        }
        case WKAudioInsertStyle_TimeMinute: {
            [_audios addObject:@"minute"];
            break;
        }
        case WKAudioInsertStyle_TimeSecond: {
            [_audios addObject:@"second"];
            break;
        }
    }
    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //播放回调
    if (flag) {
        if (player.url) {
            NSError * error;
            //删除文件
            [[NSFileManager defaultManager] removeItemAtURL:player.url error:&error];
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
            else
            {
                NSLog(@"删除成功");
            }
        }


    }
}

- (void)innerPlayAudioWithPath:(NSURL *)url
{
    NSError * error;
    
    //播放
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (error) {
        NSLog(@"出错了-%@",[error localizedDescription]);
        return;
    }
    _player.delegate = self;
    [_player prepareToPlay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_player play];
        
    });
}



- (NSURL *)mergeAudios
{
    NSString * path = [[NSBundle mainBundle] bundlePath];
    
    //合并类
    AVMutableComposition *composition = [[AVMutableComposition alloc] init];

    //合并追踪  类型音频 id 只有一个
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    //设置起点
    CMTime insertionPoint = kCMTimeZero;

    //博大精深！！！ 需要慢慢研究
    for (NSString * name in _audios) {
        //所有文件均为wav
        NSString * realName = [name stringByAppendingString:@".wav"];
        //获得源路径
        NSURL *soundfileURL=[NSURL fileURLWithPath:[path stringByAppendingPathComponent:realName]];
        //生成asset
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:soundfileURL options:nil];
        //获得track
        AVAssetTrack *assetTrack = [[avAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        //拼接
        [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, avAsset.duration) ofTrack:assetTrack atTime:insertionPoint error:nil];
        //重设起点
        insertionPoint = CMTimeAdd(insertionPoint, avAsset.duration);

    }
    
    
    
  
    //得到路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    //当初合并的音频 样式只能为m4a
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    exportSession.outputURL = [NSURL fileURLWithPath:[documentsDirectory stringByAppendingFormat: @"/asda.m4a"]];
    //样式对应
    exportSession.outputFileType = AVFileTypeAppleM4A;
    
    __block NSURL * url = nil;
    //信号量，保存存储结束
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            if (AVAssetExportSessionStatusCompleted == exportSession.status) {
                NSLog(@"AVAssetExportSessionStatusCompleted");
                url = exportSession.outputURL;
                
            } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
                NSLog(@"AVAssetExportSessionStatusFailed");
                NSLog(@"%@",exportSession.error );
            } else {
                NSLog(@"Export Session Status: %ld", (long)exportSession.status);
            }
            dispatch_semaphore_signal(semaphore);

        }];
    });
    //等待结束
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //返回url
    return url;
}

@end
