//
//  LoginViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 9..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIBarPositioningDelegate>

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

- (IBAction)back:(id)sender;

@end
