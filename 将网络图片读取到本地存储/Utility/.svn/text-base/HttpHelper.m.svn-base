//
//  HttpHelper.m
//  icitynanchongiphone
//
//  Created by liuyang on 13-9-11.
//
//

#import "HttpHelper.h"

@implementation HttpHelper

+ (NSString *)httpPostUpload:(NSString*)url params:(NSDictionary*)params files:(NSDictionary *)files retCode:(uint16_t *)retCode
{

	NSMutableURLRequest *imageRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
	[imageRequest setHTTPMethod:@"POST"];
	
    NSString *tmpBoundary = [NSString stringWithFormat:@"%u", arc4random() % (9999999 - 123400) + 123400];
    NSString *boundaryVal = [NSString stringWithFormat:@"Boundary-%@", tmpBoundary];
	
	NSData *boundaryBody = [[NSString stringWithFormat:@"\r\n--%@\r\n", boundaryVal] dataUsingEncoding:NSUTF8StringEncoding];
	[imageRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryVal] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *requestBody = [NSMutableData data];
	NSString *paramsTemplate = @"\r\n--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@";
	
	//NSDictionary *params = [NSURL getQueryDict:queryString];
	for (NSString *key in params) {
		
		NSString *value = [params valueForKey:key];
        NSLog(@"key is %@, value is %@", key, value);
		NSString *formItem = [NSString stringWithFormat:paramsTemplate, boundaryVal, key, value];
		[requestBody appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	//[requestBody appendData:boundaryBody];
    
	NSString *fileTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: \"application/octet-stream\"\r\n\r\n";
	for (NSString *key in files) {
		
		NSString *imagePath = [files objectForKey:key];
        NSLog(@"filePath ---- %@", imagePath);
        
		NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        NSLog(@"imageData size is:%d", [imageData length]);
        
		NSString *fileItem = [NSString stringWithFormat:fileTemplate, key, [[imagePath componentsSeparatedByString:@"/"] lastObject]];
		[requestBody appendData:[fileItem dataUsingEncoding:NSUTF8StringEncoding]];
		[requestBody appendData:imageData];
		[requestBody appendData:boundaryBody];
	}
    
    
    //[requestBody appendData:[NSString stringWithFormat:@"--%@--", boundaryVal]];
    [requestBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundaryVal] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"request content: %@", [[NSString alloc] initWithData:requestBody encoding:NSUTF8StringEncoding]);
    
    [imageRequest setValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
	[imageRequest setHTTPBody:requestBody];
    
    NSLog(@"request %@", imageRequest);
    NSLog(@"request HTTPBody: %@", [[NSString alloc] initWithData:imageRequest.HTTPBody encoding:NSUTF8StringEncoding]);
        
	return [HttpHelper getResponseData:imageRequest retCode:retCode];

}

/*+ (NSString *)httpPostUpload:(NSString*)url params:(NSDictionary*)params files:(NSDictionary *)files retCode:(uint16_t *)retCode
{
    
	NSMutableURLRequest *imageRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
	[imageRequest setHTTPMethod:@"POST"];
	
    NSString *tmpBoundary = [NSString stringWithFormat:@"%u", arc4random() % (9999999 - 123400) + 123400];
    NSString *boundaryVal = [NSString stringWithFormat:@"Boundary-%@", tmpBoundary];
	
	NSData *boundaryBody = [[NSString stringWithFormat:@"\n--%@\n", boundaryVal] dataUsingEncoding:NSUTF8StringEncoding];
	[imageRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryVal] forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *requestBody = [NSMutableData data];
	NSString *paramsTemplate = @"\n--%@\nContent-Disposition: form-data; name=\"%@\"\n\n%@";
	
	//NSDictionary *params = [NSURL getQueryDict:queryString];
	for (NSString *key in params) {
		
		NSString *value = [params valueForKey:key];
        NSLog(@"key is %@, value is %@", key, value);
		NSString *formItem = [NSString stringWithFormat:paramsTemplate, boundaryVal, key, value];
		[requestBody appendData:[formItem dataUsingEncoding:NSUTF8StringEncoding]];
	}
	//[requestBody appendData:boundaryBody];
    
	NSString *fileTemplate = @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\nContent-Type: \"application/octet-stream\"\n\n";
	for (NSString *key in files) {
		
		NSString *imagePath = [files objectForKey:key];
        NSLog(@"filePath ---- %@", imagePath);
        
		NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        NSLog(@"imageData size is:%d", [imageData length]);
        
		NSString *fileItem = [NSString stringWithFormat:fileTemplate, key, [[imagePath componentsSeparatedByString:@"/"] lastObject]];
		[requestBody appendData:[fileItem dataUsingEncoding:NSUTF8StringEncoding]];
		[requestBody appendData:imageData];
		[requestBody appendData:boundaryBody];
	}
    
    
    //[requestBody appendData:[NSString stringWithFormat:@"--%@--", boundaryVal]];
    [requestBody appendData:[[NSString stringWithFormat:@"\n--%@--\n", boundaryVal] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"request content: %@", [[NSString alloc] initWithData:requestBody encoding:NSUTF8StringEncoding]);
    
    [imageRequest setValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
	[imageRequest setHTTPBody:requestBody];
    
    NSLog(@"request %@", imageRequest);
    //NSLog(@"request url: %@", queryString);
    
	return [HttpHelper getResponseData:imageRequest retCode:retCode];
    
}*/

/*
 * 获取响应结果，即返回数据
 */

+ (NSString *)getResponseData:(NSURLRequest *)request retCode:(uint16_t *)retCode
{
	
	NSURLResponse *response = nil;
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	NSString *retString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	
	NSLog(@"response code:%d string:%@", httpResponse.statusCode, retString);
    if (httpResponse.statusCode == 200) {
        *retCode = CodeResponse_Successed;
        NSLog(@"访问接口成功");
        return retString;
    }
	else {
        *retCode = CodeResponse_Failled;
        NSLog(@"访问接口失败，请检查接口访问路径是否正确无误");
        return nil;
    }
}



@end
