//
//  SGProvider.m
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "SGProvider.h"
#import "SGVenue.h"
#import "SGPerformer.h"
#import "SGEvent.h"

//////////////////////////////////
// Shared Instance

static RKObjectManager *sharedManager = nil;

@interface SGProvider()

@end

@implementation SGProvider

+ (void) initialize {
    // RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://api.seatgeek.com/2/"]];
    
    // Set shared manager if nil
    if (nil == sharedManager) {
        [SGProvider setSharedObjectManager:objectManager];
    }

    [SGVenue initMappings];
    [SGPerformer initMappings];
    [SGEvent initMappings];
}

/**
 Return the shared instance of the object manager
 
 @return The shared manager instance.
 */
+ (RKObjectManager *)sharedObjectManager {
    return sharedManager;
}

/**
 Set the shared instance of the object manager
 
 @param manager The new shared manager instance.
 */
+ (void)setSharedObjectManager:(RKObjectManager *)manager {
    sharedManager = manager;
}

@end
