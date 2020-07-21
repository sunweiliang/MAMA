//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  MAMADylib.m
//  MAMADylib
//
//  Created by weiliang on 2020/7/22.
//  Copyright (c) 2020 Leo. All rights reserved.
//

#import "MAMADylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import "WechatHeaders.h"
#import "ShakeMMHelper.h"
#import "ShakeMMViewController.h"


//MARK: - 请求数据伪装

CHDeclareClass(ASIdentifierManager)

//广告标识符伪装
CHMethod0(NSUUID *, ASIdentifierManager, advertisingIdentifier)
{
    NSUUID *advertisingIdentifier;
    NSString *key = @"idfa";
    
    NSString *idfa = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    if (idfa && idfa.length)
    {
        advertisingIdentifier = [[NSUUID alloc] initWithUUIDString:idfa];
    }
    else
    {
        advertisingIdentifier = [NSUUID UUID];
        
        [[NSUserDefaults standardUserDefaults] setObject:advertisingIdentifier.UUIDString forKey:key];
    }
    
    return advertisingIdentifier;
}


@class BaseAuthReqInfo, BaseRequest, ManualAuthAesReqData;

CHDeclareClass(ManualAuthAesReqData);
//bundleId 伪装(待完善)
CHMethod1(void, ManualAuthAesReqData, setBundleId, NSString *, bundleId)
{
    //    NSLog(@"======-获取请求时验证数据-========");
    //    if ([bundleId isEqualToString:[NSBundle mainBundle].bundleIdentifier])
    //    {
    //        bundleId = @"com.tencent.xin";
    //    }
    //
    CHSuper1(ManualAuthAesReqData, setBundleId, bundleId);
}

//clientSeqId 伪装
CHMethod1(void, ManualAuthAesReqData, setClientSeqId, NSString *, clientSeqId)
{
    //661033b92030a4001d75e8f6892a4dc7-1550750503
    NSString *key = @"clientSeqId";
    NSString *clientSeqId_fist = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    if (!clientSeqId_fist || clientSeqId_fist.length == 0)
    {
        clientSeqId_fist = [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:clientSeqId_fist forKey:key];
    }
    
    NSString *newClientSeqId;
    
    if ([clientSeqId containsString:@"-"])
    {
        NSRange range = [clientSeqId rangeOfString:@"-"];
        NSString *clientSeqId_last = [clientSeqId substringFromIndex:range.location];
        
        newClientSeqId = [NSString stringWithFormat:@"%@%@", clientSeqId_fist, clientSeqId_last];
    }
    else
    {
        newClientSeqId = clientSeqId_fist;
    }
//    Printing description of newClientSeqId:
//    18A116AAC04C46B085D05160CF44BBDC-1550750352
//    Printing description of clientSeqId_fist:
//    18A116AAC04C46B085D05160CF44BBDC
    CHSuper1(ManualAuthAesReqData, setClientSeqId, newClientSeqId);
}

//deviceName 伪装
CHMethod1(void, ManualAuthAesReqData, setDeviceName, NSString *, deviceName)
{
    //设置为默认名称
    deviceName = @"iPhone";
    
    CHSuper1(ManualAuthAesReqData, setDeviceName, deviceName);
}



//过日志记录
@class WXGCrashReportExtensionHandler;
CHDeclareClass(WXGCrashReportExtensionHandler);
CHMethod2(void, WXGCrashReportExtensionHandler, addLogInfo, int *, arg1, withMessage, const char *, arg2)
{
    return;
}

//过越狱检测
@class JailBreakHelper;

CHDeclareClass(JailBreakHelper);

CHMethod0(BOOL, JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase)
{
    return NO;
}

CHMethod1(BOOL, JailBreakHelper, HasInstallJailbreakPlugin, id, arg1)
{
    return NO;
}

CHMethod0(BOOL, JailBreakHelper, IsJailBreak)
{
    return YES;
}

#pragma mark - BaseMsgContentViewController
CHDeclareClass(BaseMsgContentViewController)
CHOptimizedMethod(2, self, void, BaseMsgContentViewController,tableView,UITableView *,arg1,didSelectRowAtIndexPath,NSIndexPath *,arg2){
    
    ChatTableViewCell *cell_s1 = (ChatTableViewCell *)[arg1 cellForRowAtIndexPath:arg2];
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
                [cellText_s appendFormat:@"%@。",[(TextStyle *)style nsContent]];
            }
        }
        
        
        [ShakeMMHelper ReadText:cellText_s];
        
        return;
    }
    
    CHSuper(2, BaseMsgContentViewController, tableView,arg1,didSelectRowAtIndexPath,arg2);
    
    
}
//CHOptimizedMethod(0, self, void, BaseMsgContentViewController,viewDidLoad){
//    CHSuper(0, BaseMsgContentViewController, viewDidLoad);
//}


#pragma mark - WCSiriMgr
CHDeclareClass(WCSiriMgr)
CHOptimizedMethod(0, self, BOOL, WCSiriMgr,isSiriKitAvailable){
    return NO;
}


#pragma mark - Crash

CHDeclareClass(AppCatchCrashMgr)
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,loadCallMonitorCount){
    
}
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,saveCallMonitorCount){
    
}
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,setForceCallCanOpenUrl){
    
}
CHOptimizedMethod(0, self, BOOL, AppCatchCrashMgr,canCallCanOpenUrlMethod){
    return NO;
}
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,endMonitor){
    
}
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,beginMonitor){
    
}
CHOptimizedMethod(0, self, void, AppCatchCrashMgr,onServiceInit){
    
}

CHDeclareClass(BaseMessageViewModel)
CHOptimizedMethod(0, self, void, BaseMessageViewModel,updateCrashProtectedState){
    
}

CHDeclareClass(MemoryStatReporter)
CHOptimizedMethod(2, self, void, MemoryStatReporter,onReportUploadCompleted,BOOL,arg1,reportType,int,arg2){
}
CHOptimizedMethod(2, self, void, MemoryStatReporter,onUploadCrashCompleted,BOOL,arg1,CrashWrap,id,arg2){
}
CHOptimizedMethod(1, self, void, MemoryStatReporter,doFullReport,id,arg2){
}
CHOptimizedMethod(1, self, void, MemoryStatReporter,doSummaryReport,id,arg2){
}
CHOptimizedMethod(1, self, void, MemoryStatReporter,doNextReport,id,arg2){
}
CHOptimizedMethod(1, self, BOOL, MemoryStatReporter,hasNextTask,int,arg2){
    return NO;
}
CHOptimizedMethod(0, self, void, MemoryStatReporter,loadTasks){
}
CHOptimizedMethod(0, self, void, MemoryStatReporter,saveTasks){
}
CHOptimizedMethod(0, self, void, MemoryStatReporter,uploadAllFullReport){
}
CHOptimizedMethod(0, self, void, MemoryStatReporter,uploadAllSummaryReport){
}
CHOptimizedMethod(0, self, void, MemoryStatReporter,removeAllFullReport){
}
CHOptimizedMethod(0, self, BOOL, MemoryStatReporter,hasFullReport){
    return NO;
}
CHOptimizedMethod(4, self, void, MemoryStatReporter,addReportTask,long long,arg1,dataPath,id,arg2,foomScene,id,arg3,reportType,int,arg4){
}
CHOptimizedMethod(3, self, void, MemoryStatReporter,addFullReportTask,long long,arg1,dataPath,id,arg2,foomScene,id,arg3){
}
CHOptimizedMethod(3, self, void, MemoryStatReporter,addSummaryReportTask,long long,arg1,dataPath,id,arg2,foomScene,id,arg3){
}

CHDeclareClass(MMCrashReportConnection)
CHOptimizedMethod(2, self, void, MMCrashReportConnection,onCustomIssueUploadComplete,BOOL,arg1,withReportKey,id,arg2){
}
CHOptimizedMethod(2, self, BOOL, MMCrashReportConnection,uploadCrash,id,arg1,reportType,long long,arg2){
    return YES;
}

CHDeclareClass(MMCustomInfoReporter)
CHOptimizedMethod(2, self, void, MMCustomInfoReporter,onUploadCrashCompleted,BOOL,arg1,CrashWrap,id,arg2){
}
CHOptimizedMethod(2, self, void, MMCustomInfoReporter,reportInfo,id,arg1,withReportType,long long,arg2){
    
}

CHDeclareClass(WCDBPerformanceReport)
CHOptimizedMethod(2, self, void, WCDBPerformanceReport,onUploadCrashCompleted,BOOL,arg1,CrashWrap,id,arg2){
}
CHOptimizedMethod(0, self, void, WCDBPerformanceReport,report){
    
}

CHDeclareClass(WCCheckHookMgr)
CHOptimizedMethod(2, self, void, WCCheckHookMgr,reportContent,id,arg1,withContext,id,arg2){
}
CHOptimizedMethod(1, self, void, WCCheckHookMgr,checkHook,id,arg2){
}
CHOptimizedMethod(0, self, void, WCCheckHookMgr,test){
}

CHDeclareClass(ClientCheckMgr)
CHOptimizedMethod(1, self, void, ClientCheckMgr,reportAppList,id,arg1){
}
CHOptimizedMethod(1, self, void, ClientCheckMgr,checkHookWithSeq,int,arg1){
}
CHOptimizedMethod(1, self, void, ClientCheckMgr,checkHook,id,arg1){
}
CHOptimizedMethod(5, self, void, ClientCheckMgr,reportFileConsistency,id,arg1,fileName,id,arg2,offset,int,arg3,bufferSize,int,arg4,seq,int,arg5){
}
CHOptimizedMethod(1, self, void, ClientCheckMgr,checkConsistency,id,arg1){
}
CHOptimizedMethod(0, self, void, ClientCheckMgr,test1){
}
CHOptimizedMethod(0, self, void, ClientCheckMgr,test){
}
CHDeclareClass(IWCLogger)
CHOptimizedMethod(1, self, void, IWCLogger,silentCrash,id,arg1){
}

CHDeclareClass(KSCrashDeadlockMonitor)
CHOptimizedMethod(0, self, void, KSCrashDeadlockMonitor,runMonitor){
}
CHOptimizedMethod(0, self, void, KSCrashDeadlockMonitor,handleDeadlock){
}
CHOptimizedMethod(0, self, void, KSCrashDeadlockMonitor,watchdogAnswer){
}
CHOptimizedMethod(0, self, void, KSCrashDeadlockMonitor,watchdogPulse){
}

CHDeclareClass(KSCrash)
CHOptimizedMethod(0, self, void, KSCrash,applicationWillTerminate){
}
CHOptimizedMethod(0, self, void, KSCrash,applicationWillEnterForeground){
}
CHOptimizedMethod(0, self, void, KSCrash,applicationDidEnterBackground){
}
CHOptimizedMethod(0, self, void, KSCrash,applicationWillResignActive){
}
CHOptimizedMethod(0, self, void, KSCrash,applicationDidBecomeActive){
    [self deleteAllReports];
}
CHOptimizedMethod(1, self, void, KSCrash,doctorReport,id,arg1){
    
}
CHOptimizedMethod(1, self, void, KSCrash,sendAllReportsWithCompletion,id,arg1){
    
}
CHOptimizedMethod(9, self, void, KSCrash,reportUserException,id,arg1,reason,id,arg2,language,id,arg3,lineOfCode,id,arg4,stackTrace,id,arg5,logAllThreads,BOOL,arg6,terminateProgram,BOOL,arg7,dumpFilePath,id,arg8,dumpType,int,arg9){
    [self deleteAllReports];
}
CHOptimizedMethod(7, self, void, KSCrash,reportUserException,id,arg1,reason,id,arg2,language,id,arg3,lineOfCode,id,arg4,stackTrace,id,arg5,logAllThreads,BOOL,arg6,terminateProgram,BOOL,arg7){
    [self deleteAllReports];
}

CHDeclareClass(MemoryStatManager)
CHOptimizedMethod(0, self, void, MemoryStatManager,onSignalCrash){
}
CHOptimizedMethod(1, self, void, MemoryStatManager,uploadReport,id,arg1){
}
CHOptimizedMethod(0, self, void, MemoryStatManager,uploadAllFullReport){
}
CHOptimizedMethod(0, self, void, MemoryStatManager,checkAndRecord){
}

CHDeclareClass(MMCrashProtectedMgr)
CHOptimizedMethod(0, self, void, MMCrashProtectedMgr,checkHasCrashAndDoReportJob){
}
CHOptimizedMethod(0, self, void, MMCrashProtectedMgr,checkMayCrashAndMarkAsHasCrash){
}
CHOptimizedMethod(0, self, void, MMCrashProtectedMgr,checkDataValid){
}

CHDeclareClass(MMOOMCrashReport)
CHOptimizedMethod(0, self, void, MMOOMCrashReport,onMonoServiceDidEnd){
}
CHOptimizedMethod(0, self, void, MMOOMCrashReport,onMonoServiceWalkieTalkieWillStart){
}
CHOptimizedMethod(0, self, void, MMOOMCrashReport,onMonoServiceMultitalkWillStart){
}
CHOptimizedMethod(0, self, void, MMOOMCrashReport,onMonoServiceVoipWillStart){
}
CHClassMethod0(void, MMOOMCrashReport, reportWeAppCrashScene){
}
CHClassMethod0(void, MMOOMCrashReport, reportWeAppFoomScene){
}
CHClassMethod0(void, MMOOMCrashReport, reportFoomScene){
}
CHClassMethod1(void, MMOOMCrashReport, reportIDKEYByTypeOS,long long,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, reportIDKEYByType,long long,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, userHasWatch,BOOL,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, setDumpFileName,id,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, isForegroundMainThreadBlock,BOOL,arg1){
}
CHClassMethod0(BOOL, MMOOMCrashReport, isLastTimeFOOM){
    return YES;
}
CHClassMethod0(BOOL, MMOOMCrashReport, isOSReboot){
    return YES;
}
CHClassMethod0(BOOL, MMOOMCrashReport, isOSChange){
    return YES;
}
CHClassMethod0(BOOL, MMOOMCrashReport, isAppChange){
    return YES;
}
CHClassMethod0(void, MMOOMCrashReport, enterForeground){
}
CHClassMethod0(void, MMOOMCrashReport, willSuspend){
}
CHClassMethod0(void, MMOOMCrashReport, enterBackground){
}
CHClassMethod0(void, MMOOMCrashReport, registerExtension){
}
CHClassMethod1(void, MMOOMCrashReport, setWeAppName,id,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, setScene,id,arg1){
}
CHClassMethod1(void, MMOOMCrashReport, setFlag,id,arg1){
}
CHClassMethod0(void, MMOOMCrashReport, checkAndReport){
}
CHClassMethod0(void, MMOOMCrashReport, checkRebootType){
}

CHDeclareClass(MMSafeModeMgr)
CHOptimizedMethod(0, self, void, MMSafeModeMgr,onReportAndUpdateConfigTimeout){
}
CHOptimizedMethod(0, self, void, MMSafeModeMgr,doCrashReport){
}
CHOptimizedMethod(0, self, void, MMSafeModeMgr,initCrashUsrName){
}
CHOptimizedMethod(0, self, void, MMSafeModeMgr,notifyReportAndUpdateConfigFinished){
}
CHOptimizedMethod(0, self, void, MMSafeModeMgr,doReportAndUpdateConfig){
}
CHOptimizedMethod(0, self, void, MMSafeModeMgr,doSafeModeSceneIDKeyReport){
}
CHOptimizedMethod(1, self, void, MMSafeModeMgr,setCrashUsrName,id,arg1){
}
CHOptimizedMethod(2, self, void, MMSafeModeMgr,reportDataWithKey,int,arg1,value,int,arg2){
}

CHDeclareClass(WCCrashReporterMgr)
CHClassMethod4(void, WCCrashReporterMgr, reportWithID,int,arg1,ext,id,arg2,isReportNow,BOOL,arg3,isKeyLog,BOOL,arg4){
}
CHClassMethod3(void, WCCrashReporterMgr, reportId,int,arg1,key,int,arg2,andValue,int,arg3){
}

CHOptimizedMethod(2, self, void, WCCrashReporterMgr,reportCrashReportCount,BOOL,arg1,withMatrixIssue,id,arg2){
}
CHOptimizedMethod(2, self, void, WCCrashReporterMgr,reportCrashReportResult,BOOL,arg1,withMatrixIssue,id,arg2){
}
CHOptimizedMethod(1, self, void, WCCrashReporterMgr,reportCrashWithMatrixIssue,id,arg1){
}
CHOptimizedMethod(2, self, void, WCCrashReporterMgr,handleReportCrashIssue,id,arg1,success,BOOL,arg2){
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,refreshCrashReportInfo){
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,saveCrashReportInfo){
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,loadCrashReportInfo){
}
CHOptimizedMethod(1, self, void, WCCrashReporterMgr,p_tryUpload,BOOL,arg1){
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,p_doCrashReport){
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,reportCrash){
}
CHOptimizedMethod(0, self, BOOL, WCCrashReporterMgr,reportCrashReportOnSafeMode){
    return YES;
}
CHOptimizedMethod(0, self, void, WCCrashReporterMgr,delayReportCrash){
}


CHDeclareClass(SafeDeviceData)
CHClassMethod1(void, SafeDeviceData, SetSafeDeviceList,id,arg1){
    NSLog(@"");
}
CHClassMethod2(void, SafeDeviceData, UpdateSafeDevice,id,arg1,withName,id,arg2){
    NSLog(@"");
}
CHClassMethod1(void, SafeDeviceData, DelSafeDevice,id,arg1){
    NSLog(@"");
}


CHDeclareClass(NewSettingViewController)
CHOptimizedMethod(0, self, void, NewSettingViewController,reloadTableData){
    NSLog(@"");
    CHSuper(0, NewSettingViewController, reloadTableData);
}

CHDeclareClass(MoreViewController)
CHOptimizedMethod(0, self, void, MoreViewController,showEmoticonStoreView){
    NSLog(@"");
    //    CHSuper(0, MoreViewController, showEmoticonStoreView);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [[ShakeMMViewController alloc] init];
        [((UIViewController *)self).navigationController PushViewController:vc animated:true];
    });
}

CHDeclareClass(MMTableViewUserInfo)
CHOptimizedMethod(2, self, void, MMTableViewUserInfo,addUserInfoValue,id,value,forKey,NSString *,key){

    if([value isKindOfClass:NSClassFromString(@"NSString")] && [value isEqualToString:@"MoreExpressionShops.png"])
    {
        CHSuper(2, MMTableViewUserInfo, addUserInfoValue,@"助手",forKey,@"title");
    }
    CHSuper(2, MMTableViewUserInfo, addUserInfoValue,value,forKey,key);

}


//CHDeclareClass(CMessageMgr)
//CHOptimizedMethod(2, self, void, CMessageMgr,AsyncOnAddMsg,id,arg1,MsgWrap,CMessageWrap * ,arg2){
//
//    if(arg2.m_uiMessageType == 49 && ([[arg2 m_nsContent] rangeOfString:@"wxpay://"].location != NSNotFound))
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[ShakeMMHelperConfig shared] playCashReceivedAudio];
//        });
//
//    }
//    CHSuper(2, CMessageMgr, AsyncOnAddMsg,arg1,MsgWrap,arg2);
//}


CHDeclareClass(MMTabBarController)
CHOptimizedMethod(0, self, void, MMTabBarController,viewDidLoad)
{
    CHSuper(0, MMTabBarController, viewDidLoad);
    
    dispatch_after(2, dispatch_get_main_queue(), ^{
        [ShakeMMHelper shared];
    });
    
}

//所有被hook的类和函数放在这里的构造函数中
CHConstructor
{
    @autoreleasepool
    {

        CHLoadLateClass(WXGCrashReportExtensionHandler);
        CHHook2(WXGCrashReportExtensionHandler, addLogInfo, withMessage);
        
        
        
        CHLoadLateClass(JailBreakHelper);
        CHHook0(JailBreakHelper, HasInstallJailbreakPluginInvalidIAPPurchase);
        CHHook1(JailBreakHelper, HasInstallJailbreakPlugin);
        CHHook0(JailBreakHelper, IsJailBreak);
        
        
        CHLoadLateClass(BaseMsgContentViewController);
        CHHook2(BaseMsgContentViewController, tableView,didSelectRowAtIndexPath);
        
        CHLoadLateClass(WCSiriMgr);
        CHHook0(WCSiriMgr, isSiriKitAvailable);
         
        CHLoadLateClass(MMTabBarController);
        CHHook0(MMTabBarController, viewDidLoad);
        
        
    }
}

