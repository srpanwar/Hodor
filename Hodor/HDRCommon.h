//
//  HDRCommon.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

//f7b35156-f55c-4f6b-8a35-eff380683e37
//86f09664-ae59-4008-962e-ba5d63a66987

#define EMPTY_GUID @"00000000-0000-0000-0000-000000000000"
#define ENC_GUID @"2711ea6a-d68a-4ffe-a431-6373325795bf"

#define HODOR_SERVICE_ENDPOINT @"http://hodorservice.cloudapp.net/rest/default.aspx"

#define PROFILE_PICTURE_BUCKET @"hodorprofilepictures"
#define MESSAGE_PICTURE_BUCKET @"hodormsgpictures"

#define PROFILE_PICTURE_ENDPOINT @"https://hodorprofilepictures.s3.amazonaws.com/%@"
#define MESSAGE_PICTURE_ENDPOINT @"https://hodormsgpictures.s3.amazonaws.com/%@"


#define USER_CHANNEL_ID 1
#define ANYWHERE_CHANNEL_ID 2
#define HERE_CHANNEL_ID 3

@interface HDRCommon : NSObject

@end
