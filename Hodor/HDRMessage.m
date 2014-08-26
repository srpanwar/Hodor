//
//  HDRMessage.m
//  Hodor
//
//  Created by Shailesh Panwar on 8/19/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRMessage.h"

@implementation HDRMessage

- (id)init
{
    self = [super init];
    if (self)
    {
        self.picture = @"";
        self.address = @"Earth";
    }
    
    return self;
}

@end
