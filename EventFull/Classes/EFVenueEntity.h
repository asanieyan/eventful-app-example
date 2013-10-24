//
//  EFVenueEntity.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-19.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFVenueEntity : NSObject

/** @abstract Venue ID **/
@property(nonatomic, strong) NSString *ID;

/** @abstract Venue address **/
@property(nonatomic, strong) NSString *address;

/** @abstract Venue name **/
@property(nonatomic, strong) NSString *name;

@end
