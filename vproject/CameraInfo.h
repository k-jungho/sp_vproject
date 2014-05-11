//
//  CameraInfo.h
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 10..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraInfo : NSObject {
    NSString *name;
    NSString *uid;
    NSString *status;
    UIImageView *image;
}

- (NSString *)getName;
- (void)setName:(NSString *)name;
- (NSString *)getUID;
- (void)setUID:(NSString *)uid;
- (NSString *)getStatus;
- (void)setStatus:(NSString *)status;


@end
