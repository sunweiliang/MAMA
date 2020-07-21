//
//  ShakeMMHelperConfig.m
//  testHookDylib
//
//  Created by 朱德坤 on 2019/1/22.
//  Copyright © 2019 DKJone. All rights reserved.
//

#import "ShakeMMHelperConfig.h"
#import <AVFoundation/AVFoundation.h>


@interface ShakeMMHelperConfig()
@property (nonatomic, strong) AVAudioPlayer *bgRunPlayer; //无声音频播放器
@property (nonatomic, strong) AVAudioPlayer *redBaoPlayer; //无声音频播放器
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskIdentifier; //后台任务标识符
@end

@implementation ShakeMMHelperConfig
+ (instancetype)shared {
    static ShakeMMHelperConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[ShakeMMHelperConfig alloc] init];
        
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData
{
    NSString *canRun = [[NSUserDefaults standardUserDefaults] objectForKey:KUDK_canBgRunning];
    if (canRun && [canRun isEqualToString:@"1"])
    {
        _canBgRunning = YES;
    }else
    {
        _canBgRunning = NO;
    }
    
    NSString *speaktypeString = [[NSUserDefaults standardUserDefaults] objectForKey:KUDK_SpeakType];
    if (speaktypeString)
    {
        _speakType = [speaktypeString integerValue];
    }else
    {
        _speakType = ShakeMMHelperConfigSpeakTypeBaiDu;
    }
    
    NSString *activeRedBaoPlay1 = [[NSUserDefaults standardUserDefaults] objectForKey:KUDK_ActiveRedBaoPlay];
    if (activeRedBaoPlay1 && [activeRedBaoPlay1 isEqualToString:@"1"])
    {
        _activeRedBaoPlay = YES;
    }else
    {
        _activeRedBaoPlay = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundHandler) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActiveHandler) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

#pragma mark - SET GET
-(void)setCanBgRunning:(BOOL)canBgRunning
{
    _canBgRunning = canBgRunning;
    if (canBgRunning) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KUDK_canBgRunning];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KUDK_canBgRunning];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setActiveRedBaoPlay:(BOOL)activeRedBaoPlay
{
    _activeRedBaoPlay = activeRedBaoPlay;
    if (_activeRedBaoPlay) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:KUDK_ActiveRedBaoPlay];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:KUDK_ActiveRedBaoPlay];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)setSpeakType:(ShakeMMHelperConfigSpeakType)speakType
{
    _speakType = speakType;
    [[NSUserDefaults standardUserDefaults] setObject:@(_speakType) forKey:KUDK_SpeakType];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 通知
//程序进入后台处理
- (void)enterBackgroundHandler
{
    
//    if(self.canBgRunning == NO)
//    {
//        return;
//    }
//    UIApplication *app = [UIApplication sharedApplication];
//    self.bgTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:self.bgTaskIdentifier];
//        self.bgTaskIdentifier = UIBackgroundTaskInvalid;
//    }];
//    [self playBlankAudio];
}

-(void)becomeActiveHandler
{
//    [self stopBgRunAudio];
//    [self stopRedBaoAudio];
}

//播放无声音频
- (void)playBlankAudio{
    
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     withOptions: AVAudioSessionCategoryOptionMixWithOthers
     error: nil];
    
    NSURL *blankSoundURL1 = [[NSBundle mainBundle] URLForResource:@"fmbgslicence" withExtension:@"mp3"];
    if(blankSoundURL1){
        [self stopBgRunAudio];
        self.bgRunPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blankSoundURL1 error:nil];
        self.bgRunPlayer.numberOfLoops = -1;
        [self.bgRunPlayer play];
    }
}

-(void)stopBgRunAudio
{
    if (self.bgRunPlayer) {
        if (self.bgRunPlayer.isPlaying) {
            [self.bgRunPlayer stop];
        }
        self.bgRunPlayer = nil;
    }
}

-(void)stopRedBaoAudio
{
    if (self.redBaoPlayer) {
        if (self.redBaoPlayer.isPlaying) {
            [self.redBaoPlayer stop];
        }
        self.redBaoPlayer = nil;
    }
}

//播放收到红包音频
- (void)playCashReceivedAudio{
    
    if (self.activeRedBaoPlay) {
        [self playRedBaoAudioAction];
    }else
    {
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            [self playRedBaoAudioAction];
        }
    }
}
-(void)playRedBaoAudioAction
{
    NSURL *blankSoundURL2 = [[NSBundle mainBundle] URLForResource:@"fmredbaocome" withExtension:@"mp3"];
    if(blankSoundURL2){
        [self stopRedBaoAudio];
        self.redBaoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:blankSoundURL2 error:nil];
        [self.redBaoPlayer play];
    }
}


@end


