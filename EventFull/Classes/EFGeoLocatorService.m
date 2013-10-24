//
//  EFGeoLocatorService.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFGeoLocatorService.h"

@interface EFGeoLocatorService()

@property(nonatomic,readwrite) NSURL *serviceURL;

@end

@implementation EFGeoLocatorService

+ (instancetype)sharedGeoLocator
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)initWithServiceURL:(NSURL *)url
{
    if ( self = [super init] ) {
        self.serviceURL = url;
    }    
    return self;
}

- (id)init
{
    if ( self = [super init] ) {
        self.serviceURL = [NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode/json"];
    }
    return self;
}

- (EFLocationCoordinate)geoLocateAddress:(NSString *)address
{
    address =  (__bridge_transfer NSString*) CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)(address), NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"%@?address=%@&sensor=false",
        self.serviceURL.absoluteString,
        address
    ];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strURL]];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation start];
    [operation waitUntilFinished];
    NSArray *results = [operation.responseJSON valueForKey:@"results"];
    EFLocationCoordinate loc = {NSNotFound, NSNotFound};
    if ( results.count > 0 ) {
        //lets just use the first result
        NSDictionary *location = [[results objectAtIndex:0] valueForKeyPath:@"geometry.location"];
        if ( location ) {
            loc.latitude  = [[location valueForKey:@"lat"] doubleValue];
            loc.longitude = [[location valueForKey:@"lng"] doubleValue];
        }
    }
    if ( [self.delegate
        respondsToSelector:@selector(geoLocatorService:didGeoLocateAddress:geoCooridnate:)] ) {
        @weakify(self);
        dispatch_sync(dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.delegate geoLocatorService:self didGeoLocateAddress:address geoCooridnate:loc];
        });
    }
    return loc;
}

@end
