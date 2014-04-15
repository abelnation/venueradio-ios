//
//  VRQueryStringURL.h
//  VenueRadio
//
//  Created by Abel Allison on 3/31/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRQueryStringURL : NSURL

+ (id)URLWithString:(NSString *)URLString params:(NSDictionary *)params;
+ (NSDictionary *)paramsDictFromURL:(NSURL *)url;

@end
