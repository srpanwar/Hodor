//
//  WMLocationManager.m
//  WhereMsg
//
//  Created by Shailesh Panwar on 4/30/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRLocationManager.h"

@implementation HDRLocationManager

+ (HDRLocationManager *) instance
{
    static HDRLocationManager *that = nil;
    @synchronized(self)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            that = [[self alloc] init];
        });
    }
    return that;
}

-(id) init
{
    self = [super init];
    if (self)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.activityType = CLActivityTypeFitness;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 30;
        self.locationManager.delegate = self;
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* location = [locations lastObject];
//    if (location.horizontalAccuracy > 0 && location.horizontalAccuracy < 600)
    {
        //NSDate* eventDate = location.timestamp;
        //NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        //if (abs(howRecent) < 15.0)
        {
            //one location update foreground
            if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
            {
                [self.delegate locationManager:manager didUpdateLocations:locations];
                //update the user location
                [HDRCurrentUser setLastLocation:location.coordinate];
                [HDRCurrentUser setAddress:[NSString stringWithFormat:@"(%0.2f, %0.2f)", location.coordinate.latitude, location.coordinate.longitude]];
                
                //if address is mising then try to geocode lat lon
                CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
                
                [geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray* placemarks, NSError* error){
                    if ([placemarks count] > 0)
                    {
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        NSString *address = [NSString stringWithFormat:@"%@, %@", [placemark locality], [placemark country]];
                        
                        [HDRCurrentUser setAddress:address];
                    }
                }];
                
                
                
            }
        }
    }
}

@end
