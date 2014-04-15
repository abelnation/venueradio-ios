//
//  SGVenue.m
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "SGVenue.h"
#import "SGEvent.h"
#import "SGProvider.h"

static RKObjectMapping *_mapping = nil;
static int resultsPerPage = 20;
static NSString *SGVenuesPath = @"venues";

@interface SGVenue ()

@property (nonatomic, assign) int latestPage;
@property (nonatomic, assign) int pendingPage;

@end

@implementation SGVenue

- (void) loadMoreEventsWithSuccess:(void (^)())success
                           failure:(void (^)(NSError *error))failure {

    NSLog(@"loadMoreEvents (venueId: %d", self.sgId);
    
    int newPage = self.latestPage + 1;
    if (newPage <= self.pendingPage) {
        return;
    }
    
    // To prevent multiple reloads for the same chunk
    self.pendingPage = newPage;
    
    [SGEvent getEventsForVenueId:self.sgId
                         success:^(NSArray *events) {
                             
                             if (events.count == 0) {
                                 NSLog(@"Events fully loaded!");
                                 self.eventsLoaded = YES;
                                 success();
                                 return;
                             } else {
                                 NSLog(@"Events loaded... (count: %lu", (unsigned long)events.count);
                                 self.latestPage = newPage;
                                 if(!self.events) {
                                     NSLog(@"creating events array");
                                     self.events = [[NSMutableArray alloc] initWithArray:events];
                                 } else {
                                     NSLog(@"adding elements to events array");
                                     [self.events addObjectsFromArray:events];
                                     NSLog(@"--> new size: %lu", self.events.count);
                                 }
                                 
                                 NSLog(@"Event count: %lu", (unsigned long)self.events.count);
                             }
                             
                             // RKLogInfo(@"Load collection of Venues: %@", self.venues);

                             success();
                         }
                         failure:^(NSError *error) {
                             failure(error);
                         }
                         page:newPage];
}

+ (void) initMappings {
    _mapping = [RKObjectMapping mappingForClass:[SGVenue class]];
    [_mapping addAttributeMappingsFromDictionary:@{
        @"id": @"sgId",
        @"name": @"name",
        @"slug": @"slug",
        @"address": @"address",
        @"state": @"state",
        @"postal_code": @"zipcode",
        @"city": @"city",
        @"country": @"country",
        @"score": @"score",
        @"timezone": @"timezone",
        @"url": @"url",
    }];
    RKResponseDescriptor *venueResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:SGVenuesPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[SGProvider sharedObjectManager] addResponseDescriptor:venueResponseDescriptor];
}

+ (RKObjectMapping *) mapping {
    return _mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%d)", self.name, self.sgId];
}

+ (void) getVenueById:(int)sgId
              success:(void (^)(SGVenue *venue))success
              failure:(void (^)(NSError *error))failure {
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"id": [NSNumber numberWithInt:sgId],
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success([mappingResult.array objectAtIndex:0]);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

+ (void) searchVenuesByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure {
    [SGVenue searchVenuesByQuery:searchString success:success failure:failure page:1];
}
+ (void) searchVenuesByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"q": searchString,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

+ (void) getVenuesForCity:(NSString *)city
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure {
    [SGVenue getVenuesForCity:city success:success failure:failure page:1];
}
+ (void) getVenuesForCity:(NSString *)city
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    
    NSLog(@"Get venues for city: %@", city);
    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"city": sgCity,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

// state should be two letter abbreviation e.g. "TX"
+ (void) getVenueForState:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure {
    [SGVenue getVenueForState:state success:success failure:failure page: 1];
}
+ (void) getVenueForState:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"state": state,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

// state should be two letter abbreviation e.g. "TX"
+ (void) getVenueForZipcode:(NSString *)zipcode
                    success:(void (^)(NSArray *venues))success
                    failure:(void (^)(NSError *error))failure {
    [SGVenue getVenueForZipcode:zipcode success:success failure:failure page:1];
}
+ (void) getVenueForZipcode:(NSString *)zipcode
                    success:(void (^)(NSArray *venues))success
                    failure:(void (^)(NSError *error))failure
                       page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"postal_code": zipcode,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

+ (void) getVenuesForCountry:(NSString *)country
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure {
    [SGVenue getVenuesForCountry:country success:success failure:failure page:0];
}
+ (void) getVenuesForCountry:(NSString *)country
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"country": country,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure {
    [SGVenue getVenuesForCity:city state:state success:success failure:failure page: 1];
}
+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"city": sgCity,
                                                          @"state": state,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  country:(NSString *)country
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure {
    [SGVenue getVenuesForCity:city state:state country:country success:success failure:failure page:1];
}
+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  country:(NSString *)country
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [[SGProvider sharedObjectManager] getObjectsAtPath:SGVenuesPath
                                            parameters:@{ @"city": sgCity,
                                                          @"state": state,
                                                          @"country": country,
                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage],
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}

//+ (void) getVenueById:(int)sgId
//              success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"id": [NSNumber numberWithInt:sgId],
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//+ (void) searchVenuesByQuery:(NSString *)searchString
//                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"q": searchString,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//+ (void) getVenuesForCity:(NSString *)city
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    
//    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
//    
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"city": sgCity,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//// state should be two letter abbreviation e.g. "TX"
//+ (void) getVenueForState:(NSString *)state
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"state": state,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//// state should be two letter abbreviation e.g. "TX"
//+ (void) getVenueForZipcode:(NSString *)zipcode
//                    success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                    failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"postal_code": zipcode,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//+ (void) getVenuesForCountry:(NSString *)country
//                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"country": country,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//+ (void) getVenuesForCity:(NSString *)city
//                    state:(NSString *)state
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"city": sgCity,
//                                                          @"state": state,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}
//
//+ (void) getVenuesForCity:(NSString *)city
//                    state:(NSString *)state
//                  country:(NSString *)country
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
//    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
//    [[SGProvider sharedObjectManager] getObjectsAtPath:@"venues"
//                                            parameters:@{ @"city": sgCity,
//                                                          @"state": state,
//                                                          @"country": country,
//                                                          @"per_page": [NSNumber numberWithInt:resultsPerPage] }
//                                               success:success
//                                               failure:failure];
//}

@end
