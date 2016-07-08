//
//  FileManager.m
//  icitynanchongiphone
//
//  Created by  on 13-1-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ICFileManager.h"

@implementation ICFileManager


#pragma mark -
#pragma mark 普通文件操作
+ (void) writeFileByC:(NSString *) filepath streamFileData:(NSMutableData*) data isAppend:(BOOL)append
{
	if (filepath==nil||data==nil) 
	{
		return;
	}
    
	const char* src = [filepath UTF8String];
	int count = strlen(src);
	char* dest = (char*)malloc(strlen(src)+1);
	memcpy(dest, src, count);	
	while (--count>=0)
	{
		if(src[count]=='/')
		{
			dest[count] = '\0';
			break;
		}
	}
	NSString * folderpath = [NSString stringWithUTF8String:dest];
	free(dest);
	
	NSError* error = nil;
	if( [[NSFileManager defaultManager] fileExistsAtPath:folderpath]==NO ) 
	{
		[[NSFileManager defaultManager] createDirectoryAtPath:folderpath
								  withIntermediateDirectories:YES 
												   attributes:nil
														error:&error];
	}
	WriteFileData([filepath UTF8String],(char*)[data bytes],(unsigned long)[data length],append);
}

int WriteFileData(const char * filename, const char * chScrData, size_t lenScrData,bool isAppend)
{
	if( filename==NULL||chScrData==NULL||lenScrData<=0 ) return -1;
	
	FILE * file = NULL;
	if( isAppend )
	{
		file = fopen(filename, "a");
	}
	else {
		file = fopen(filename, "w");
	}
	
	if( file!=NULL)
	{
		int len = ftell(file);
		if( len>0) fseek(file, len, SEEK_END);
		fwrite(chScrData,sizeof(char),lenScrData,file);
		fseek(file, 0,SEEK_END);
		len = ftell(file);
		fclose(file);
		return len;
	}
	else 
	{
		return -1;
	}
}

+(BOOL) checkAndcreateFolderForFilePath:(NSString *)filePath
{
    if (filePath == nil || filePath.length < 1)
        return NO;
    
    NSString * destFoler = nil;
    //目录
    if ([filePath characterAtIndex:(filePath.length - 1)] == '/') {
        destFoler = filePath;
    }
    //文件名
    else {
        destFoler = [ICFileManager getParentFolder:filePath];
    }
    
    if (destFoler == nil)
        return NO;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destFoler]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:destFoler
                                  withIntermediateDirectories:YES 
                                                   attributes:nil
                                                        error:nil];
    }
    return YES;
}

+ (NSString *)getParentFolder:(NSString *)filePath
{
    int i;
    for (i = filePath.length - 2; i >= 0; i--)
    {
        if([filePath characterAtIndex:i] == '/')
        {
            break;
        }
    }
    
    if(i == filePath.length - 2 || i == 0)
    {
        return nil;
    }
    
    if (i<0) {
        return filePath;
    }else
        return [[filePath substringToIndex:i] stringByAppendingString:@"/"];
}

+(BOOL) isModificationInTime:(int)inSeconds filePath:(NSString*)filepath
{
	BOOL isInTime = YES;
#ifdef LOCALFILE_READONLY
    return isInTime;
#endif
	if([[NSFileManager defaultManager] fileExistsAtPath:filepath]==NO)
	{
		isInTime = NO;
	}
	else
	{
//		// 得到当前时间
//		NSDateComponents * dateNow = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
//																	 fromDate:[NSDate date]];
		
		// 得到文件属性
		NSError * fileAttributesError;
		NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath
																						 error:&fileAttributesError];
        NSDate * fileModDate;
        
		if (fileAttributes){
            fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
            if (fileModDate) {
                NSTimeInterval interval = [fileModDate timeIntervalSinceNow];
                if (interval <= 0 && -interval <= inSeconds) {
                    isInTime = YES;
                }else{
                    isInTime = NO;
                }
            }else{
                isInTime = NO;
            }
        }else{
            isInTime = NO;
        }
	}
	return isInTime;
}


+(BOOL) isModificationToday:(NSString*)filepath
{
	BOOL isToday = YES;
#ifdef LOCALFILE_READONLY
    return isToday;
#endif
	if([[NSFileManager defaultManager] fileExistsAtPath:filepath]==NO)
	{
		isToday = NO;
	}
	else
	{
		// 得到当前时间		
		NSDateComponents * dateNow = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
																	 fromDate:[NSDate date]]; 
		
		// 得到文件属性
		NSDateComponents * dateComponentsFile = nil;
		NSError * fileAttributesError;
		NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath
																						 error:&fileAttributesError];
		
		if (fileAttributes != nil) 
		{
			NSDate * fileModDate;			
			if ((fileModDate = [fileAttributes objectForKey:NSFileModificationDate])) 
			{
				dateComponentsFile = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
																	 fromDate:fileModDate];
			}			
		}
		if( dateComponentsFile!=nil )
		{
			if( [dateNow year] == [dateComponentsFile year] &&
			   [dateNow month] == [dateComponentsFile month] &&
			   [dateNow day] == [dateComponentsFile day] )
			{
				if( ([dateNow hour]-[dateComponentsFile hour])<=2 )
				{
					isToday = YES;
				}
				else 
				{
					isToday = NO;
				}
			}
			else 
			{
				isToday = NO;
			}
		}
		else
		{
			isToday = NO;
		}
	}
	return isToday;
}

+(NSDate *) fileModifyDate:(NSString*)filePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]==YES)
    {
        NSError * fileAttributesError;
        NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath
                                                                                         error:&fileAttributesError];
        if (fileAttributes){
            return [fileAttributes objectForKey:NSFileModificationDate];
        }
    }
        
    return nil;
}

+(void)deleteFileOrDir:(NSString*)path
{

    NSError * error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL isExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (!isDir) {
            [fileManager removeItemAtPath:path error:&error];
        }else{
            NSArray * array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
            if (array && [array count]>0) {
                for ( int i=0; i<[array count]; i++)
                {
                    [ICFileManager deleteFileOrDir:[array objectAtIndex:i]];
                }
            }
            [fileManager removeItemAtPath:path error:&error];
        }
    }    
}


@end
