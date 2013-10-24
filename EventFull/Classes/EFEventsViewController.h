//
//  EFEventsViewController.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @class
 
 Displays an array of events<EFEntityEvent> objects
*/
@interface EFEventsViewController : UITableViewController

/**
 Initializes the controller with an array of events
*/
- (id)initWithEvents:(NSArray*)events;

/**
 @property
 Initial event array
*/
@property(nonatomic,readonly) NSArray *events;

@end
