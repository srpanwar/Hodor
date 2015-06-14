//
//  HDRUtils.h
//  Hodor
//
//  Created by Shailesh Panwar on 6/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h> 
#import <AVFoundation/AVFoundation.h>

@interface HDRSoundService : NSObject

+ (void) playSound;
+ (void) playSoundIncoming;
+ (void) playSoundOutgoing;

@end
