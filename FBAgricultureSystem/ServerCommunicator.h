//
//  InterfaceWrapper.h
//  Hotshop
//
//  Created by user on 12-4-27.
//  Copyright (c) 2012年 qinyh.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIFormDataRequest.h>

@protocol ServerCommunicatorDelegate<NSObject>
@optional
- (void)handleRequestFail:(ASIHTTPRequest*)request;
- (void)handleRequestCompletion:(ASIHTTPRequest*)request;
- (void)handleRequestFail:(ASIHTTPRequest*)request additionalInfo:(id)additionalInfo;
- (void)handleRequestCompletion:(ASIHTTPRequest*)request additionalInfo:(id)additionalInfo;

@end

//和服务器通信的接口包装类
@interface ServerCommunicator : NSObject <ASIHTTPRequestDelegate>
{
    ASIHTTPRequest *_request;
    BOOL _checkReceiveData;
    NSString *_urlString;
    NSTimeInterval _timeOutSeconds;
}

@property (nonatomic, assign) NSInteger tag; //用来区分不同的请求
@property (nonatomic, weak) UIView *loadingParentView;
@property (nonatomic, weak) id<ServerCommunicatorDelegate> delegate;
@property (nonatomic, strong) id additionalInfo;
@property (nonatomic, copy) NSString *waitingMessage;

- (void)prepare:(id)delegate loadingInView:(UIView*)view;
- (void)prepare:(id)delegate loadingInView:(UIView*)view waitingMessage:(NSString*)waitingMessage;
- (void)clearEnvironment;
- (void)cancelRequest;

- (void)showHUD; //显示指示器
- (void)hideHUD; //隐藏显示器

- (id)parseObjectFromRequest:(ASIHTTPRequest*)request;

- (void)getWeatherByCity:(NSString *)city country:(NSString *)country;
//获取新闻列表
- (void)getNewsList;
- (void)getNewsDetailById:(NSString *)newsId;

//获取种子列表
- (void)getSeedList;

@end
