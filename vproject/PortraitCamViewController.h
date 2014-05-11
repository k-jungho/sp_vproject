//
//  PortraitCamViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"

@interface PortraitCamViewController : UIViewController<ImageNotifyProtocol, UIBarPositioningDelegate> {
    BOOL isInitialized;
    NSString *name;
    NSString *uid;
    BOOL isPortrait;
    BOOL isFeeding;
    BOOL isMicOn;
    BOOL isSpeakerOn;
    BOOL isPlaying;
    NSTimer *timer;
    IBOutlet UIButton *feedButton;
    IBOutlet UIButton *micButton;
    IBOutlet UIButton *speakerButton;
    IBOutlet UIButton *playButton;
    
    IBOutlet UIView *portrait;
    IBOutlet UIView *landscape;
}

@property (nonatomic) BOOL isInitialized;
@property (nonatomic) BOOL isPortrait;
@property (nonatomic) BOOL isFeeding;
@property (nonatomic) BOOL isMicOn;
@property (nonatomic) BOOL isSpeakerOn;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) IBOutlet UIButton *feedButton;
@property (nonatomic, retain) IBOutlet UIButton *micButton;
@property (nonatomic, retain) IBOutlet UIButton *speakerButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIView *portrait;
@property (nonatomic, retain) IBOutlet UIView *landscape;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

- (void)orientationChanged:(NSNotification *)notification;
- (IBAction)changeOrientation:(id)sender;
- (IBAction)back:(id)sender;
- (void)backFromLandscapeWithNoti:(NSNotification *)noti;
- (void)activateFeed:(NSTimer *)calledTimer;

@property (nonatomic, retain) IBOutlet UIImageView* portraitPlayView;
@property (nonatomic, retain) IBOutlet UIImageView* landscapePlayView;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;

- (IBAction)Initialize:(id)sender;
- (IBAction)ConnectCam:(id)sender;
- (IBAction)starVideo:(id)sender;
- (IBAction)starAudio:(id)sender;
- (IBAction)stopVideo:(id)sender;
- (IBAction)stopAudio:(id)sender;
- (IBAction)stopCamera:(id)sender;
- (IBAction)feed:(id)sender;
- (IBAction)mic:(id)sender;
- (IBAction)speaker:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)capture:(id)sender;
- (IBAction)setBase:(id)sender;
- (IBAction)goToBase:(id)sender;

@end
