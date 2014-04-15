//
//  SGEvent.m
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "SGEvent.h"
#import "SGVenue.h"
#import "SGPerformer.h"
#import "SGProvider.h"

@implementation SGEvent

+ (void) initMappings {
    RKObjectMapping* eventMapping = [RKObjectMapping mappingForClass:[SGEvent class]];
    [eventMapping addAttributeMappingsFromDictionary:[SGEvent elementToPropertyMappings]];

    // Set up SGVenue dynamic relationship
    RKRelationshipMapping *venueRelationshipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"venue"
                                                    toKeyPath:@"venue"
                                                  withMapping:[SGVenue mapping]];
    [eventMapping addPropertyMapping:venueRelationshipMapping];
    
    // Set up SGEvent dynamic relationship
    RKRelationshipMapping *performersRelationshipMapping =
        [RKRelationshipMapping relationshipMappingFromKeyPath:@"performers"
                                                    toKeyPath:@"performers"
                                                  withMapping:[SGPerformer mapping]];
    [eventMapping addPropertyMapping:performersRelationshipMapping];
    
    RKResponseDescriptor *eventResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:eventMapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"events"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[SGProvider sharedObjectManager] addResponseDescriptor:eventResponseDescriptor];
}

+ (NSDictionary*)elementToPropertyMappings {
    return @{
             @"id": @"sgId",
             @"title": @"title",
             @"type": @"type",
             @"datetime_local": @"datetimeLocal",
             @"score": @"score",
             @"url": @"url",
            };
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ @ %@\r%@", self.title, self.venue, self.performers];
}

+ (void) getEventById:(int)sgId
              success:(void (^)(NSArray *events))success
              failure:(void (^)(NSError *error))failure
                 page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"events"
                                            parameters:@{
                                                         @"id": [NSNumber numberWithInt:sgId],
                                                         @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success([mappingResult.array objectAtIndex:0]);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}
+ (void) getEventById:(int)sgId
              success:(void (^)(NSArray *events))success
              failure:(void (^)(NSError *error))failure {
    [SGEvent getEventById:sgId success:success failure:failure page:1];
}


+ (void) searchEventsByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"events"
                                            parameters:@{ @"q": searchString,
                                                          @"taxonomies.name": @"concert",
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}
+ (void) searchEventsByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure {
    [SGEvent searchEventsByQuery:searchString success:success failure:failure page:1];
}

+ (void) getEventsForCity:(NSString *)city
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"events"
                                            parameters:@{ @"venue.city": sgCity,
                                                          @"taxonomies.name": @"concert",
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}
+ (void) getEventsForCity:(NSString *)city
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure {
    [SGEvent getEventsForCity:city success:success failure:failure page:1];
}

+ (void) getEventsForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum {
    NSString *sgCity = [[city lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"events"
                                            parameters:@{ @"venue.city": sgCity,
                                                          @"venue.state": state,
                                                          @"taxonomies.name": @"concert",
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}
+ (void) getEventsForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure {
    [SGEvent getEventsForCity:city state:state success:success failure:failure page:1];
}

+ (void) getEventsForVenueId:(int)sgVenueId
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"events"
                                            parameters:@{ @"venue.id": [NSNumber numberWithInt:sgVenueId],
                                                          @"taxonomies.name": @"concert",
                                                          @"page": [NSNumber numberWithInt:pageNum] }
                                               success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                   success(mappingResult.array);
                                               }
                                               failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                   failure(error);
                                               }];
}
+ (void) getEventsForVenueId:(int)sgVenueId
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure {
    [SGEvent getEventsForVenueId:sgVenueId success:success failure:failure page:1];
}

@end
