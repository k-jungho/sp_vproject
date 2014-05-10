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

@interface PortraitCamViewController ()
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property (nonatomic, retain) NSString* cameraID;
@end

@implementation PortraitCamViewController

@synthesize backFromLandscape, name, uid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backFromLandscapeWithNoti:(NSNotification *)noti {
    backFromLandscape = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
    
    InitAudioSession();
    
    backFromLandscape = NO;
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(backFromLandscapeWithNoti:) name:@"backFromLandscape" object:nil];
    
    
    
    
    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
    });
    
    self.title = [NSString stringWithString:name];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backFromLandscape" object:nil];
    
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

- (void)viewDidAppear:(BOOL)animated {
    if (backFromLandscape) {
        backFromLandscape = NO;
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)toLandscape:(id)sender {
//    NSString * storyboardName = @"Main_iPhone";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//    LandscapeCamViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Landscape"];
//    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)back:(id)sender {
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
        _playView.image = nil;
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
        
    }
}

- (IBAction)starAudio:(id)sender{
    _m_PPPPChannelMgt->StartPPPPAudio([_cameraID UTF8String]);
}

- (IBAction)stopVideo:(id)sender{
    _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
    _m_PPPPChannelMgt->StopPPPPLivestream([_cameraID UTF8String]);
    dispatch_async(dispatch_get_main_queue(),^{
        _playView.image = nil;
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
        _playView.image = nil;
    });
    
}

- (void) startPPPP:(NSString*) camID{
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
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
            _playView.image = image;
        });
    }
}
@end
