//
//  WKShareSDKManager.m
//  QTRunningBang
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 qitianxiongdi. All rights reserved.
//

#import "WKShareSDKManager.h"
#import "NSObject+Toast.h"

//第三方登录以及分享
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

#import <MOBFoundation/MOBFoundation.h>
#import <MOBFoundation/MOBFImageService.h>
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
@implementation WKShareSDKManager

+ (WKShareSDKManager *)shardSDKManager
{
    static WKShareSDKManager * mm = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mm = [[WKShareSDKManager alloc] init];
    });
    return mm;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initShareSDK];
    }
    return self;
}

//shareSdk相关,包括分享和第三方登陆的初始化
-(void)initShareSDK
{    
    [ShareSDK registerApp:@"e73069e19314"
          activePlatforms:@[
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformSubTypeQZone:
                 
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
                 //
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx778084ca9ed0fef3"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
//                 1104900447
//                 qq41db715f
             case SSDKPlatformTypeQQ:
             case SSDKPlatformSubTypeQZone:
                 [appInfo SSDKSetupQQByAppId:@"1104900447"
                                      appKey:@"g1zQcB9wtPpNb8cR"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
                 
             default:
                 break;
         }
     }];
    
}




- (void)shareWithPlatform:(WKShareModel)type text:(NSString *)text images:(NSArray *)images urlStr:(NSString *)urlStr title:(NSString *)title block:(Succeed)block imagesModel:(WKImagesModel)im
{
    SSDKPlatformType temp[5] = {SSDKPlatformSubTypeWechatSession,SSDKPlatformSubTypeWechatTimeline,SSDKPlatformSubTypeQQFriend,SSDKPlatformSubTypeQZone,SSDKPlatformSubTypeWechatFav};
    SSDKPlatformType shareType = temp[type];
    NSMutableArray * imageArr = [NSMutableArray array];
    
    if (im == WKImagesModel_Source) {
        
        CGFloat maxCount = shareType >= 2 ? 5000.0 : 30000.0;
        CGFloat imageMaxSize = maxCount * 8;
        for (UIImage * temp in images) {
            NSData * imageData = UIImageJPEGRepresentation(temp, 1.0);
            NSLog(@"WKSoruceImageData ===== %lu",imageData.length);
            if(imageData.length > imageMaxSize)
            {
                CGFloat scale = imageMaxSize / imageData.length;
                NSData * scaleImageData = UIImageJPEGRepresentation(temp, scale);
                UIImage * image= [UIImage imageWithData:scaleImageData];
                NSLog(@"scale = %lf WKScaleImageData ===== %lu",scale,scaleImageData.length);
                
                [imageArr addObject:image];
            }
            else
                [imageArr addObject:temp];
        }
    }
    else
    {
        
        for (NSString * imageUrlStr in images) {
            //判断是否包含中卫
            NSString * str = imageUrlStr;
            if (![NSURL URLWithString:str]) {
                str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            [imageArr addObject:str];
            //中文则转换
            //生成新字符串
        }
        
        
    }

    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text
                                     images:imageArr
                                        url:[NSURL URLWithString:urlStr]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (error != nil) {
            [self showMessage:[error userInfo][@"error_message"]];
        }
        else{
            
            [self showMessage:state == SSDKResponseStateSuccess ? @"分享成功" : @"分享取消"];
            if (block) {
                block();
            }
        }
    }];

}

- (void)shareWithPlatform:(WKShareModel)type text:(NSString *)text images:(NSArray *)images urlStr:(NSString *)urlStr title:(NSString *)title block:(Succeed)block
{

    [self shareWithPlatform:type text:text images:images urlStr:urlStr title:title block:block imagesModel:WKImagesModel_Source];
    

}

- (void)shareWithPlatform:(WKShareModel)type
{
    NSArray * array = @[[UIImage imageNamed:@"01-我的_spec"]];
    [self shareWithPlatform:type text:@"快来邻动跑起来吧" images:array urlStr:@"www.baidu.com" title:@"我是标题" block:nil];
}

- (void)loginWithPlatform:(WKThridLoginModel)type block:(Succeed)block
{
//    [MBProgressHUD showMessag:@"登录中" toView:KEYWINDOW];
    
    //初始化数据
    SSDKPlatformType temp[2] = {SSDKPlatformTypeQQ,SSDKPlatformTypeWechat};
    
    
    SSDKPlatformType loginType = temp[type];

    
    [SSEThirdPartyLoginHelper loginByPlatform:loginType onUserSync:^(SSDKUser *user, SSEUserAssociateHandler associateHandler) {
           NSLog(@"SSDKUser:%@",user);
           NSLog(@"SSDKUser.uid:%@",user.uid);
           associateHandler (user.uid, user, user);
           
           
           NSLog(@"%@",user.nickname);
//           NSLog(@"%@ WeChat原始数据 :%@",user.icon,user.rawData); user.rawData[@"unionid"]
        
        switch (type) {
            case WKThridLogin_QQ:
            {
                
                [QTRequestApi userLoginWithUnionid:user.uid openId:@"" nickName:user.nickname sex:                                       [NSString stringWithFormat:@"%lu",user.gender] headUrl:user.icon Type:@"3" Success:^(REQUEST_SUCCESS_TYPE type, id response, id data, id code) {
//                    [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
                    
                    
                    if (block) {
                        block();
                    }
                    
//                    [self  showMessage:@"登录成功"];
                    
                } Fail:^(REQUEST_FAILED_TYPE type, NSInteger errorcode, id errorMsg, id serverRespons) {
                    [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
                    [self showMessage:@"登录失败,请重试"];
                }];
                
            }
                break;
            case WKThridLogin_Wechat:
            {
                [QTRequestApi userLoginWithUnionid:user.rawData[@"unionid"] openId:@"" nickName:user.nickname sex:                                       [NSString stringWithFormat:@"%lu",user.gender] headUrl:user.icon Type:@"1" Success:^(REQUEST_SUCCESS_TYPE type, id response, id data, id code) {
                    [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
                    
                    
                    if (block) {
                        block();
                    }
                    
                    [self  showMessage:@"登录成功"];
                    
                } Fail:^(REQUEST_FAILED_TYPE type, NSInteger errorcode, id errorMsg, id serverRespons) {
                    [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
                    [self showMessage:@"登录失败,请重试"];
                }];
                
            }
                break;
                
            default:
                break;
        }
                                       
        
        }onLoginResult:^(SSDKResponseState state, SSEBaseUser *user, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:KEYWINDOW animated:YES];
            switch (state) {
                case SSDKResponseStateCancel:
                {
                    
                    [self  showMessage:@"登录取消"];
                }
                    break;
                case SSDKResponseStateFail:
                {
                    [self showMessage:@"登录失败"];
                    break;
                }
                case SSDKResponseStateSuccess:
                {
                    
                    break;
                }
                default:
                    break;
            }
            
        }];
}

@end
