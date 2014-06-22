//
//  HDRCommon.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EMPTY_GUID @"00000000-0000-0000-0000-000000000000"
#define ENC_GUID @"2711ea6a-d68a-4ffe-a431-6373325795bf"

#define CREATE_USER_ENDPOINT @"http://hodorservice.cloudapp.net/rest?method=createuser"
#define BLOCK_USER_ENDPOINT @"http://hodorservice.cloudapp.net/rest?method=blockuser"
#define SEND_HODOR_ENDPOINT @"http://hodorservice.cloudapp.net/rest?method=sendhodor"
#define SEND_DEVICETOKEN_ENDPOINT @"http://hodorservice.cloudapp.net/rest?method=setdevicetoken"

@interface HDRCommon : NSObject

@end
