//
//  CamListViewController.m
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "CamListViewController.h"
#import "CamListTableCell.h"
#import "PortraitCamViewController.h"
#import "CameraInfo.h"
#include "APICommon.h"
#import "PPPPDefine.h"
#import "obj_common.h"

@interface CamListViewController ()
@property (nonatomic, retain) NSCondition* m_PPPPChannelMgtCondition;
@property (nonatomic, retain) NSString* cameraID;
@end

@implementation CamListViewController

@synthesize tableView, nameBufferForAdd, UIDBufferForAdd, camList, numOfCameras;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]){
            UIView* v = obj;
            [[v.subviews objectAtIndex:1] removeFromSuperview];
            *stop=YES;
        }
    }];
    
    camList = [[NSMutableArray alloc] init];
    
    numOfCameras = [[NSUserDefaults standardUserDefaults] integerForKey:@"num_of_cameras"];
    for (int i = 1; i <= numOfCameras; i++) {
        NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@%d", @"cam_name", i]];
        NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"%@%d", @"cam_uid", i]];
        CameraInfo *cameraInfo = [[CameraInfo alloc] init];
        [cameraInfo setName:name];
        [cameraInfo setUID:uid];
        [camList addObject:cameraInfo];
    }
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter addObserver:self selector:@selector(sendNameWithNoti:) name:@"sendName" object:nil];
    [notiCenter addObserver:self selector:@selector(sendUIDWithNoti:) name:@"sendUID" object:nil];
    [notiCenter addObserver:self selector:@selector(addNewCameraWithNoti:) name:@"addNewCamera" object:nil];
    
    _m_PPPPChannelMgtCondition = [[NSCondition alloc] init];
    _m_PPPPChannelMgt = new CPPPPChannelManagement();
    _m_PPPPChannelMgt->pCameraViewController = self;
    
    PPPP_Initialize((char*)[@"EFGBFFBJKDJBGNJBEBGMFOEIHPNFHGNOGHFBBOCPAJJOLDLNDBAHCOOPGJLMJGLKAOMPLMDINEIOLMFAFCPJJGAM" UTF8String]);//Input your company server address
    st_PPPP_NetInfo NetInfo;
    PPPP_NetworkDetect(&NetInfo, 0);
    
    [_m_PPPPChannelMgtCondition lock];
    if (_m_PPPPChannelMgt == NULL) {
        [_m_PPPPChannelMgtCondition unlock];
        return;
    }
    _m_PPPPChannelMgt->StopAll();
        
    for (int i = 0; i < numOfCameras; i++) {
        CameraInfo *cameraInfo = [camList objectAtIndex:i];
        [self performSelector:@selector(startPPPP:) withObject:[cameraInfo getUID]];
    }
    
    [_m_PPPPChannelMgtCondition unlock];
    
}

- (void) startPPPP:(NSString*) camID{
    _m_PPPPChannelMgt->Start([camID UTF8String], [@"admin" UTF8String], [@"888888" UTF8String]);
}

- (void)viewDidUnload
{
    _m_PPPPChannelMgt->StopAll();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendUID" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addNewCamera" object:nil];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [camList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *camListTableIdentifier = @"CamListTableCell";
    CamListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:camListTableIdentifier];
    CameraInfo *cameraInfo = [camList objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CamListItem" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.name.text = [NSString stringWithString:[cameraInfo getName]];
    cell.uid.text = [NSString stringWithString:[cameraInfo getUID]];
    cell.status.text = [NSString stringWithString:[cameraInfo getStatus]];
    
//    static NSString *simpleTableIdentifier = @"CamCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//    }
//    cell.textLabel.text = [camList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CameraInfo *cameraInfo = [camList objectAtIndex:indexPath.row];
    PortraitCamViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Portrait"];
    vc.name = [NSString stringWithString:[cameraInfo getName]];
    vc.uid = [NSString stringWithString:[cameraInfo getUID]];
    
    [self.navigationController presentModalViewController:vc animated:YES];
}

- (IBAction)back:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendNameWithNoti:(NSNotification *)noti {
    NSString *name = [[noti userInfo] objectForKey:@"name"];
    if (name) {
        nameBufferForAdd = [[NSString alloc] initWithString:name];
    }
}

- (void)sendUIDWithNoti:(NSNotification *)noti {
    NSString *uid = [[noti userInfo] objectForKey:@"UID"];
    if (uid) {
        UIDBufferForAdd = [[NSString alloc] initWithString:uid];
    }
}

- (void)addNewCameraWithNoti:(NSNotification *)noti {
    CameraInfo *cameraInfo = [[CameraInfo alloc] init];
    [cameraInfo setName:nameBufferForAdd];
    [cameraInfo setUID:UIDBufferForAdd];
    [camList addObject:cameraInfo];
    [tableView reloadData];
    
    numOfCameras++;
    [[NSUserDefaults standardUserDefaults] setInteger:numOfCameras forKey:@"num_of_cameras"];
    [[NSUserDefaults standardUserDefaults] setValue:nameBufferForAdd forKey:[NSString stringWithFormat:@"%@%d", @"cam_name", numOfCameras]];
    [[NSUserDefaults standardUserDefaults] setValue:UIDBufferForAdd forKey:[NSString stringWithFormat:@"%@%d", @"cam_uid", numOfCameras]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//PPPPStatusDelegate
- (void) PPPPStatus: (NSString*) strDID statusType:(NSInteger) statusType status:(NSInteger) status{
    NSString* strPPPPStatus;
    switch (status) {
        case PPPP_STATUS_UNKNOWN:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECTING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnecting", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INITIALING:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInitialing", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_FAILED:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectFailed", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DISCONNECT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusDisconnected", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_ID:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvalidID", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_DEVICE_NOT_ON_LINE:
            strPPPPStatus = NSLocalizedStringFromTable(@"CameraIsNotOnline", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_CONNECT_TIMEOUT:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusConnectTimeout", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        case PPPP_STATUS_INVALID_USER_PWD:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusInvaliduserpwd", @STR_LOCALIZED_FILE_NAME, nil);
            break;
        default:
            strPPPPStatus = NSLocalizedStringFromTable(@"PPPPStatusUnknown", @STR_LOCALIZED_FILE_NAME, nil);
            break;
    }
    
    for (int i = 0; i < numOfCameras; i++) {
        CameraInfo *cameraInfo = [camList objectAtIndex:i];
        
        if ([[cameraInfo getUID] isEqualToString:strDID]) {
            [cameraInfo setStatus:strPPPPStatus];
            [tableView reloadData];
            break;
        }
    }
    
    NSLog(@"PPPPStatus  %@",strPPPPStatus);
}

@end
