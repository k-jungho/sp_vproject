//
//  CameraInfo.m
//  vproject
//
//  Created by JungHo Kim on 2014. 5. 10..
//  Copyright (c) 2014년 vproject. All rights reserved.
//

#import "CameraInfo.h"

@implementation CameraInfo {
}


- (NSString *)getName {
    return name;
}

- (void)setName:(NSString *)_name {
    name = [NSString stringWithString:_name];
}

- (NSString *)getUID {
    return uid;
}

- (void)setUID:(NSString *)_uid {
    uid = [NSString stringWithString:_uid];
}

@end
