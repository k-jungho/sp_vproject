//
//  ChangeToLandscape.m
//  vproject
//
//  Created by JungHo Kim on 2014. 4. 27..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "ChangeToLandscape.h"

@implementation ChangeToLandscape

- (void)perform {
    UIViewController *source = (UIViewController *)self.sourceViewController;
    UIViewController *destination = (UIViewController *)self.destinationViewController;
    
    [UIView transitionFromView:source.view
                        toView:destination.view
                      duration:1.0
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:nil];
}

@end
