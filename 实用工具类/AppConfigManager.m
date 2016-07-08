//
//  AppConfigManager.m
//  xinhui_dongjiao
//
//  Created by liuyang on 14-2-25.
//  Copyright (c) 2014年 liuyang. All rights reserved.
//

#import "AppConfigManager.h"
#include <sys/param.h>
#include <sys/mount.h>
#import "ICFileManager.h"


void GetDiskFreeSpaceEx(long long *freespace)
{
    struct statfs buf;
    *freespace = 0;
    //if(statfs("/", &buf) >= 0)
	
	if(statfs("/private/var", &buf) >= 0)
	{
        *freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
}
void GetDiskTotalSpaceEx(long long *totalspace)
{
    struct statfs buf;
    
    *totalspace = 0;
	//if(statfs("/", &buf) >= 0)
    if(statfs("/private/var", &buf) >= 0)
	{
        *totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
}


@implementation AppConfigManager

#pragma mark - 获得目录字节数
+ (unsigned long long) countByteWithFilePath:(NSString*)filepath
{
	if( ![[NSFileManager defaultManager] fileExistsAtPath:filepath]||filepath==nil )
		return -1;
	unsigned long long totalSize = 0;
	
	
	NSFileManager * fileManager = [[NSFileManager alloc] init];
	NSDirectoryEnumerator * e = [fileManager enumeratorAtPath:[AppConfigManager filePathForDocument:nil]];
    NSString  * file;
    while ((file = [e nextObject]))
    {
        NSDictionary * attributes = [e fileAttributes];
        
        NSNumber * fileSize = [attributes objectForKey:NSFileSize];
        
        totalSize += [fileSize unsignedLongLongValue];
    }
   	// 获得该目录下文件以及文件夹列表
	// [FileEngine getByteWithSubPath:path totalBytes:&count];
	return totalSize;
}

#pragma mark - 清理数据
+(void) clearLocalCache:(BOOL)isClearAll
{
    NSError * error;
    NSString * filepath = [AppConfigManager filePathForDocument:@"/"];
    
    NSArray * array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filepath error:&error];
    for ( int i=0; i<[array count]; i++)
    {
        NSString * stringItem = [array objectAtIndex:i];
        if( stringItem&&[stringItem isKindOfClass:[NSString class]] )
        {
            NSString * newfilePath = [filepath stringByAppendingFormat:@"/%@",stringItem];
            
            //            NSLog(@"file:%@",newfilePath);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:newfilePath]
                && !([stringItem isEqualToString:@"resource"]
                     || [stringItem hasSuffix:@".plist"]
                     || [stringItem hasSuffix:@".db"]))
            {
                //NSLog(@"-----delete----");
                [[NSFileManager defaultManager] removeItemAtPath:newfilePath error:nil];
            }
        }
    }
}


#pragma mark - 属性文件

+ (void)removePropertyFromConfigFile:(NSString*)key
{
    NSDictionary* dictionary = [AppConfigManager readConfigDictionary];
    if (dictionary) {
        if ([dictionary objectForKey:key]) {
            NSMutableDictionary *newDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
            [newDictionary removeObjectForKey:key];
            [AppConfigManager saveConfigDictionary:newDictionary];
        }
    }
}

+ (void)setPropertyIntoConfigFile:(NSString*)key value:(NSString*)value
{
    
    NSString * pfConfigfilePath = [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@",APP_CONFIG_FILE]];
	if (![[NSFileManager defaultManager] fileExistsAtPath:pfConfigfilePath]){
		[AppConfigManager writeDictionaryTolist:[NSMutableDictionary dictionary] listFilepath:pfConfigfilePath];
    }
    
    NSDictionary* dictionary = [AppConfigManager readConfigDictionary];
    NSMutableDictionary *newDictionary = nil;
    if (dictionary) {
        newDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        
    }
    else
    {
        newDictionary = [NSMutableDictionary dictionary];
        
    }
    [newDictionary setObject:value forKey:key];
    [AppConfigManager saveConfigDictionary:newDictionary];
}

+ (NSString *)getPropertyFromConfigFile:(NSString*)key
{
    NSDictionary* dictionary = [AppConfigManager readConfigDictionary];
    if (dictionary) {
        return [dictionary objectForKey:key];
    }
    return nil;
}

+ (NSDictionary*) readConfigDictionary
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	
	NSString * pfConfigfilePath = [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@",APP_CONFIG_FILE]];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:pfConfigfilePath])
	{
        return nil;
	}
    
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:pfConfigfilePath];
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
										  propertyListFromData:plistXML
										  mutabilityOption:NSPropertyListMutableContainersAndLeaves
										  format:&format
										  errorDescription:&errorDesc];
	if (!temp)
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	return temp;
}


+ (void) saveConfigDictionary:(NSDictionary*)dictionary
{
	if( dictionary==nil ) return;
	
    NSString * pfConfigfilePath = [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@",APP_CONFIG_FILE]];
	NSData * plistXML = [[NSFileManager defaultManager] contentsAtPath:pfConfigfilePath];
	if( plistXML!=nil )
	{
		NSString *errorDesc = nil;
		NSPropertyListFormat format;
		// 更新数据
		NSDictionary * plistDict = (NSDictionary *)[NSPropertyListSerialization
													propertyListFromData:plistXML
													mutabilityOption:NSPropertyListMutableContainersAndLeaves
													format:&format
													errorDescription:&errorDesc];
		
		if (!plistDict)
		{
			NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
		}
		else
		{
			for( NSString * key in [dictionary allKeys] )
			{
				[plistDict setValue:[dictionary valueForKey:key] forKey:key];
			}
			[AppConfigManager writeDictionaryTolist:plistDict listFilepath:pfConfigfilePath];
		}
	}
	else
	{
		[AppConfigManager writeDictionaryTolist:dictionary listFilepath:pfConfigfilePath];
	}
}

+ (BOOL) writeDictionaryTolist:(NSDictionary*)pDict listFilepath:(NSString*)plistPath
{
	if( plistPath==nil||pDict==nil )
	{
		return NO;
	}
	BOOL result;
	NSString * error;
    NSData * plistData = [NSPropertyListSerialization dataFromPropertyList:pDict
																	format:NSPropertyListXMLFormat_v1_0
														  errorDescription:&error];
    if(plistData)
	{
        if ([ICFileManager checkAndcreateFolderForFilePath:plistPath]) {
            [plistData writeToFile:plistPath atomically:YES];
        }
		//[FileEngine writeFileByC:plistPath streamFileData:[NSMutableData dataWithData:plistData] isAppend:NO];
		result = YES;
    }
    else
	{
        NSLog(@"%@",error);
		result = NO;
    }
	return result;
}

#pragma mark -- time
+ (NSString*)formatTimeStringByString:(NSString*)string
{
    NSString * returnString = @"超时";
    
    //2014-02-19 08:29:15
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *srcDate = [dateFormatter dateFromString:string];
    
    if(!srcDate){
        return returnString;
    }
    
    NSDate *now = [NSDate date];
    
    int interval = [now timeIntervalSinceDate:srcDate];
    
    if (interval <= 60) {
        returnString = @"刚刚";
    }else if (interval > 60 && interval <= 60*60){
        returnString = [NSString stringWithFormat:@"%d分钟前",(interval/60)];
    }else if (interval > 60*60 && interval <= 60*60*24){
        returnString = [NSString stringWithFormat:@"%d小时前",(interval/60/60)];
    }else if (interval > 60*60*24){
        returnString = [NSString stringWithFormat:@"%d天前",(interval/60/60/24)];
    }
    return returnString;
}

+ (NSString*)formatTimeStringByDate:(NSDate*)date
{
    NSString * returnString = @"超时";
    
    if(!date){
        return returnString;
    }
    
    NSDate *now = [NSDate date];
    
    int interval = [now timeIntervalSinceDate:date];
    
    if (interval <= 60) {
        returnString = @"刚刚";
    }else if (interval > 60 && interval <= 60*60){
        returnString = [NSString stringWithFormat:@"%d分钟前",(interval/60)];
    }else if (interval > 60*60 && interval <= 60*60*24){
        returnString = [NSString stringWithFormat:@"%d小时前",(interval/60/60)];
    }else if (interval > 60*60*24){
        returnString = [NSString stringWithFormat:@"%d天前",(interval/60/60/24)];
    }
    return returnString;
}



//#pragma mark --- user
//+(void)saveUserID:(NSString*) name Password:(NSString*)password
//{
//     KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"com.xinhui.user" accessGroup:nil];
//    
//    [keychain setObject:@"myChainValues" forKey:(__bridge id)kSecAttrService];
//    
//    [keychain setObject:name forKey:(__bridge id)kSecAttrAccount];// 上面两行用来标识一个Item
//    
//    [keychain setObject:password forKey:(__bridge id)kSecValueData];
//}
//
//+(NSString *)getUserID
//{
//    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.xinhui.user" accessGroup:nil];
//    return [keychain  objectForKey:(__bridge id)kSecAttrAccount];
//}
//
//+(NSString *)getPassword
//{
//    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.xinhui.password" accessGroup:nil];
//    return [keychain  objectForKey:(__bridge id)kSecValueData];
//}
//
//+(void)clearUserNameAndPassword
//{
//    KeychainItemWrapper *keychain1 = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.xinhui.user" accessGroup:nil];
//    [keychain1 resetKeychainItem];
//    KeychainItemWrapper *keychain2 = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.xinhui.password" accessGroup:nil];
//    [keychain2 resetKeychainItem];
//
//}



#pragma mark ---  文件路径

+ (NSString *) filePathForDocument:(NSString*) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( fileName==nil )
        return documentsDirectory;
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (NSString *) filePathRootData{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@",FILE_ROOT_DATA]];
}

+ (NSString *) filePathDocList:(NSString*)channelID parentID:(NSString*)parentID{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@/%@/%@",channelID,parentID,FILE_DOCLIST]];
}
+ (NSString *) filePathdocListImage:(NSString*)docID imageName:(NSString*)imageName
{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@/%@/%@",FOLDER_DOC,docID,imageName]];
}

+ (NSString *) filePathDoc:(NSString*)docID{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@/%@/%@",FOLDER_DOC,docID,FILE_DOC]];
}

+ (NSString *) filePathdocImage:(NSString*)docID imageName:(NSString*)imageName
{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@/%@/%@",FOLDER_DOC,docID,imageName]];
}

+ (NSString *) filePathDocComment:(NSString*)docID
{
    return [AppConfigManager filePathForDocument:[NSString stringWithFormat:@"/%@/%@/%@",FOLDER_DOC,docID,FILE_DOC_COMMENT]];
}

+ (NSString *) filePathFeedbackMessageByUrl:(NSString*)fileUrl
{
    return [AppConfigManager filePathForDocument:[FOLDER_FEEDBACK stringByAppendingString:[fileUrl lastPathComponent]]];
}


@end
