//
//  EFEventEntityCell.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @category
 
 Creates a category on EFEventEntity to conform to NICellObject @protocol 
 
 This transforms an event object to a model to be used within a cell view
*/
@interface EFEventEntity (NICellObject) <NICellObject>

@end

/**
 Represents a cell view of an event

*/
@interface EFEventEntityCell : UITableViewCell <NICell>

@property(nonatomic,readwrite) IBOutlet NINetworkImageView *eventImage;
@property(nonatomic,readwrite) IBOutlet UILabel *titleLabel;
@property(nonatomic,readwrite) IBOutlet UILabel *venueLabel;
@property(nonatomic,readwrite) IBOutlet UILabel *artistLabel;
@property(nonatomic,readwrite) IBOutlet UILabel *dateLabel;

@end
