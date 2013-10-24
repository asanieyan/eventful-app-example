//
//  EFMessageCell.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-23.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFMessageCell.h"


@implementation EFMessageCellObject

- (Class)cellClass {
    return [EFMessageCell class];
}

@end

@interface EFMessageCell()

@property(nonatomic,strong) EFMessageCellObject *cellObject;

@end

@implementation EFMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.textLabel.font = [UIFont systemFontOfSize:12];
    self.textLabel.textColor = [UIColor redColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (BOOL)shouldUpdateCellWithObject:(id)object
{
    if ( object != self.cellObject )
    {
        self.cellObject = object;
        //observe the message
        RAC(self.textLabel, text) = RACObserve(self.cellObject, message);
        return YES;
    }
    return NO;
}

+ (CGFloat)heightForObject:(EFMessageCellObject*)object atIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    NSString *message = object.message;
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = [message sizeWithFont:font constrainedToSize:CGSizeMake(300, INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    return MAX(size.height, tableView.rowHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
