//
//  EFEventImage.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-19.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFEventImage : NSObject

/** @abstract image URL */
@property(nonatomic,strong) NSString *url;

/** @abstract image width */
@property(nonatomic,assign) CGFloat width;

/** @abstract image height */
@property(nonatomic,assign) CGFloat height;

@end
