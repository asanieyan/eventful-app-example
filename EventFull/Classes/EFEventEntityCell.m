//
//  EFEventEntityCell.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-22.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFEventEntityCell.h"

@implementation EFEventEntity(NICellObject)

- (Class)cellClass {
    return [EFEventEntityCell class];
}

- (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleDefault;
}

@end

@interface EFEventEntityCell()

/**
 static date formatter
*/
+ (NSDateFormatter*)dateFormatter;

@end


@implementation EFEventEntityCell

+ (NSDateFormatter*)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd\nEEEE"];
    });
    return dateFormatter;
}

- (BOOL)shouldUpdateCellWithObject:(EFEventEntity*)event
{
    self.titleLabel.text = event.title;
    [self.eventImage setImageWithURL:[NSURL URLWithString:event.thumbImage.url] placeholderImage:nil];
    self.artistLabel.text = event.performer.name;
    NSString *date = [EFEventEntityCell.dateFormatter stringFromDate:event.startTime];

    self.dateLabel.text   = date;
    return YES;
}

@end
