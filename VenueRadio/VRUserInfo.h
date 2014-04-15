//
//  VRUserInfo.h
//  VenueRadio
//
//  Created by Abel Allison on 4/6/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface VRUserInfo : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *stateAbbreviation;

@end
