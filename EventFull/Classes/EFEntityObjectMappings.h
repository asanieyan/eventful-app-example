//
//  EFEntityObjectMapping.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-21.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EFVenueEntity.h"
#import "EFEventImage.h"
#import "EFPerformerEntity.h"    
#import "EFEventEntity.h"

@class RKObjectMapping;

/**
@class

Object Manager

Performs some initlizing tasks.
*/
@interface EFObjectManager : RKObjectManager

/**
 @method

 Instantiate and return a shared manager
 
 @return EFObjectManager
*/
+ (EFObjectManager*)managerWithBaseURL:(NSURL *)baseURL withAppKey:(NSString*)appKey;

/** Eventful App Key */
@property(nonatomic,readonly) NSString *appKey;

@end

/**
 @protocol
 
 Interface for defining a object mapping for an entity object.
*/
@protocol EFObjectEntity <NSObject>

/**
 @method
 
 Return an object mapping for the entity
 
 @return RKObjectMapping
*/
+ (RKObjectMapping*)objectMapping;

@optional

/**
 @method
 
 Return an object descriptor
 
 @return RKResponseDescriptor
*/
+ (RKResponseDescriptor*)responseDescriptor;

@end

/**
 @category

 Conforms to EFObjectEntity @protocol and map attributes to the remote data
*/
@interface EFEventEntity(EFObjectEntityProtocol) <EFObjectEntity>
@end

/**
 @category

 Conforms to EFObjectEntity @protocol and map attributes to the remote data
*/
@interface EFVenueEntity(EFObjectEntity) <EFObjectEntity>
@end

/**
 @category

 Conforms to EFObjectEntity @protocol and map attributes to the remote data
*/
@interface EFEventImage(EFObjectEntity) <EFObjectEntity>
@end

/**
 @category

 Conforms to EFObjectEntity @protocol and map attributes to the remote data
*/
@interface EFPerformerEntity(EFObjectEntity) <EFObjectEntity>
@end

/**
 @category

 Conforms to EFObjectEntity @protocol and map attributes to the remote data
*/
@interface RKPaginator(EFObjectEntity) <EFObjectEntity>
@end