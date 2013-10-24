//
//  EFMessageCell.h
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @class
 
 Provides an interface to add/remove messages for a cell
*/
@interface EFMessageCellObject : NSObject<NICellObject>

/**
 @property
 
 Sets the message to be displayed
 
 @todo use a message object so we can set a type
*/
@property(nonatomic,copy) NSString *message;

@end

@interface EFMessageCell : UITableViewCell<NICell>

@end
