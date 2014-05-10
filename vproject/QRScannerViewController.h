//
//  QRScannerViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRScannerViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIBarPositioningDelegate>

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIView *viewPreview;

- (IBAction)cancel:(id)sender;

@end
