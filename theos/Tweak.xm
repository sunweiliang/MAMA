#import "AppHeader.h"
#import <MediaPlayer/MPMusicPlayerController.h>


static AVSpeechSynthesizer *KAvSynthesizer;
static int firstReadVolume = 0;

%hook BaseMsgContentViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{

 if(KAvSynthesizer == nil)
 {
  	KAvSynthesizer = [[AVSpeechSynthesizer alloc] init];
 }

ChatTableViewCell *cell_s1 = (ChatTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIView *cell_s1_cellView = [cell_s1 cellView];
    if([cell_s1_cellView isKindOfClass:NSClassFromString(@"TextMessageCellView")])
    {
        TextMessageCellView *textCellView = (TextMessageCellView *)cell_s1_cellView;
        
        TextMessageViewModel *viewModel = [textCellView viewModel];
        
        NSMutableArray *viewModelContentTextStylesArr = [viewModel contentTextStyles];
        NSMutableString *cellText_s = [NSMutableString new];
        
        for (NSInteger ii = 0; ii<viewModelContentTextStylesArr.count; ii++) {
            id style = viewModelContentTextStylesArr[ii];
            if([style isKindOfClass:NSClassFromString(@"TextStyle")])
            {
                NSString *styleString = [(TextStyle *)style nsContent];
                
                //NSLog(@"sunweiliang9999 1:%@",styleString);

                if ([styleString length] > 0)
                {
                    [cellText_s appendFormat:@"%@",styleString];
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            //读取音量
            MPMusicPlayerController* musicController = [MPMusicPlayerController applicationMusicPlayer];
            if (firstReadVolume > 0 && musicController.volume == 0)
            {
                musicController.volume = 0.5;
                //NSLog(@"sunweiliang9999 3:%f",musicController.volume);
            }

             //激活音频会话
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
             
            if (KAvSynthesizer.isSpeaking) 
            {
                [KAvSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            }
            
            AVSpeechUtterance *utt = [[AVSpeechUtterance alloc] initWithString:cellText_s];
            utt.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
            utt.rate = 0.5;
            //    utt.pitchMultiplier = 0.5;
            utt.postUtteranceDelay = 0.2;
            [KAvSynthesizer speakUtterance:utt];

            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //
            //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:cellText_s delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //    [alert show];
            // });


            firstReadVolume++;

            //NSLog(@"sunweiliang9999 %@",cellText_s);

        });
        

        return;
    }

    %orig;
}

%end


%hook TextMessageCellView
///显示文字面板后，点击消失
//- (void)onWindowHide

///双击
- (void)onTouchDownRepeat
{     
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"14" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
//    %orig; 
};

%end





























