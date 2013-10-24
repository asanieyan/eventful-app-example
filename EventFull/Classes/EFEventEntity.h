//
//  EFEventEntity.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-19.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFVenueEntity;
@class EFEventImage;

@interface EFEventEntity : NSObject

/** @abstract Event ID **/
@property(nonatomic, strong) NSString *ID;

/** @abstract Event title */
@property(nonatomic,copy) NSString *title;

/** @abstract Event start time */
@property(nonatomic,strong) NSDate *startTime;

/** @abstract Event venue */
@property(nonatomic,strong) EFVenueEntity* venue;

/** @abstract Event performer */
@property(nonatomic,strong) EFPerformerEntity* performer;

/** @abstract Event image */
@property(nonatomic,readwrite) EFEventImage *image;

/** @abstract Event image */
@property(nonatomic,readwrite) EFEventImage *thumbImage;

@end
