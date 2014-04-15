//
//  SGPerformer.h
//  RestKitHello
//
//  Created by Abel Allison on 4/5/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>

// Sample JSON
//{
//    "name": "Emmylou Harris",
//    "short_name": "Emmylou Harris",
//    "url": "http:\/\/seatgeek.com\/emmylou-harris-tickets",
//    "type": "band",
//    "image": "http:\/\/cdn.chairnerd.com\/images\/performers-landscape\/emmylou-harris-5dd90e\/687\/huge.jpg",
//    "primary": true,
//    "home_venue_id": null,
//    "slug": "emmylou-harris",
//    "score": 0.46867,
//    "images": {
//        "huge": "http:\/\/cdn.chairnerd.com\/images\/performers-landscape\/emmylou-harris-5dd90e\/687\/huge.jpg",
//        "medium": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-32759e\/medium.jpg",
//        "large": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-76581c\/large.jpg",
//        "small": "http:\/\/cdn.chairnerd.com\/images\/performers\/687\/emmylou-harris-314e63\/small.jpg"
//    },
//    "id": 687
//}

@interface SGPerformer : NSObject

@property (nonatomic, assign) int       sgId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSURL    *imageUrl;
@property (nonatomic, strong) NSURL    *url;

@property (nonatomic, assign) float     score;

+ (void) initMappings;
+ (RKObjectMapping *) mapping;

+ (void) getPerformerById:(int)sgId
                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void) searchPerformersByQuery:(NSString *)searchString
                         success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                         failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+ (void) getPerformersForSlug:(NSString *)city
                      success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                      failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;


@end
