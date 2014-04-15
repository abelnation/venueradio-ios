//
//  SGPerformer.m
//  RestKitHello
//
//  Created by Abel Allison on 4/5/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "SGPerformer.h"
#import "SGProvider.h"

static RKObjectMapping *_mapping = nil;

@implementation SGPerformer

+ (void) initMappings {
    _mapping = [RKObjectMapping mappingForClass:[SGPerformer class]];
    [_mapping addAttributeMappingsFromDictionary:@{
                                                         @"id": @"sgId",
                                                         @"name": @"name",
                                                         @"short_name": @"shortName",
                                                         @"slug": @"slug",
                                                         @"type": @"type",
                                                         @"image": @"imageUrl",
                                                         @"url": @"url",
                                                         @"score": @"score",
                                                         }];
    RKResponseDescriptor *performerResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:_mapping
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"performers"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[SGProvider sharedObjectManager] addResponseDescriptor:performerResponseDescriptor];
}

+ (RKObjectMapping *) mapping {
    return _mapping;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ (%d)", self.name, self.sgId];
}

+ (void) getPerformerById:(int)sgId
                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"performers"
                                            parameters:@{ @"id": [NSNumber numberWithInt:sgId] }
                                               success:success
                                               failure:failure];
}

+ (void) searchPerformersByQuery:(NSString *)searchString
                         success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                         failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"performers"
                                            parameters:@{ @"q": searchString,
                                                          @"taxonomies.name": @"concert" }
                                               success:success
                                               failure:failure];
}

+ (void) getPerformersForSlug:(NSString *)slug
                      success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure {
    [[SGProvider sharedObjectManager] getObjectsAtPath:@"performers"
                                            parameters:@{ @"slug": slug,
                                                          @"taxonomies.name": @"concert" }
                                               success:success
                                               failure:failure];
}

@end
