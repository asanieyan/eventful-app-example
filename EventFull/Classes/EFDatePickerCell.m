//
//  EFDatePickerCell.m
//  EventFull
//
//  Created by Arash  Sanieyan on 2013-10-20.
//  Copyright (c) 2013 GeekLab. All rights reserved.
//

#import "EFDatePickerCell.h"

void EFTextFieldInputViewWithPickerView(UITextField *textField, UIView* pickerView)
{
    CGFloat toolbarHeight = NIToolbarHeightForOrientation(UIInterfaceOrientationPortrait);
    CGSize  pickerSize    = pickerView.frame.size;
    
    //add a done button to the input view
    UIView *inputView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerSize.width, pickerSize.height + toolbarHeight)];

    UIToolbar *toolar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerSize.width, toolbarHeight)];
    toolar.items = @[
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "Done button") style:UIBarButtonItemStyleDone target:textField action:@selector(resignFirstResponder)]
    ];
    //shift picker down
    pickerView.frame = CGRectOffset(pickerView.frame, 0, toolbarHeight);
    [inputView addSubview:toolar];
    [inputView addSubview:pickerView];
    textField.inputView = inputView;
}

@implementation EFDatePickerFormElement

- (Class)cellClass
{
    return [EFDatePickerCell class];
}

@end

/**
 Repalce the text field input view
*/

@interface EFDatePickerCell()


@end

@implementation EFDatePickerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
         EFTextFieldInputViewWithPickerView(self.dateField, self.datePicker);
        self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(EFDatePickerFormElement*)object
{
    BOOL update = [super shouldUpdateCellWithObject:object];
    if ( update ) {
        if ( object.adjustDateUsingDatePickerElement )
        {
            [RACObserve(object.adjustDateUsingDatePickerElement, date) subscribeNext:^(NSDate *date) {
                [self adjustValueDate];
            }];
        }
    }
    return update;
}

- (void)adjustValueDate
{
    //use the adjustDateDatePickerElement value to adjust the current
    //for example use the start the date to set the end date
    NSDate *date = [(EFDatePickerFormElement*)self.element adjustDateUsingDatePickerElement].date;
    if ( date ) {
        date = [date dateByAddingTimeInterval:60 * 60 * 24 ];
        [(EFDatePickerFormElement*)self.element setDate:date];
        //set both the min date and the date
        self.datePicker.minimumDate = date;
        self.datePicker.date = date;
        self.dateField.text  = [NSDateFormatter localizedStringFromDate:self.datePicker.date
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterNoStyle];

        [self setValue:self.dateField.text forKeyPath:@"dumbDateField.text"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
