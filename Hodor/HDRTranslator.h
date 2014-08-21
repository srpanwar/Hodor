//
//  HDRTranslator.h
//  Hodor
//
//  Created by Shailesh Panwar on 8/20/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDRTranslator : NSObject

@property NSArray *phrase1;
@property NSArray *phrase2;

@property NSArray *words1;
@property NSArray *words2;

@property NSArray *intraword1;
@property NSArray *intraword2;

@property NSArray *prefixes1;
@property NSArray *prefixes2;

@property NSArray *suffixes1;
@property NSArray *suffixes2;

- (NSString *)translate:(NSString *)sentence;

@end
