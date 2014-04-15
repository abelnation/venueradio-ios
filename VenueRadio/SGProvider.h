//
//  SGProvider.h
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGProvider : NSObject

@property (nonatomic, strong) SGProvider *sharedInstance;

+ (void)initialize;

/**
 Return the shared instance of the object manager
 
 @return The shared manager instance.
 */
+ (RKObjectManager *)sharedObjectManager;

/**
 Set the shared instance of the object manager
 
 @param manager The new shared manager instance.
 */
+ (void)setSharedObjectManager:(RKObjectManager *)manager;

@end
