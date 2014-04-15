//
//  SGVenueSpec.m
//  VenueRadio
//
//  Created by Abel Allison on 4/13/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>

#import "Kiwi.h"
#import "Nocilla.h"

#import "SGVenue.h"

SPEC_BEGIN(SGVenueSpec)

NSURL *seatGeekApiUrl = [NSURL URLWithString:@"http://api.seatgeek.com/2/"];

describe(@"SGVenue", ^{
    
    __block NSBundle *testTargetBundle;
    
    beforeAll(^{
        // Set up bundle for fixture files
        testTargetBundle = [NSBundle bundleWithIdentifier:@"com.groovemechanic.VenueRadioTests"];
        [RKTestFixture setFixtureBundle:testTargetBundle];
        
        // Init object manager (normally done by SGProvider)
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:seatGeekApiUrl];
        [RKObjectManager setSharedManager:objectManager];
        
        [SGVenue initMappings];
        
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        NSLog(@"All tests done");
        [[LSNocilla sharedInstance] stop];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
	context(@"Simple valid query by cities", ^{
        __block NSURL *requestUrl;
        
        beforeEach(^{
            requestUrl = [NSURL URLWithString:@"venues?city=san-francisco&per_page=100&page=1" relativeToURL:seatGeekApiUrl];
            NSString *jsonString = [RKTestFixture stringWithContentsOfFixture:@"SGVenuesByCity.json"];
            NSLog(@"REQUEST: %@", requestUrl.absoluteString);
            stubRequest(@"GET", requestUrl.absoluteString)
                .andReturn(200)
                .withHeaders(@{ @"Content-Type": @"application/json" })
                .withBody(jsonString);
        });
        
        it(@"Parses venue from json fixture", ^{
            __block NSArray *venues = nil;
            __block SGVenue *venue = nil;
            
            [SGVenue getVenuesForCity:@"San Francisco" success:^(NSArray *venuesResult) {
                NSLog(@"venues received");
                venues = venuesResult;
            } failure:^(NSError *error) {
                venues = nil;
            }];
            
            [[expectFutureValue(venues) shouldEventually] beNonNil];
            [[expectFutureValue(theValue(venues.count)) shouldEventually] equal:theValue(10)];
            
            venue = [venues objectAtIndex:0];
            [[expectFutureValue(venue) shouldEventually] beNonNil];
            [[expectFutureValue(venue.name) shouldEventually] equal:@"Candlestick Park"];
        });
    });
    
});

SPEC_END