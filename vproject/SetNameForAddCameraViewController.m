//
//  SetNameForAddCameraViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "SetNameForAddCameraViewController.h"
#import "RegisterCamForAddCameraViewController.h"
@interface SetNameForAddCameraViewController ()

@end

@implementation SetNameForAddCameraViewController

@synthesize scrollView, name;

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

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)checkNameForNextStep:(id)sender {
    if ( name.text.length > 0 ) {
        // must check duplicate key.
        RegisterCamForAddCameraViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterCamForAddCamera"];
        [self.navigationController pushViewController:vc animated:YES];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:name.text forKey:@"name"];
        [notificationCenter postNotificationName:@"sendName" object:nil userInfo:dic];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Cam name is empty" message:@"Please input cam name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
