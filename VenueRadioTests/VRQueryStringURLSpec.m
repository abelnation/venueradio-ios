//
//  VRQueryStringURLSpec.m
//  VenueRadio
//
//  Created by Abel Allison on 3/31/14.
//  Copyright (c) 2014 GrooveMechanic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Kiwi.h"

#import "VRQueryStringURL.h"

SPEC_BEGIN(VRQueryStringURLSpec)

describe(@"VRQueryStringURL", ^{
	it(@"Simple example (1 param) should not have ampersand", ^{
        NSDictionary *params =
            @{
              @"foo": @"bar",
              };
        
        NSURL *url = [VRQueryStringURL URLWithString: @"http://google.com" params: params];
        
        [[url.absoluteString should] matchPattern: @"^http://google\\.com\\?foo=bar$"];
	});
    
    it(@"Simple example (2 params)", ^{
        NSDictionary *params =
            @{
              @"foo": @"bar",
              @"baz": @"gab"
              };
        
        NSURL *url = [VRQueryStringURL URLWithString: @"http://google.com" params: params];
        
        [[url.absoluteString should] matchPattern: @"http://google\\.com\\?(foo=bar&baz=gab)|(baz=gab&foo=bar)"];
	});
    
    it(@"Can handle NSNumber", ^{
        NSURL *url;
        NSDictionary *params = @{ @"foo": @123 };
        
        // Empty dict provided
        url = [VRQueryStringURL URLWithString: @"http://google.com" params: params];
        [[url.absoluteString should] matchPattern: @"http://google\\.com\\?foo=123"];

        params = @{ @"foo": @1.234 };
        url = [VRQueryStringURL URLWithString: @"http://google.com" params: params];
        [[url.absoluteString should] matchPattern: @"http://google\\.com\\?foo=1.234"];
    });
    
    it(@"Equals base url when no params provided", ^{
        // Nil provided
        NSURL *url = [VRQueryStringURL URLWithString: @"http://google.com" params: nil];
        [[url.absoluteString should] matchPattern: @"http://google\\.com"];
        
        // Empty dict provided
        NSDictionary *params = @{};
        url = [VRQueryStringURL URLWithString: @"http://google.com" params: params];
        [[url.absoluteString should] matchPattern: @"http://google\\.com"];
        
        url = [VRQueryStringURL URLWithString: @"http://www.yahoo.com/" params: params];
        [[url.absoluteString should] matchPattern: @"http://www.yahoo.com/"];
    });    
    
    it(@"Is nil for invalid urls", ^{
        NSDictionary *params =
        @{
          @"foo": @"bar",
          @"baz": @"gab"
          };
        
        // Nil URL
        NSURL *url = [VRQueryStringURL URLWithString: nil params: params];
        [[url.absoluteString should] beNil];
        
        // Invalid URL
        url = [VRQueryStringURL URLWithString: @"httfart:\\invalid,.com" params: params];
        [[url.absoluteString should] beNil];
	});
});

SPEC_END