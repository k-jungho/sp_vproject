//
//  ConfirmInfoForAddCameraViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "ConfirmInfoForAddCameraViewController.h"
#import "CamListViewController.h"

@interface ConfirmInfoForAddCameraViewController ()

@end

@implementation ConfirmInfoForAddCameraViewController

@synthesize email, password, isStarted, isCancelRequested, back, next;

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
    isCancelRequested = NO;
    isStarted = YES;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPreviousStep:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkLoginInfoForNextStep:(id)sender {
    if ( email.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Email address is empty" message:@"Please input Email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else if ( password.text.length == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Password is empty" message:@"Please input password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"addNewCamera" object:nil userInfo:nil];
        
        // [self.navigationController popToViewController:vc animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(IBAction)cancelAll:(id)sender {
    isCancelRequested = YES;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Add Camera" message:@"Do you want to cancel it?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles: @"No", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( isCancelRequested ) {
        if( buttonIndex == 0 ) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        isCancelRequested = NO;
    }
}

- (IBAction)back_pressed:(id)sender {
    UIImage *back_p = [UIImage imageNamed:@"back_on.png"];
    [back setImage:back_p forState:UIControlStateNormal];
}

- (IBAction)back_up:(id)sender {
    UIImage *back_n = [UIImage imageNamed:@"back.png"];
    [back setImage:back_n forState:UIControlStateNormal];
}

- (IBAction)next_pressed:(id)sender {
    UIImage *next_p = [UIImage imageNamed:@"next_on.png"];
    [next setImage:next_p forState:UIControlStateNormal];
}

- (IBAction)next_up:(id)sender {
    UIImage *next_n = [UIImage imageNamed:@"next.png"];
    [next setImage:next_n forState:UIControlStateNormal];
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
