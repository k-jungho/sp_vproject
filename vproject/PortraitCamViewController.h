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

@interface PortraitCamViewController : UIViewController<ImageNotifyProtocol> {
    BOOL backFromLandscape;
    NSString *name;
    NSString *uid;
}

@property (nonatomic) BOOL backFromLandscape;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *uid;

- (IBAction)toLandscape:(id)sender;
- (IBAction)back:(id)sender;
- (void)backFromLandscapeWithNoti:(NSNotification *)noti;

@property (nonatomic, retain) IBOutlet UIImageView* playView;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;

- (IBAction)Initialize:(id)sender;
- (IBAction)ConnectCam:(id)sender;
- (IBAction)starVideo:(id)sender;
- (IBAction)starAudio:(id)sender;
- (IBAction)stopVideo:(id)sender;
- (IBAction)stopAudio:(id)sender;
- (IBAction)stopCamera:(id)sender;

@end
