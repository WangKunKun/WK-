//
//  Tools.m
//  UICollectionView
//
//  Created by apple on 15/11/4.
//  Copyright © 2015年 王琨. All rights reserved.
//

#import "Tools.h"
#import <Photos/Photos.h>
@interface Tools()


@end

@implementation Tools



+ (Tools *)sharedTools
{
    static Tools * tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [Tools new];
        [tools getImagesForPhotoAblum];
    });
    
    return tools;
}


- (void)getImagesForPhotoAblum
{

    
    // 获得相机胶卷的图片
    PHFetchResult<PHAssetCollection *> *collectionResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult1) {
        NSLog(@"%@",collection.localizedTitle);
        if (![collection.localizedTitle isEqualToString:@"Camera Roll"]) continue;
        [self searchAllImagesInCollection:collection];
        break;
    }
    
}

//获得图片
- (void)searchAllImagesInCollection:(PHAssetCollection *)collection
{
    PHImageRequestOptions * imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = NO;
    
    NSLog(@"相册名字:%@",collection.localizedTitle);
    PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    for (PHAsset * asset in assetResult) {
        if (PHAssetMediaTypeImage != asset.mediaType) continue; //过滤非图片
        
        //图片原尺寸
        CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        
        if (nil == self.myImages) {
            _myImages = [NSMutableArray array];
        }

        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [_myImages addObject:result];
        }];
        
    }
    
}

@end
