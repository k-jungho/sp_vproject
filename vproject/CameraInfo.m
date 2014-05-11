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
    if (name) {
        return name;
    }
    return @"";
}

- (void)setName:(NSString *)_name {
    name = [NSString stringWithString:_name];
}

- (NSString *)getUID {
    if (uid) {
        return uid;
    }
    return @"";
}

- (void)setUID:(NSString *)_uid {
    uid = [NSString stringWithString:_uid];
}

- (NSString *)getStatus {
    if (status) {
        return status;
    }
    return @"";
}

- (void)setStatus:(NSString *)_status {
    status = [NSString stringWithString:_status];
}

@end
