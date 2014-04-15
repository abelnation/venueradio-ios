//
//  SGEvent.h
//  RestKitHello
//
//  Created by Abel Allison on 4/4/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>

// Sample JSON
//{
//    "links": [
//    
//    ],
//    "id": 1991093,
//    "stats": {
//        "listing_count": 4,
//        "average_price": 267,
//        "lowest_price": 152,
//        "highest_price": 278
//    },
//    "title": "Emmylou Harris",
//    "announce_date": "2014-02-05T16:42:44",
//    "score": 0.48908,
//    "date_tbd": false,
//    "type": "concert",
//    "datetime_local": "2014-04-05T20:00:00",
//    "visible_until_utc": "2014-04-06T07:00:00",
//    "time_tbd": false,
//    "taxonomies": [
//                   {
//                       "parent_id": null,
//                       "id": 2000000,
//                       "name": "concert"
//                   }
//                   ],
//    "performers": [
//                   {
//                       "name": "Emmylou Harris",
//                       "short_name": "Emmylou Harris",
//                       "url": "http:\/\/seatgeek.com\/emmylou-harris-tickets",
//                       "type": "band",
//                       "image": "http:\/\/cdn.chairnerd.com\/images\/performers-landscape\/emmylou-harris-5dd90e\/687\/huge.jpg",
//                       "primary": true,
//                       "home_venue_id": null,
//                       "slug": "emmylou-harris",
//                       "score": 0.46867,
//                       "images": {
//                           "huge": "http:\/\/cdn.chairnerd.com\/images\/performers-landscape\/emmylou-harris-5dd90e\/687\/huge.jpg",
//                           "medium": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-32759e\/medium.jpg",
//                           "large": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-76581c\/large.jpg",
//                           "small": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-314e63\/small.jpg"
//                       },
//                       "id": 687
//                   }
//                   ],
//    "url": "http:\/\/seatgeek.com\/emmylou-harris-tickets\/san-francisco-california-the-warfield-2014-04-05-8-pm\/concert\/1991093\/",
//    "created_at": "2014-02-05T16:42:44",
//    "venue": {
//        "city": "San Francisco",
//        "name": "The Warfield",
//        "extended_address": "San Francisco, CA 94102",
//        "url": "http:\/\/seatgeek.com\/venues\/the-warfield\/tickets\/",
//        "country": "US",
//        "display_location": "San Francisco, CA",
//        "links": [
//        
//        ],
//        "slug": "the-warfield",
//        "state": "CA",
//        "score": 0.6312,
//        "postal_code": "94102",
//        "location": {
//            "lat": 37.7825,
//            "lon": -122.41
//        },
//        "address": "982 Market Street",
//        "timezone": "America\/Los_Angeles",
//        "id": 524
//    },
//    "short_title": "Emmylou Harris",
//    "datetime_utc": "2014-04-06T03:00:00",
//    "datetime_tbd": false
//},


@class SGVenue;

@interface SGEvent : NSObject

@property (nonatomic, assign) int       sgId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSArray  *performers;
@property (nonatomic, strong) SGVenue  *venue;
@property (nonatomic, strong) NSDate   *datetimeLocal;

@property (nonatomic, assign) float     score;
@property (nonatomic, strong) NSURL    *url;

+ (void) initMappings;

+ (void) getEventById:(int)sgId
              success:(void (^)(NSArray *events))success
              failure:(void (^)(NSError *error))failure
                 page:(int)pageNum;
+ (void) getEventById:(int)sgId
              success:(void (^)(NSArray *events))success
              failure:(void (^)(NSError *error))failure;

+ (void) searchEventsByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure
                        page:(int)pageNum;
+ (void) searchEventsByQuery:(NSString *)searchString
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure;

+ (void) getEventsForCity:(NSString *)city
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;
+ (void) getEventsForCity:(NSString *)city
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure;

+ (void) getEventsForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;
+ (void) getEventsForCity:(NSString *)city
                    state:(NSString *)state
                  success:(void (^)(NSArray *events))success
                  failure:(void (^)(NSError *error))failure;

+ (void) getEventsForVenueId:(int)sgVenueId
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure
                     page:(int)pageNum;
+ (void) getEventsForVenueId:(int)sgVenueId
                     success:(void (^)(NSArray *events))success
                     failure:(void (^)(NSError *error))failure;


@end
