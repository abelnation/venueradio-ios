//
//  VRQueryStringURL.m
//  VenueRadio
//
//  Created by Abel Allison on 3/31/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import "VRQueryStringURL.h"

@implementation VRQueryStringURL

+ (id)URLWithString:(NSString *)URLString params:(NSDictionary *)params {
    
    NSURL *baseURL = [NSURL URLWithString:URLString];
    if (baseURL == nil) {
        return nil;
    }
    if (params == nil) {
        return baseURL;
    }
    
    NSMutableArray *pairs = [[NSMutableArray alloc] init];
    for(id key in params) {
        NSString *escapedKey =   [[NSString stringWithFormat:@"%@", key]
                                  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *escapedValue = [[NSString stringWithFormat:@"%@", [params objectForKey:key]]
                                  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", escapedKey, escapedValue]];
    }
    NSString *queryString = [pairs componentsJoinedByString:@"&"];
    
    NSString *fullURL = [NSString stringWithFormat:@"%@?%@", URLString, queryString];

    return [NSURL URLWithString:fullURL];
}

+ (NSDictionary *)paramsDictFromURL:(NSURL *)url {
    #warning STUB
    return @{};
}

@end
