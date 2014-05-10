//
//  LandscapeCamViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "LandscapeCamViewController.h"
#import "PortraitCamViewController.h"

@interface LandscapeCamViewController ()

@end

@implementation LandscapeCamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"changeToPortrait"]) {
//        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//    }
//}

- (IBAction)toPortrait:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backFromLandscape" object:nil userInfo:nil];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
