//
//  ShowPhotoViewController.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 25..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoViewController : UIViewController {
    //IBOutlet UIImageView *photo;
    UIImage *src;
}

@property (nonatomic, retain) UIImage *src;
@property (nonatomic, retain) IBOutlet UIImageView *photo;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;

-(IBAction) backToAlbum:(id) sender;

@end
