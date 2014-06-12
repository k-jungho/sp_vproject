//
//  LoginViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 9..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UIBarPositioningDelegate> {
    IBOutlet UIButton *login;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIButton *login;

- (IBAction)back:(id)sender;
- (IBAction)login_pressed:(id)sender;
- (IBAction)login_up:(id)sender;

@end
