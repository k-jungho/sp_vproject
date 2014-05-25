//
//  PortraitCamViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "PortraitCamViewController.h"
#import "LandscapeCamViewController.h"
#import "ShowPhotoViewController.h"
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

@synthesize isInitialized, isPortrait, isFeeding, isMicOn, isSpeakerOn, isPlaying, name, uid, timer, feedButton, micButton, speakerButton, playButton, portrait, landscape, speakerImage, micImage, moreButton, lessButton, feedAmountImage, feedAmount, captureButtonImage, feedButton_landscape, micImage_landscape, speakerImage_landscape, moreButton_landscape, lessButton_landscape, feedAmountImage_landscape, captureButtonImage_landscape, albumImage, albumImage_landscape;

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

- (void)loadLastImage {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                
                UIImage *latestPhotoThumbnail =  [UIImage imageWithCGImage:[alAsset thumbnail]];
                [albumImage setImage:latestPhoto];
                [albumImage_landscape setImage:latestPhoto];
                
                // Stop the enumerations
                *stop = YES; *innerStop = YES;
                
                // Do something interesting with the AV asset.
                //[self sendTweet:latestPhoto];
            }
        }];
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
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
    isSpeakerOn = NO;
    feedAmount = 3;
    
    [portrait setHidden:NO];
    [landscape setHidden:YES];
    
    [self loadLastImage];
    
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

/*
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

- (void)orientationChanged:(NSNotification *)notification {
}

- (IBAction)changeOrientation:(id)sender {
    isPortrait = !isPortrait;
    
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
 */

- (void)orientationChanged:(NSNotification *)notification {
    //isPortrait = !isPortrait;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            //objc_msgSend([UIDevice currentDevice],@selector(setOrientation:),UIInterfaceOrientationLandscapeLeft );
            [portrait setHidden:NO];
            [landscape setHidden:YES];
        }
        else if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            //objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
            [landscape setHidden:NO];
            [portrait setHidden:YES];
        }
        
    }
}

-(BOOL)shouldAutorotate
{
    return YES;
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
            if (feedAmount > 2) {
                feedAmount--;
            }
            break;
    }
    
    switch (feedAmount) {
//        case 1:
//        {
//            UIImage *feed1 = [UIImage imageNamed:@"001.png"];
//            [feedAmountImage setImage:feed1];
//            [feedAmountImage_landscape setImage:feed1];
//        }
//            break;
            
        case 2:
        {
            UIImage *feed2 = [UIImage imageNamed:@"002.png"];
            [feedAmountImage setImage:feed2];
            [feedAmountImage_landscape setImage:feed2];
        }
            break;
            
        case 3:
        {
            UIImage *feed3 = [UIImage imageNamed:@"003.png"];
            [feedAmountImage setImage:feed3];
            [feedAmountImage_landscape setImage:feed3];
        }
            break;
            
        case 4:
        {
            UIImage *feed4 = [UIImage imageNamed:@"004.png"];
            [feedAmountImage setImage:feed4];
            [feedAmountImage_landscape setImage:feed4];
        }
            break;
            
        case 5:
        {
            UIImage *feed5 = [UIImage imageNamed:@"005.png"];
            [feedAmountImage setImage:feed5];
            [feedAmountImage_landscape setImage:feed5];
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
    [feedButton_landscape setAlpha:0.0f];
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
        [feedButton_landscape setAlpha:1.0f];
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
        UIImage *mic_off = [UIImage imageNamed:@"mic_off_landscape.png"];
        [micImage setImage:mic_off];
        UIImage *mic_off_landscape = [UIImage imageNamed:@"mic_off_landscape.png"];
        [micImage_landscape setImage:mic_off_landscape];
        isMicOn = NO;
    }
    else {
        _m_PPPPChannelMgt->StartPPPPTalk([_cameraID UTF8String]);
        [micButton setTitle:@"Speaking..." forState:UIControlStateNormal];
        //[micButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        UIImage *mic_on = [UIImage imageNamed:@"mic_on_landscape.png"];
        [micImage setImage:mic_on];
        UIImage *mic_on_landscape = [UIImage imageNamed:@"mic_on_landscape.png"];
        [micImage_landscape setImage:mic_on_landscape];
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
        [speakerImage_landscape setImage:volume_off];
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
        [speakerImage_landscape setImage:volume_on];
        isSpeakerOn = YES;
    }
}

- (IBAction)play:(id)sender {
    if (isPlaying) {
        if (isMicOn) {
            _m_PPPPChannelMgt->StopPPPPTalk([_cameraID UTF8String]);
            [micButton setTitle:@"Tab to Speak" forState:UIControlStateNormal];
            //[micButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            UIImage *mic_off = [UIImage imageNamed:@"mic_off_landscape.png"];
            [micImage setImage:mic_off];
            UIImage *mic_off_landscape = [UIImage imageNamed:@"mic_off_landscape.png"];
            [micImage_landscape setImage:mic_off_landscape];
            isMicOn = NO;
        }
        if (isSpeakerOn) {
            _m_PPPPChannelMgt->StopPPPPAudio([_cameraID UTF8String]);
            UIImage *toggle_off = [UIImage imageNamed:@"volume_toggle_off.png"];
            [speakerButton setImage:toggle_off forState:UIControlStateNormal];
            UIImage *volume_off = [UIImage imageNamed:@"volume_off.png"];
            [speakerImage setImage:volume_off];
            [speakerImage_landscape setImage:volume_off];
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
            [playButton setTitle:@"Stop" forState:UIControlStateNormal];
            UIImage *toggle_on = [UIImage imageNamed:@"volume_toggle_on.png"];
            [speakerButton setImage:toggle_on forState:UIControlStateNormal];
            UIImage *volume_on = [UIImage imageNamed:@"volume_on.png"];
            [speakerImage setImage:volume_on];
            [speakerImage_landscape setImage:volume_on];
            isSpeakerOn = YES;
        }
        isPlaying = YES;
        [playButton setAlpha:0.0f];
        [playButton setHidden:YES];
    }
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (IBAction)capture:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_landscapePlayView.bounds.size, _landscapePlayView.opaque, 0.0);
    [_landscapePlayView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    
    [captureButtonImage setFrame:CGRectMake(149, 14, 23, 23)];
    [captureButtonImage_landscape setFrame:CGRectMake(18, 148, 23, 23)];
}

- (IBAction)captureDown:(id)sender {
    [captureButtonImage setFrame:CGRectMake(144, 9, 33, 33)];
    [captureButtonImage_landscape setFrame:CGRectMake(13,143, 33, 33)];
}
- (IBAction)captureUpOver:(id)sender {
    [captureButtonImage setFrame:CGRectMake(149, 14, 23, 23)];
    [captureButtonImage_landscape setFrame:CGRectMake(18, 148, 23, 23)];
}

-(void)addPhoto:(ALAssetRepresentation *)asset
{
    //NSLog(@"Adding photo!");
    //[photos addObject:asset];
}

-(void)loadPhotos
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             // Within the group enumeration block, filter if necessary
             [group setAssetsFilter:[ALAssetsFilter allPhotos]];
             [group enumerateAssetsUsingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
              {
                  // The end of the enumeration is signaled by asset == nil.
                  if (alAsset)
                  {
                      ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                      [self addPhoto:representation];
                  }
                  else
                  {
                      NSLog(@"Done! Count = %d", photos.count);
                      //Do something awesome
                  }
              }];
         }
                             failureBlock: ^(NSError *error) {
                                 // Typically you should handle an error more gracefully than this.
                                 NSLog(@"No groups");
                             }];
    }
}

-(IBAction) getPhoto:(id) sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    ShowPhotoViewController *photoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowPhoto"];
    photoViewController.src = image;
    [picker presentModalViewController:photoViewController animated:YES];
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
