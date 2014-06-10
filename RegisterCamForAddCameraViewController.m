//
//  RegisterCamForAddCameraViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 7..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "RegisterCamForAddCameraViewController.h"
#import "ConfirmInfoForAddCameraViewController.h"

@interface RegisterCamForAddCameraViewController ()

@end

@implementation RegisterCamForAddCameraViewController

@synthesize uid, isCancelRequested;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)sendScannedUIDWithNoti:(NSNotification *)noti {
    NSString *UID = [[noti userInfo] objectForKey:@"UID"];
    if (UID) {
        [uid setText:UID];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(sendScannedUIDWithNoti:) name:@"sendScannedUID" object:nil];
    [notiCenter addObserver:self selector:@selector(sendNameWithNoti:) name:@"sendName" object:nil];
    
    isCancelRequested = NO;
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendScannedUID" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendName" object:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)goPreviousStep:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkUIDForNextStep:(id)sender {
    if ( uid.text.length > 0 ) {
        // must check duplicate key.
        ConfirmInfoForAddCameraViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmInfoForAddCamera"];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:uid.text forKey:@"UID"];
        [notificationCenter postNotificationName:@"sendUID" object:nil userInfo:dic];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"UID is empty" message:@"Please input UID" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
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
