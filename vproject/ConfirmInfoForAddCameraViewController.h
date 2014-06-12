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
    IBOutlet UIButton *back;
    IBOutlet UIButton *next;
}

@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, readwrite) BOOL isStarted;
@property (nonatomic, readwrite) BOOL isCancelRequested;
@property (nonatomic, retain) IBOutlet UIButton *back;
@property (nonatomic, retain) IBOutlet UIButton *next;

- (IBAction)goPreviousStep:(id)sender;
-(IBAction)checkLoginInfoForNextStep:(id)sender;
-(IBAction)cancelAll:(id)sender;
- (IBAction)back_pressed:(id)sender;
- (IBAction)back_up:(id)sender;
- (IBAction)next_pressed:(id)sender;
- (IBAction)next_up:(id)sender;

@end
