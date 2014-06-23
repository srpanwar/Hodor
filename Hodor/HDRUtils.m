//
//  HDRUtils.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/23/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRUtils.h"

@implementation HDRUtils

+ (void) playSound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Hodor" ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}


@end
