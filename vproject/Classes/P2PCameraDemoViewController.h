//
//  P2PCameraDemoViewController.h
//  P2PCamera
//
//  Created by yan luke on 13-6-13.
//
//

#import <UIKit/UIKit.h>
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"
#import "ImageNotifyProtocol.h"
@interface P2PCameraDemoViewController : UIViewController<ImageNotifyProtocol>{
    
}
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
