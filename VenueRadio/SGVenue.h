//
//  SGVenue.h
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>

//Sample
//{
//    "city": "San Francisco",
//    "name": "Candlestick Park",
//    "extended_address": "San Francisco, CA 94124",
//    "url": "http:\/\/seatgeek.com\/venues\/candlestick-park\/tickets\/",
//    "country": "US",
//    "display_location": "San Francisco, CA",
//    "links": [
//    
//    ],
//    "slug": "candlestick-park",
//    "state": "CA",
//    "score": 0.96169,
//    "postal_code": "94124",
//    "location": {
//        "lat": 37.711,
//        "lon": -122.386
//    },
//    "address": "490 Jamestown Ave",
//    "timezone": "America\/Los_Angeles",
//    "id": 1132
//},

@interface SGVenue : NSObject

@property (nonatomic, assign) int       sgId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *slug;

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, assign) NSString *zipcode;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;

@property (nonatomic, assign) float     score;
@property (nonatomic, strong) NSString *timezone;

@property (nonatomic, strong) NSURL    *url;

@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, assign) BOOL eventsLoaded;

// instance methods

//- (void) fetchEventsWithSuccess:(void (^)(SGVenue *venue))success
//                        failure:(void (^)(NSError *error))failure;
//- (void) fetchEventsForPage:(int)pageNum
//                    success:(void (^)(SGVenue *venue))success
//                    failure:(void (^)(NSError *error))failure;

- (void) loadMoreEventsWithSuccess:(void (^)())success
                           failure:(void (^)(NSError *error))failure;

//
// class methods
//

+ (void) initMappings;
+ (RKObjectMapping *) mapping;

+ (void) getVenueById:(int)sgId
              success:(void (^)(SGVenue *venue))success
              failure:(void (^)(NSError *error))failure;

+ (void) searchVenuesByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure;
+ (void) searchVenuesByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum;


+ (void) getVenuesForCity:(NSString *)city
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure;
+ (void) getVenuesForCity:(NSString *)city
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;

// state should be two letter abbreviation e.g. "TX"
+ (void) getVenueForState:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure;
+ (void) getVenueForState:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;

// state should be two letter abbreviation e.g. "TX"
+ (void) getVenueForZipcode:(NSString *)zipcode
                    success:(void (^)(NSArray *venues))success
                    failure:(void (^)(NSError *error))failure;
+ (void) getVenueForZipcode:(NSString *)zipcode
                    success:(void (^)(NSArray *venues))success
                    failure:(void (^)(NSError *error))failure
                       page:(int)pageNum;

+ (void) getVenuesForCountry:(NSString *)country
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure;
+ (void) getVenuesForCountry:(NSString *)country
                     success:(void (^)(NSArray *venues))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum;

+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure;
+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;

+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  country:(NSString *)country
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure;
+ (void) getVenuesForCity:(NSString *)city
                    state:(NSString *)state
                  country:(NSString *)country
                  success:(void (^)(NSArray *venues))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;


//+ (void) getVenueById:(int)sgId
//              success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//              failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//+ (void) searchVenuesByQuery:(NSString *)searchString
//                     success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                     failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//+ (void) getVenuesForCity:(NSString *)city
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//// state should be two letter abbreviation e.g. "TX"
//+ (void) getVenueForState:(NSString *)state
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//// state should be two letter abbreviation e.g. "TX"
//+ (void) getVenueForZipcode:(NSString *)zipcode
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//+ (void) getVenuesForCountry:(NSString *)country
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//+ (void) getVenuesForCity:(NSString *)city
//                    state:(NSString *)state
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
//
//+ (void) getVenuesForCity:(NSString *)city
//                    state:(NSString *)state
//                  country:(NSString *)country
//                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
//                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;




@end
