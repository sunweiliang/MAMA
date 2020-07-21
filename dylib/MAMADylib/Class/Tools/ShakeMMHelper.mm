//
//  ShakeMMHelper.m
//  testHookDylib
//
//
//   
//

#import "ShakeMMHelper.h"

//#import "BDSSpeechSynthesizer.h"
//#import "TTDFileReader.h"
//#import "TTSConfigViewController.h"
#import <AVFoundation/AVFoundation.h>

#define READ_SYNTHESIS_TEXT_FROM_FILE (NO)
//static BOOL isSpeak = YES;
//static BOOL textFromFile = READ_SYNTHESIS_TEXT_FROM_FILE;
static BOOL displayAllSentences = !READ_SYNTHESIS_TEXT_FROM_FILE;
//#error 请在官网新建app，配置bundleId，并在此填写相关参数 appid
//NSString* APP_ID = @"15549471";
//NSString* API_KEY = @"UvZ6X4YBB1X0oKhDiMqDzcCR";
//NSString* SECRET_KEY = @"HwW1DwgwDjlsxV94aIrpx1mHby4lU2zp";



@interface ShakeMMHelper()
{
}

@property (nonatomic, strong) AVSpeechSynthesizer *avSynthesizer;

@end

@implementation ShakeMMHelper

+ (instancetype)shared {
    static ShakeMMHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ShakeMMHelper alloc] init];
    });

    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self ConfigAudio];
        [ShakeMMHelperConfig shared];
    }
    return self;
}

+ (UINavigationController *)navigationContrioller{
    return ((UINavigationController *)([objc_getClass("CAppViewControllerManager") getCurrentNavigationController]));
}

+ (UIBarButtonItem *)leftNavigationItem{
    
    UINavigationController * navc =  [ShakeMMHelper navigationContrioller];
    for (UIViewController *vc in navc.childViewControllers) {
        UIBarButtonItem * item = vc.navigationItem.leftBarButtonItem;
        if (item) { return item; }
    }
    return nil;
}
  
#pragma mark - AUDIO


-(void)ConfigAudio
{
//    [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
//    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
//    [self configureOnlineTTS];
//
//    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInteger:4] forKey:BDS_SYNTHESIZER_PARAM_SPEED];
//    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:[NSNumber numberWithInteger:9] forKey:BDS_SYNTHESIZER_PARAM_VOLUME];
    
    
    _avSynthesizer = [[AVSpeechSynthesizer alloc] init];
    
}


//-(void)configureOnlineTTS
//{
//
//    [[BDSSpeechSynthesizer sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
//
//    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
//    //    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:@(BDS_SYNTHESIZER_SPEAKER_DYY) forKey:BDS_SYNTHESIZER_PARAM_SPEAKER];
//    //    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:@(10) forKey:BDS_SYNTHESIZER_PARAM_ONLINE_REQUEST_TIMEOUT];
//
//}

+(void)ReadText:(NSString *)text
{
//    if ([ShakeMMHelperConfig shared].speakType == ShakeMMHelperConfigSpeakTypeBaiDu) {
//        [self ReadTextBD:text];
//    }else
//    {
//      [self ReadTextAV:text];
//    }
    
    [self ReadTextAV:text];
}

+(void)ReadTextBD:(NSString *)text
{
//    NSInteger sentenceID;
//    NSError* err = nil;
//    if ([BDSSpeechSynthesizer sharedInstance].synthesizerStatus == BDS_SYNTHESIZER_STATUS_WORKING) {
//        [[BDSSpeechSynthesizer sharedInstance] cancel];
//    }
//    sentenceID = [[BDSSpeechSynthesizer sharedInstance] speakSentence:text withError:&err];
//    if(err){
//        //        NSLog(@"Add sentence Error");
//    }
}

+(void)ReadTextAV:(NSString *)text
{
    
    
    //激活音频会话
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    if ([ShakeMMHelper shared].avSynthesizer.isSpeaking) {
        [[ShakeMMHelper shared].avSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    }
    AVSpeechUtterance *utt = [[AVSpeechUtterance alloc] initWithString:text];
    utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utt.rate = 0.5;
    //    utt.pitchMultiplier = 0.5;
    utt.postUtteranceDelay = 0.2;
    [[ShakeMMHelper shared].avSynthesizer speakUtterance:utt];
}


//#pragma mark - audio BDSSpeechSynthesizerDelegate
//- (void)synthesizerStartWorkingSentence:(NSInteger)SynthesizeSentence{
////    NSLog(@"Did start synth %ld", SynthesizeSentence);
//
//}
//
//- (void)synthesizerFinishWorkingSentence:(NSInteger)SynthesizeSentence{
////    NSLog(@"Did finish synth, %ld", SynthesizeSentence);
//
//}
//
//- (void)synthesizerSpeechStartSentence:(NSInteger)SpeakSentence{
////    NSLog(@"Did start speak %ld", SpeakSentence);
//}
//
//- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence{
////    NSLog(@"Did end speak %ld", SpeakSentence);
//}
//
//- (void)synthesizerNewDataArrived:(NSData *)newData
//                       DataFormat:(BDSAudioFormat)fmt
//                   characterCount:(int)newLength
//                   sentenceNumber:(NSInteger)SynthesizeSentence{
////    NSLog(@"synthesizerNewDataArrived");
//}
//
//- (void)synthesizerTextSpeakLengthChanged:(int)newLength
//                           sentenceNumber:(NSInteger)SpeakSentence{
////    NSLog(@"SpeakLen %ld, %d", SpeakSentence, newLength);
//}
//
//- (void)synthesizerdidPause{
//}
//- (void)synthesizerResumed{
////    NSLog(@"Did resume");
//}
//- (void)synthesizerCanceled{
////    NSLog(@"Did cancel");
//}
//- (void)synthesizerErrorOccurred:(NSError *)error
//                        speaking:(NSInteger)SpeakSentence
//                    synthesizing:(NSInteger)SynthesizeSentence{
//    [[BDSSpeechSynthesizer sharedInstance] cancel];
//}


@end


