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
}

- (void)viewDidUnload
{
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

@end
