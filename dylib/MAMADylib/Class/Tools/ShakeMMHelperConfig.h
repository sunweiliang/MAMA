//
//  ShakeMMHelperConfig.h
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *KUDK_canBgRunning = @"fm_canBgRunning";
static NSString *KUDK_SpeakType = @"fm_speaktype";
static NSString *KUDK_ActiveRedBaoPlay = @"fm_activeredbaoplay";

typedef NS_ENUM(NSUInteger, ShakeMMHelperConfigSpeakType) {
    ShakeMMHelperConfigSpeakTypeBaiDu = 0,
    ShakeMMHelperConfigSpeakTypeAV = 1,
};

@interface ShakeMMHelperConfig : NSObject

//@property (nonatomic, strong) NSTimer *bgTaskTimer;

@property (nonatomic, assign) BOOL canBgRunning;
@property (nonatomic, assign) BOOL activeRedBaoPlay;
@property (nonatomic, assign) ShakeMMHelperConfigSpeakType speakType;


+ (instancetype)shared;

//播放收到红包音频
- (void)playCashReceivedAudio;
 
@end

NS_ASSUME_NONNULL_END
