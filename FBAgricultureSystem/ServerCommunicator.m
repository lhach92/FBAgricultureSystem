//
//  InterfaceWrapper.m
//  Hotshop
//
//  Created by user on 12-4-27.
//  Copyright (c) 2012年 qinyh.com. All rights reserved.
//

#import "ServerCommunicator.h"
#import "ASIHTTPRequest.h"
#import "ProgressWrapper.h"

#define DefaultServerResponseTimeout 30

@implementation ServerCommunicator
{
    ProgressWrapper *_progressWrapper;
}

- (void)dealloc
{
    [self clearEnvironment];
    _request.delegate = nil;
}

- (void)prepare:(id)delegate loadingInView:(UIView*)view
{
    [self prepare:delegate loadingInView:view waitingMessage:nil];
}

- (void)prepare:(id)delegate loadingInView:(UIView*)view waitingMessage:(NSString*)waitingMessage
{
    self.delegate = delegate;
    _loadingParentView = view;
    _waitingMessage = waitingMessage;
    [self initVariables];
}

- (void)clearEnvironment
{
    [self cancelRequest];
    self.delegate = nil;
    _loadingParentView = nil;
    [self initVariables];
}

- (void)cancelRequest
{
    [_request clearDelegatesAndCancel];
//    _request = nil;
//    [_request cancel];
//    _request.delegate = nil;
}

- (void)initVariables
{
    _checkReceiveData = NO;
    self.additionalInfo = nil;
}

- (void)showHUD
{
    if (!_progressWrapper) {
        _progressWrapper = [[ProgressWrapper alloc] init];
    }
    
    if (_waitingMessage) {
        [_progressWrapper addloadingAnimation:_loadingParentView andTitle:_waitingMessage];
    } else {
        [_progressWrapper addloadingAnimation:_loadingParentView];
    }
    
//    __weak ServerCommunicator *weakSelf = self;
//    _progressWrapper.wantToCancel = ^(){
//        [weakSelf doCancelAction];
//    };
}

//- (void)doCancelAction
//{
//    NSLog(@"请求被取消");
//    [self cancelRequest];
//    if ([self.delegate respondsToSelector:@selector(handleRequestFail:)]) {
//        [self.delegate handleRequestFail:_request];
//    }
//}

- (void)hideHUD
{
    if (_loadingParentView) {
        [_progressWrapper hide];
    }
}

- (id)parseObjectFromRequest:(ASIHTTPRequest*)request
{
    if (request.responseData) {
        id returnInfo = [NSJSONSerialization JSONObjectWithData:request.responseData
                                                        options:kNilOptions
                                                          error:NULL];
        return returnInfo;
    } else {
        return nil;
    }
}

- (NSString*)getVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (void)setHeaderEtag:(NSString*)etag
{
    if (etag) {
        [_request addRequestHeader:@"If-None-Match" value:etag];
    }
}

- (NSString*)getAccessToken
{
//    return [CommonInfoPersistenceManager getTokenId];
    return nil;
}

- (void)requestAsynchronous:(NSString*)urlString
{
    return [self requestAsynchronous:urlString needAccessToken:YES];
}

- (void)requestAsynchronous:(NSString*)urlString needAccessToken:(BOOL)needAccessToken
{
    return [self requestAsynchronous:urlString needAccessToken:needAccessToken requestMethod:@"GET"];
}

- (void)requestAsynchronousPOST:(NSString *)urlString needAccessToken:(BOOL)needAccessToken
{
    return [self requestAsynchronous:urlString needAccessToken:needAccessToken requestMethod:@"POST"];
}
- (void)requestAsynchronous:(NSString*)urlString needAccessToken:(BOOL)needAccessToken requestMethod:(NSString*)requestMethod
{
    [self requestAsynchronous:urlString needAccessToken:needAccessToken requestMethod:requestMethod autoStart:YES];
}

- (void)requestAsynchronous:(NSString*)urlString
            needAccessToken:(BOOL)needAccessToken
              requestMethod:(NSString*)requestMethod
                  autoStart:(BOOL)autoStart
{
    if (urlString) {
        if (needAccessToken) {
            NSString *accessToken = [self getAccessToken];
            if (!accessToken) {
                return;
            }
            urlString = [NSString stringWithFormat:@"%@?access_token=%@", urlString, accessToken];
        }
        
        NSLog(@"tag %li, urlstring is %@", (long)self.tag, urlString);
        
        _urlString = urlString;
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        if (_request) {
            [self cancelRequest];
        }
        _request = [ASIHTTPRequest requestWithURL:url];
        
        if (requestMethod) {
            if ([@"DELETE" isEqualToString:requestMethod]) {
                [_request buildPostBody];
            }
            [_request setRequestMethod:requestMethod];
        }
        _request.numberOfTimesToRetryOnTimeout = 3;
    } else {
        if (!_request) {
            return;
        }
    }
    
    if (_timeOutSeconds > 0) {
        [_request setTimeOutSeconds:_timeOutSeconds];
    } else {
        //        [_request setTimeOutSeconds:DefaultServerResponseTimeout];
    }
    
    _timeOutSeconds = 0;
    
    _request.shouldAttemptPersistentConnection = NO;
    [_request setValidatesSecureCertificate:NO];
    _request.tag = self.tag;
    
    if (_loadingParentView) {
        [self showHUD];
    }
    
    _request.delegate = self;
    
    if (autoStart) {
        [_request startAsynchronous];
        NSLog(@"request start.......");
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *urlStringInfo = _urlString ?: request.url.absoluteString;
    NSLog(@"url is %@, tag %li request finished. http status code is %i", urlStringInfo, (long)request.tag, request.responseStatusCode);
    
    [self hideHUD];
    
    if (206 == _request.responseStatusCode) {
        NSLog(@"发生了断点续传。");
    }
    
    // 2XX的返回码认为是成功返回
    if ((_request.responseStatusCode >= 200 && _request.responseStatusCode < 300)) {
        if (self.additionalInfo) {
            if ([self.delegate respondsToSelector:@selector(handleRequestCompletion:additionalInfo:)]) {
                [self.delegate handleRequestCompletion:_request additionalInfo:self.additionalInfo];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(handleRequestCompletion:)]) {
                [self.delegate handleRequestCompletion:_request];
            }
        }
    } else if (401 == _request.responseStatusCode) {
        NSLog(@"授权失败。");
    } else {
        [self requestFailed:_request];
        
        if (304 == _request.responseStatusCode) {
            NSLog(@"return 304，请求的信息没有改变。");
        } else if (400 == _request.responseStatusCode) {
            NSLog(@"修改失败。");
        } else if (404 == _request.responseStatusCode) {
            NSLog(@"资源未找到。");
        } else if (500 ==  request.responseStatusCode) {
            NSLog(@"服务器错误。url is %@", _urlString);
        } else {
            NSLog(@"返回了未对应操作的状态码 %i", _request.responseStatusCode);
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"url is %@, tag %li request failed. http status code is %i", _urlString, (long)request.tag, request.responseStatusCode);
    
    NSError *error = [request error];
    if (error) {
        if (2 == error.code) {
            NSLog(@"系统超时");
        }
        NSLog(@"error is %@", error);
    }
    
    [self hideHUD];
    
    if (401 == _request.responseStatusCode) {
        [self clearEnvironment];
    } else {
        
        if (403 == _request.responseStatusCode) {
             NSLog(@"AccessDenied.");
        }
        
        if (self.additionalInfo) {
            if ([self.delegate respondsToSelector:@selector(handleRequestFail:additionalInfo:)]) {
                [self.delegate handleRequestFail:_request additionalInfo:self.additionalInfo];
            } else {
                [self clearEnvironment];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(handleRequestFail:)]) {
                [self.delegate handleRequestFail:_request];
            } else {
                [self clearEnvironment];
            }
        }
    }
}

- (void)setPostValue:(id)postValue forKey:(NSString *)key
{
    if (postValue) {
        [(ASIFormDataRequest*)_request setPostValue:postValue forKey:key];
    }
}

- (void)setFile:(NSString*)filePath forKey:(NSString *)key
{
    if (filePath) {
        [(ASIFormDataRequest*)_request setFile:filePath forKey:key];
    }
}

- (void)setData:(NSData*)data forKey:(NSString *)key
{
    if (data) {
        [(ASIFormDataRequest*)_request setData:data forKey:key];
    }
}

- (void)getDataFromUrl:(NSString*)url
{
    [self requestAsynchronous:url needAccessToken:NO];
}

- (NSString*)getServerAddress
{
    return @"http://192.168.101.190:8080/rest";
}

- (NSString*)getGetDataUrl:(NSString*)categoryId
{
    return @"";
}

- (void)getNewsList {
    NSString *urlString = [NSString stringWithFormat:@"%@/app/news/list", [self getServerAddress]];
    [self requestAsynchronous:urlString needAccessToken:NO];
}

- (void)getNewsDetailById:(NSString *)newsId {
    NSString *urlString = [NSString stringWithFormat:@"%@/app/news/getNewsById?id=%@", [self getServerAddress], newsId];
    [self requestAsynchronous:urlString needAccessToken:NO];
}

- (void)getWeatherByCity:(NSString *)city country:(NSString *)country
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@,%@&cnt=7&appid=84efe27b3f2990967690c7c9a5d3cee0&lang=zh_cn", city, country];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self requestAsynchronous:urlString needAccessToken:NO];
}

@end
