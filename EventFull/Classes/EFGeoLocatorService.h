//
//  EFGeoLocatorService.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFGeoLocatorService;

/**
 Contains the a lat, long coordinates
 
 @todo better to use CLLocationCoordinate2D instead
*/
typedef struct EFLocationCoordinate {
    double latitude;
    double longitude;
} EFLocationCoordinate;

/**
 @protocol
 
 Service delegate allows communicating with the found
 results of a geocode
*/
@protocol EFGeoLocatorServiceDelegate <NSObject>

/**
 @method
 
 Called upon succesful geocoding
*/
- (void)geoLocatorService:(EFGeoLocatorService*)locatorService
            didGeoLocateAddress:(NSString*)address geoCooridnate:(EFLocationCoordinate)geoCooridnate;

@end

/**
 @class
 
 A service class to geolocate using Google geolocator
*/
@interface EFGeoLocatorService : NSObject

/**
 @method
 
 Singletone
*/
+ (instancetype)sharedGeoLocator;

/**
 @method
 
 Instantiate a serivce with a passed URL by default the 
 URL is set to http://maps.googleapis.com/maps/api/geocode/json
*/
- (id)initWithServiceURL:(NSURL*)url;

/**
 @property
 
 Service URL. By default it is set to  http://maps.googleapis.com/maps/api/geocode/json
*/
@property(nonatomic, readonly) NSURL *serviceURL;

//delegate
@property(nonatomic, assign) id<EFGeoLocatorServiceDelegate> delegate;

/**
 @method
 
 A blocking method that geocodes an address. This should not be called in the main thread
 to update the UI using this value use the delegate method as it will be dispathced on the 
 main thread
 
 @return Returns a EFLocationCoordinate of the address. If not found then
 both the latitude and longitude of the returned coordinates are set to NSNotFound
*/
- (EFLocationCoordinate)geoLocateAddress:(NSString*)address;

@end
