//
//  ShakeMMHelper.h
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/21.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import <Foundation/Foundation.h>

//MARK: - wechat quick imports
#import "UiUtil.h"
#import "WechatHeaders.h"
#import <objc/objc-runtime.h>
#import "WCUIAlertView.h"
#import "ShakeMMHelperConfig.h"
#import <UIKit/UIKit.h>

//
////MARK: - quick objc finds
//#define FUiUtil objc_getClass("UiUtil")
//#define FMMUICommonUtil objc_getClass("MMUICommonUtil")
//#define FWCTableViewCellManager objc_getClass("WCTableViewNormalCellManager")


NS_ASSUME_NONNULL_BEGIN

@interface ShakeMMHelper : NSObject

+ (instancetype)shared ;

+ (UIBarButtonItem *)leftNavigationItem;

+ (UINavigationController *)navigationContrioller;

#pragma mark - 语音，文字转语音
+(void)ReadText:(NSString *)text;

@end

@interface WeChatRedEnvelopParam : NSObject
- (NSDictionary *)toParams;
@property (strong, nonatomic) NSString *msgType;
@property (strong, nonatomic) NSString *sendId;
@property (strong, nonatomic) NSString *channelId;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *headImg;
@property (strong, nonatomic) NSString *nativeUrl;
@property (strong, nonatomic) NSString *sessionUserName;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *timingIdentifier;

@property (assign, nonatomic) BOOL isGroupSender;

@end


@interface WBRedEnvelopParamQueue : NSObject
+ (instancetype)sharedQueue;
- (void)enqueue:(WeChatRedEnvelopParam *)param;
- (WeChatRedEnvelopParam *)dequeue;
- (WeChatRedEnvelopParam *)peek;
- (BOOL)isEmpty;

@end

@class WeChatRedEnvelopParam;
@interface WBReceiveRedEnvelopOperation : NSOperation

- (instancetype)initWithRedEnvelopParam:(WeChatRedEnvelopParam *)param delay:(unsigned int)delaySeconds;

@end

@interface WBRedEnvelopTaskManager : NSObject
+ (instancetype)sharedManager;
- (void)addNormalTask:(WBReceiveRedEnvelopOperation *)task;
- (void)addSerialTask:(WBReceiveRedEnvelopOperation *)task;
- (BOOL)serialQueueIsEmpty;
@end

NS_ASSUME_NONNULL_END
