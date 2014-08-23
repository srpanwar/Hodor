//
//  WMLocationManager.h
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/30/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "HDRCurrentUser.h"

@interface HDRLocationManager : NSObject<CLLocationManagerDelegate>

+ (HDRLocationManager *) instance;

@property CLLocationManager *locationManager;

@property(assign, nonatomic) id<CLLocationManagerDelegate> delegate;

@end
