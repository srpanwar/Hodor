//
//  HDRUtils.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HDRUtils.h"

@implementation HDRUtils

+ (void) playSound
{
//    [AVAudioSession sharedInstance]  
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Hodor1" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


+ (void) playSoundIncoming
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"incoming" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void) playSoundOutgoing
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"outgoing" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
