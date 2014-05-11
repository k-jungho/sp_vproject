//
//  CamListViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PPPP_API.h"
#include "PPPPChannelManagement.h"

@interface CamListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *nameBufferForAdd;
    NSString *UIDBufferForAdd;
    NSMutableArray *camList;
    int numOfCameras;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *nameBufferForAdd;
@property (nonatomic, strong) NSString *UIDBufferForAdd;
@property (nonatomic, strong) NSMutableArray *camList;
@property (nonatomic, readwrite) int numOfCameras;
@property  CPPPPChannelManagement* m_PPPPChannelMgt;

- (IBAction)back:(id)sender;
- (void)sendNameWithNoti:(NSNotification *)noti;
- (void)sendUIDWithNoti:(NSNotification *)noti;
- (void)addNewCameraWithNoti:(NSNotification *)noti;

@end
