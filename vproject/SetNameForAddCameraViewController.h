//
//  SetNameForAddCameraViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetNameForAddCameraViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UITextField *name;

-(IBAction)checkNameForNextStep:(id)sender;

@end
