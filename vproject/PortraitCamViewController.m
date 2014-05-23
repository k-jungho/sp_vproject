//
//  PortraitCamViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "PortraitCamViewController.h"
#import "LandscapeCamViewController.h"
#include "MyAudioSession.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"
#import "objc/message.h"

@interface PortraitCamViewController ()
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property (nonatomic, retain) NSString* cameraID;
@end

@implementation PortraitCamViewController

@synthesize isInitialized, isPortrait, isFeeding, isMicOn, isSpeakerOn, isPlaying, name, uid, timer, feedButton, micButton, speakerButton, playButton, portrait, landscape, speakerImage, micImage, moreButton, lessButton, feedAmountImage, feedAmount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    self.navigationBar.delegate = self;
	// Do any additional setup after loading the view.
    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
    
    InitAudioSession();
    
    isInitialized = YES;
    isPortrait = YES;
    isFeeding = NO;
    isMicOn = NO;
    isSpeakerOn = YES;
    feedAmount = 3;
    
    [portrait setHidden:NO];
    [landscape setHidden:YES];
    
//    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
//    st_PPPP_NetInfo NetInfo;
//    PPPP_NetworkDetect(&NetInfo, 0);
    
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    dispatch_async(dispatch_get_main_queue(),^{
        _portraitPlayView.image = nil;
        _landscapePlayView.image = nil;
    });
    
    _navigationBar.topItem.title = [NSString stringWithString:name];
    //self.title = [NSString stringWithString:name];
    _cameraID = uid;
    
    [self performSelector:@selector(startPPPP:) withObject:_cameraID];
    [_m_PPPPChannelMgtCondition unlock];
    
//    if (_m_PPPPChannelMgt != NULL) {
//        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, self) == 0) {
//            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
//            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
//            return;
//        }
//        _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"changeToLandscape"]) {
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
//}

//- (NSUInteger)supportedInterfaceOrientations {
//    if (isPortrait) {
//        return UIInterfaceOrientationMaskPortrait;
//        [portrait setHidden:NO];
//        [landscape setHidden:YES];
//        
//    }
//    else {
//        return UIInterfaceOrientationMaskLandscape;
//        [portrait setHidden:YES];
//        [landscape setHidden:NO];
//    }
//}
//
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

-(BOOL)shouldAutorotate
{
    if( isInitialized == NO ) {
        return UIInterfaceOrientationMaskPortrait;
    }
    if (isPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    if( isInitialized == NO ) {
        return UIInterfaceOrientationMaskPortrait;
    }
    if (isPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    }
    else {
        return UIInterfaceOrientationMaskLandscape;
    }
}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    if( isInitialized == NO ) {
//        return UIInterfaceOrientationPortrait;
//    }
//    if (isPortrait) {
//        return UIInterfaceOrientationPortrait;
//    }
//    else {
//        return UIInterfaceOrientationLandscapeRight;
//    }
//}

- (void)orientationChanged:(NSNotification *)notification {
//    if (isPortrait) {
//        if ( [portrait isHidden ] == YES )
//            [portrait setHidden:NO];
//        if ( [landscape isHidden ] == NO )
//            [landscape setHidden:YES];
//    }
//    else {
//        if ( [portrait isHidden ] == NO )
//            [portrait setHidden:YES];
//        if ( [landscape isHidden ] == YES )
//            [landscape setHidden:NO];
//    }
}

- (IBAction)changeOrientation:(id)sender {
    isPortrait = !isPortrait;
//    if (isPortrait) {
//        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
//    }
//    else {
//        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeLeft);
//    }
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            objc_msgSend([UIDevice currentDevice],@selector(setOrientation:),UIInterfaceOrientationLandscapeLeft );
            [landscape setHidden:NO];
            [portrait setHidden:YES];
        }else
        {
            objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
            [portrait setHidden:NO];
            [landscape setHidden:YES];
        }
        
    }
}

- (IBAction)back:(id)sender {
    if (isMicOn) {
        _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
        [micButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        isMicOn = NO;
    }
    if (isSpeakerOn) {
        _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
        [speakerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        isSpeakerOn = NO;
    }
    if (isPlaying) {
        
        _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
        dispatch_async(dispatch_get_main_queue(),^{
            _portraitPlayView.image = nil;
            _landscapePlayView.image = nil;
        });
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        isPlaying = NO;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Initialize:(id)sender{
    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
}

- (IBAction)ConnectCam:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    dispatch_async(dispatch_get_main_queue(),^{
        _portraitPlayView.image = nil;
        _landscapePlayView.image = nil;
    });
    
    if ([(UIButton*)sender tag] == 10) {
        _cameraID = @"VSTC000047ETDPX";//JPEG
    }else if ([(UIButton*)sender tag] == 11){
        _cameraID = @"VSTC004383KZGFR";//H264
    }
    
    [self performSelector:@selector(startPPPP:) withObject:_cameraID];
    [_m_PPPPChannelMgtCondition unlock];
}

- (IBAction)starVideo:(id)sender{
    if (_m_PPPPChannelMgt != NULL) {
        if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, self) == 0) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
            return;
        }
        _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
        [speakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        isSpeakerOn = YES;
    }
}

- (IBAction)starAudio:(id)sender{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (IBAction)stopVideo:(id)sender{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _portraitPlayView.image = nil;
        _landscapePlayView.image = nil;
    });
}

- (IBAction)stopAudio:(id)sender{
    _m_PPPPChannelMgt->Stop([_cameraID UTF8String]);
}

- (IBAction)stopCamera:(id)sender{
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    [_m_PPPPChannelMgtCondition unlock];
    dispatch_async(dispatch_get_main_queue(),^{
        _portraitPlayView.image = nil;
        _landscapePlayView.image = nil;
    });
    
}

- (void) startPPPP:(NSString*) camID{
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
}

- (IBAction)controlFeedAmount:(id)sender {
    switch ([sender tag]) {
        case 1:
            if (feedAmount < 5) {
                feedAmount++;
            }
            break;
        case -1:
            if (feedAmount > 0) {
                feedAmount--;
            }
            break;
    }
    
    switch (feedAmount) {
        case 1:
        {
            UIImage *feed1 = [UIImage imageNamed:@"001.png"];
            [feedAmountImage setImage:feed1];
        }
            break;
            
        case 2:
        {
            UIImage *feed2 = [UIImage imageNamed:@"002.png"];
            [feedAmountImage setImage:feed2];
        }
            break;
            
        case 3:
        {
            UIImage *feed3 = [UIImage imageNamed:@"003.png"];
            [feedAmountImage setImage:feed3];
        }
            break;
            
        case 4:
        {
            UIImage *feed4 = [UIImage imageNamed:@"004.png"];
            [feedAmountImage setImage:feed4];
        }
            break;
            
        case 5:
        {
            UIImage *feed5 = [UIImage imageNamed:@"005.png"];
            [feedAmountImage setImage:feed5];
        }
            break;
    }
}

- (IBAction)feed:(id)sender {
//    if (isFeeding) {
//        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
//        isFeeding = NO;
//    }
//    else {
//        
//        isFeeding = YES;
//    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.8f
                                                          target:self
                                                        selector:@selector(activateFeed:)
                                                        userInfo:nil
                                                         repeats:YES];
//    for(int i = 0; i < 38; i++) {
//        _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT);
//    }
    
//    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT);
    //_m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_CENTER);
    //_m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT);
    //_m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SETE);
    //_m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SETF);
//    timer = [NSTimer scheduledTimerWithTimeInterval:11.58f*5
//                                             target:self
//                                           selector:@selector(activateFeed:)
//                                           userInfo:nil
//                                            repeats:NO];
//    
    [feedButton setAlpha:0.0f];
}

- (void)activateFeed:(NSTimer *)calledTimer {
    static int counter = 0;
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_DOWN);
    if (++counter == 18) {
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        //_m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_RIGHT_STOP);
        [feedButton setAlpha:1.0f];
        counter = 0;
    }
    NSLog(@"%d", counter);
//    if (timer != nil) {
//        [timer invalidate];
//        timer = nil;
//    }
//    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_LEFT_RIGHT_STOP);
//    [feedButton setAlpha:1.0f];
}

- (IBAction)mic:(id)sender {
    if (isMicOn) {
        _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
        [micButton setTitle:@"Tab to Speak" forState:UIControlStateNormal];
        //[micButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIImage *mic_off = [UIImage imageNamed:@"mic_off.png"];
        [micImage setImage:mic_off];
        isMicOn = NO;
    }
    else {
        _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
        [micButton setTitle:@"Speaking..." forState:UIControlStateNormal];
        //[micButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UIImage *mic_on = [UIImage imageNamed:@"mic_on.png"];
        [micImage setImage:mic_on];
        isMicOn = YES;
    }
}

- (IBAction)speaker:(id)sender {
    if (isSpeakerOn) {
        _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
        //[speakerButton setTitle:@"Speaker Off" forState:UIControlStateNormal];
        //[speakerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        UIImage *toggle_off = [UIImage imageNamed:@"volume_toggle_off.png"];
        [speakerButton setImage:toggle_off forState:UIControlStateNormal];
        UIImage *volume_off = [UIImage imageNamed:@"volume_off.png"];
        [speakerImage setImage:volume_off];
        isSpeakerOn = NO;
    }
    else {
        _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
        //[speakerButton setTitle:@"Speaker On" forState:UIControlStateNormal];
        //[speakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UIImage *toggle_on = [UIImage imageNamed:@"volume_toggle_on.png"];
        [speakerButton setImage:toggle_on forState:UIControlStateNormal];
        UIImage *volume_on = [UIImage imageNamed:@"volume_on.png"];
        [speakerImage setImage:volume_on];
        isSpeakerOn = YES;
    }
}

- (IBAction)play:(id)sender {
    if (isPlaying) {
        if (isMicOn) {
            _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
            [micButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            isMicOn = NO;
        }
        if (isSpeakerOn) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            [speakerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            isSpeakerOn = NO;
        }
        _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
        dispatch_async(dispatch_get_main_queue(),^{
            _portraitPlayView.image = nil;
            _landscapePlayView.image = nil;
        });
        [playButton setTitle:@"Play" forState:UIControlStateNormal];
        isPlaying = NO;
    }
    else {
        if (_m_PPPPChannelMgt != NULL) {
            if (_m_PPPPChannelMgt->StartPPPPLivestream([_cameraID UTF8String], 10, self) == 0) {
                _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
                _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
                return;
            }
            _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
            [speakerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [playButton setTitle:@"Stop" forState:UIControlStateNormal];
            isSpeakerOn = YES;
        }
        isPlaying = YES;
    }
}

- (IBAction)capture:(id)sender {
    _m_PPPPChannelMgt->Snapshot([_cameraID UTF8String]);
}

- (IBAction)setBase:(id)sender {
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_SET0);
}

- (IBAction)goToBase:(id)sender {
    _m_PPPPChannelMgt->PTZ_Control([_cameraID UTF8String], CMD_PTZ_PREFAB_BIT_RUN0);
}

//ImageNotifyProtocol
- (void) ImageNotify: (UIImage *)image timestamp: (NSInteger)timestamp DID:(NSString *)did{
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) YUVNotify: (Byte*) yuv length:(int)length width: (int) width height:(int)height timestamp:(unsigned int)timestamp DID:(NSString *)did{
    UIImage* image = [APICommon YUV420ToImage:yuv width:width height:height];
    [self performSelector:@selector(refreshImage:) withObject:image];
}
- (void) H264Data: (Byte*) h264Frame length: (int) length type: (int) type timestamp: (NSInteger) timestamp{
    
}

//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    NSLog(@"PPPPStatus  %@",strPPPPStatus);
}

//refreshImage
- (void) refreshImage:(UIImage* ) image{
    if (image != nil) {
        dispatch_async(dispatch_get_main_queue(),^{
            _portraitPlayView.image = image;
            _landscapePlayView.image = image;
        });
    }
}
@end
