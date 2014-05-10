//
//  ConfirmInfoForAddCameraViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmInfoForAddCameraViewController : UIViewController<UIAlertViewDelegate> {
    BOOL isStarted;
    BOOL isCancelRequested;
}

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, readwrite) BOOL isStarted;
@property (nonatomic, readwrite) BOOL isCancelRequested;

- (IBAction)goPreviousStep:(id)sender;
-(IBAction)checkLoginInfoForNextStep:(id)sender;
-(IBAction)cancelAll:(id)sender;

@end
