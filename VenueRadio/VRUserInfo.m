//
//  VRUserInfo.m
//  VenueRadio
//
//  Created by Abel Allison on 4/6/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <MapKit/MapKit.h>

#import <AddressBook/AddressBook.h>

#import "VRUserInfo.h"



@interface VRUserInfo ()

@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *placemark;

@end

@implementation VRUserInfo

-(id) init {
    self = [super init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"Location services enabled");

        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            NSLog(@"Location services authorized");
        } else {
            NSLog(@"Location services not authorized");
        }
    } else {
        NSLog(@"Location services not enabled");
    }

    
    
    return self;
}

-(void) initUserLocation {
    self.geoCoder = [[CLGeocoder alloc] init];
    
    [self.geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error) {
            NSLog(@"ERROR geocoder: %@", error);
        }
        
        self.placemark = [placemarks objectAtIndex:0];
        NSLog(@"%@", (NSString *)kABPersonAddressCityKey);
        NSLog(@"placemark: %@", self.placemark);
        
        self.city = [self.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressCityKey];
        self.state = [self.placemark.addressDictionary valueForKey:(NSString *)kABPersonAddressStateKey];
        NSLog(@"City: %@\rState: %@", self.city, self.state);
        
        NSLog(@"Stopping location updates...");
        [self.locationManager stopUpdatingLocation];
    }];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        NSLog(@"Location services authorized!");
        [self.locationManager startUpdatingLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Location manager updated location: %@", locations);
    [self initUserLocation];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"ERROR Location manager: %@", error);
}

@end