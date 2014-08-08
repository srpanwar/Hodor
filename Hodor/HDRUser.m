//
//  HDRUser.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/22/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRUser.h"

@implementation HDRUser

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isBlocked] forKey:@"isBlocked"];
    [encoder encodeObject:self.notification forKey:@"notification"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.notification = [decoder decodeObjectForKey:@"notification"];
        self.isBlocked = [(NSNumber *)[decoder decodeObjectForKey:@"isBlocked"] boolValue];
    }
    return self;
}
@end
