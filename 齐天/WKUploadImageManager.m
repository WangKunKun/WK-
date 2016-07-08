//
//  WKUploadImageManager.m
//  QTRunningBang
//
//  Created by MacBook on 16/5/6.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKUploadImageManager.h"
#import "UIImage+WKScreenshots.h"

@interface WKUploadImageManager()

@property (nonatomic, strong) NSString * AccessKey;
@property (nonatomic, strong) NSString * SecretKey;
@property (nonatomic, strong) NSString * endPoint ;


@end

@implementation WKUploadImageManager

+ (WKUploadImageManager *)shardUIManager
{
    static WKUploadImageManager * ui = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ui = [[WKUploadImageManager alloc] init];
        //上传key
        ui.AccessKey = @"TpP6qTRCnUzKPC3c";
        ui.SecretKey = @"0ZXqQAM3cVsfdch031YAgNEQGh3BIT";
        ui.endPoint = @"http://oss.runningbang.com";
    });
    return ui;
}


+ (void)uploadImages:(NSArray <UIImage *>*)images handler:(void(^)(WKUploadImageResult,NSString*))handler
{
    
    WKUploadImageManager * ui = [WKUploadImageManager shardUIManager];
    [ui uploadImages:images handler:handler];
}

- (void )uploadImage:(UIImage *)image handler:(void(^)(WKUploadImageResult,NSString*))handler
{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:self.AccessKey secretKey:self.SecretKey];
    
    OSSClient* client = [[OSSClient alloc]initWithEndpoint:self.endPoint credentialProvider:credential];
    
    //简历上传请求
    
    OSSPutObjectRequest * putrequest=[OSSPutObjectRequest new];
    
    //设置bucketName(固定的)
    
    putrequest.bucketName = @"qitianoss";
    
    
    
    //获取图片宽高
    CGFloat imagewidth=image.size.width;
    CGFloat imageheight=image.size.height;
    
    
    
    //得到一个比例 如果此比例大于1 则不压缩 否则则按照此比例压缩
    CGFloat widthScale = SCREEN_WIDTH / imagewidth;
    
    
    //保证比例
    NSUInteger scaleImageW = widthScale < 1 ? imagewidth * widthScale : imagewidth;
    NSUInteger scaleImageH = widthScale < 1 ? imageheight * widthScale : imageheight;


    
    UIImage * scaleImage = [image compressImage:CGSizeMake(scaleImageW, scaleImageH)];
    
    //设置上传数据 NSData
    
    CGFloat scale = [UserInformationManager getUploadModel] == UploadImageModel_Source ? 1 :  0.5;
    putrequest.uploadingData = UIImageJPEGRepresentation(scaleImage,scale);
    

    NSLog(@"图片实际大小 = %@,比例图片大小 = %@",NSStringFromCGSize(image.size),NSStringFromCGSize(scaleImage.size));
    //构建imagekey 格式: < img_ +  imagewidth + x + imageheight + _iOS_ + md5 + 时间戳 +后缀 >
    NSString* imagekey=[NSString stringWithFormat:@"img_%lux%lu_iOS_%@%f.png",(unsigned long)scaleImageW,(unsigned long)scaleImageH,[QTUtils md5ForString:[QTUtils getDeviceUUID]],[[NSDate date] timeIntervalSince1970]] ;
    
    putrequest.objectKey = [NSString stringWithFormat:@"app/images/ios/%@/%@/%@/%@",[Default single].yearTime,[Default single].yearMonthTime,[Default single].yearMonthDayTime,imagekey];

    
    putrequest.uploadProgress= ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {

    };
    
    OSSTask * putTask=[client putObject:putrequest];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        
        if (task.result) {
            NSLog(@"task.result:%@",task.result);
            
            handler(WKUploadImageResult_Success, [@"http://qitianoss.img-cn-qingdao.aliyuncs.com/" stringByAppendingString:putrequest.objectKey]);
        }
        if (task.error) {
            
            NSLog(@"上传失败, error: %@" , task.error);
            
            handler(WKUploadImageResult_Fail,@"");
        }
        return nil;
    }];

}

- (void)uploadImages:(NSArray <UIImage *>*)images handler:(void(^)(WKUploadImageResult,NSString*))handler
{
    //用于配合执行 异步上传多张图片
//    dispatch_queue_t queue = dispatch_queue_create("WKUploadImageRealStart", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t queueGroup = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block NSMutableArray * failArr = [NSMutableArray array];
    __block NSMutableString * urlStr = [@"" mutableCopy];
    
    
    __block NSUInteger count = 0;
    //实际是串行队列 用信号量控制
    for (NSUInteger i = 0; i < images.count; i ++) {
        UIImage * temp = images[i];
        dispatch_group_async(queueGroup, dispatch_get_global_queue(0,0), ^{
            
            NSLog(@"开始N张");

            [self uploadImage:temp handler:^(WKUploadImageResult result, NSString * url) {
                switch (result) {
                    case WKUploadImageResult_Fail:
                        [failArr addObject:@(i)];
                        break;
                    case WKUploadImageResult_Success:
                        [urlStr appendString:url];
                        [urlStr appendString:@","];
                        count ++;
                        break;
                    default:
                        break;
                }
                dispatch_semaphore_signal(semaphore);
            }];
        });

    }
    
    for (NSUInteger i = 0; i < images.count; i ++) {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

    
    dispatch_group_notify(queueGroup, dispatch_get_global_queue(0,0), ^{

        // 汇总结果
        NSLog(@"WK-------%@",urlStr);
    });
    
    if (failArr.count > 0) {
        handler(WKUploadImageResult_Fail,@"");
    }
    else
    {
        handler(WKUploadImageResult_Success,urlStr);
    }
    

}

@end
