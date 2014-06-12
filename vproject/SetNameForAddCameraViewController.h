//
//  SetNameForAddCameraViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNameForAddCameraViewController : UIViewController {
    IBOutlet UIButton *next;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UIButton *next;

- (IBAction)checkNameForNextStep:(id)sender;
- (IBAction)next_pressed:(id)sender;
- (IBAction)next_up:(id)sender;

@end
