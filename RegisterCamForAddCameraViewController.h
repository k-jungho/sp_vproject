//
//  RegisterCamForAddCameraViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCamForAddCameraViewController : UIViewController {
    IBOutlet UITextField *uid;
    BOOL isCancelRequested;
}

@property (nonatomic, strong) IBOutlet UITextField *uid;
@property (nonatomic, readwrite) BOOL isCancelRequested;

- (void)sendScannedUIDWithNoti:(NSNotification *)noti;
- (IBAction)goPreviousStep:(id)sender;
- (IBAction)checkUIDForNextStep:(id)sender;
- (IBAction)cancelAll:(id)sender;

@end
