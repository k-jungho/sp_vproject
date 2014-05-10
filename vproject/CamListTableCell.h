//
//  CamListTableCell.h
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CamListTableCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *status;
@property (nonatomic, strong) IBOutlet UILabel *uid;
@property (nonatomic, strong) IBOutlet UIImageView *camImage;

@end
